# LaTeX 踩坑速查

都是被咬过的。每条先说现象，再说怎么改。

## 一、求值竖线有四个档位

写 `\left. \frac{df}{dx} \right|_{x=0}` 出来的竖线常常太矮，压在分数线旁边像个小逗号。原因是 `\right|` 跟着分式的高度自动缩，但分式本身不高。

手动指定档位就行，从矮到高：

- `\big|` — 1.2 倍，单层分式
- `\Big|` — 1.8 倍，嵌套一层
- `\bigg|` — 2.4 倍，带上下限的求和
- `\Bigg|` — 3.0 倍，矩阵、连分式

效果对比：

$$\big| \quad \Big| \quad \bigg| \quad \Bigg|$$

我的经验值：**普通分式用 `\Big|`，带 `\sum` 下限的用 `\bigg|`**，很少需要 `\Bigg|`。

配套的小技巧：竖线前面加 `\,` 留 1/6 空格，否则会和分式粘在一起。

## 二、段落之间到底空多少

LaTeX 源码里敲几个回车都只算**一个**分段，段落间距由 `\parskip` 控制，默认是 0——所以看起来"没空行"是正常的，靠的是段首缩进区分段落。

想让段落之间空一行：

```latex
\setlength{\parskip}{0.8ex}
\setlength{\parindent}{0pt}
```

但要记住：**中文排版里段首缩进是规范，段间距是西式习惯**。两个都上会显得松散，选一个。

## 三、四阶标题自带一个点

`\subsubsection` 在 `article` 里编号形如 **1.2.3.4** 后面常常多一个点或者不编号，取决于文档类。想改成 `1.2.3.4 标题` 这种干净形式：

```latex
\usepackage{titlesec}
\titleformat{\subsubsection}{\normalfont\normalsize\bfseries}{\thesubsubsection}{1em}{}
```

如果根本不想要编号，用带星号的 `\subsubsection*` 就行，不用动宏包。

## 四、行内公式把行距撑开了

行内写 `$\dfrac{a}{b}$` 会让这一行的行距突然变大，整段看起来像被拉扯过。要么用 `\frac`（会自动缩成小号），要么给公式加 `\textstyle`：

$$\textstyle\frac{a}{b} \quad \text{vs} \quad \frac{a}{b}$$

## 五、编译顺序这件事

改了参考文献、目录、交叉引用之后，**要编译三遍**才稳定：第一遍收集编号，第二遍填进去，第三遍才收敛。用 `latexmk -pdf` 能自动帮你跑够次数。

## 六、中文断行

`ctex` 文档类默认允许在标点前后断行，但西文单词仍然整体不拆。遇到长英文单词撑破版心时，加

```latex
\hyphenation{long-word}
```

或者用 `\sloppy` 放宽断行标准（代价是词间距不齐）。
