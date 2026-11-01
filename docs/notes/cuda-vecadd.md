# CUDA 向量加法：一行代码背后的三件事

CPU 版的向量加法是一个循环：

```c
for (int i = 0; i < n; i++) c[i] = a[i] + b[i];
```

GPU 版没有循环，取而代之的是"每个线程负责一个元素"。这个转换只需要想清楚三件事：**我是谁、我在不在范围内、我访问的内存顺不顺**。

<DemoFrame src="/demos/cuda-vecadd.html" title="CUDA 向量加法工作原理" height="580px" />

## 一、我是谁：把线性下标拆成 grid / block / thread

```c
int i = blockIdx.x * blockDim.x + threadIdx.x;
```

- `threadIdx.x`：我在这个 block 里排第几（0 ~ blockDim.x-1）；
- `blockDim.x`：一个 block 有多少线程；
- `blockIdx.x`：我属于第几个 block。

三者一串就得到全局唯一编号。启动时用

```c
vecAdd<<<(n + 255) / 256, 256>>>(a, b, c, n);
```

意思是"每 256 个线程一组，向上取整，凑够 n 个线程"。注意这个向上取整很关键：n 不是 256 的倍数时，最后那个 block 里会有多余的线程。

## 二、我该不该干活：边界检查

```c
if (i < n) c[i] = a[i] + b[i];
```

没有这一行，多出来的线程会去写 `c[n]` 之后的内存——运气好是段错误，运气不好是悄悄改坏别人的数据。**这是 CUDA 新手的第一号崩溃来源**。

## 三、顺不顺：合并访存

同一个 warp（32 个线程）里，如果线程 0~31 访问的是连续 32 个 float，硬件能把它们合并成一次 128 字节的事务；如果这 32 个线程访问的是跨步 32 的元素，就变成 32 次独立事务，带宽直接掉到 1/32。

所以 `i = blockIdx.x * blockDim.x + threadIdx.x` 这个"相邻线程拿相邻下标"的写法不是习惯问题，是**性能要求**。二维索引时要特别注意：`threadIdx.x` 应该走最内层的维度。

| 写法 | 一个 warp 访问的地址 | 事务数 |
| --- | --- | ---: |
| `i = blockIdx.x * blockDim.x + threadIdx.x` | 连续 128 字节 | 1 |
| `i = (blockIdx.x * blockDim.x + threadIdx.x) * stride` | 跨步 32 × 4 字节 | 32 |

## 完整版本

```c
__global__ void vecAdd(const float* a, const float* b, float* c, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) {
        c[i] = a[i] + b[i];
    }
}

int main() {
    int n = 1 << 20;
    size_t bytes = n * sizeof(float);
    float *d_a, *d_b, *d_c;
    cudaMalloc(&d_a, bytes);
    cudaMalloc(&d_b, bytes);
    cudaMalloc(&d_c, bytes);
    // cudaMemcpy(...) 把数据搬上去
    vecAdd<<<(n + 255) / 256, 256>>>(d_a, d_b, d_c, n);
    // cudaMemcpy(...) 把结果搬下来
}
```

## 什么时候它其实不划算

向量加法是**访存受限**的：每个元素做 1 次加法、读写 3 次内存。就算 GPU 算力是 CPU 的 50 倍，只要 PCIe 显存拷贝的速度跟不上，端到端也快不了多少。所以真实场景里，加法通常不是单独调的 kernel，而是某个大 kernel 里的一行——**数据已经在显存里了，顺手算掉**。

想验证这一点：把 n 从 1 万改到 1000 万，测一下"含拷贝"和"不含拷贝"的耗时，两条曲线会差出一个数量级。
