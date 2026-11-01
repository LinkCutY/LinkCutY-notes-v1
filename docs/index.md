---
layout: home

hero:
  name: 奇怪小问题
  text: 想到哪写到哪的笔记本
  tagline: 纯 Markdown 写，GitHub Pages 发，改一行推一次就上线
  actions:
    - theme: brand
      text: 开始读
      link: /notes/
    - theme: alt
      text: 这个站怎么做的
      link: /about

features:
  - title: 只写 Markdown
    details: 新建一个 .md 文件，往 sidebar 里加一行，就是一篇新笔记。不用碰 HTML，也不用管路由。
  - title: 能塞交互演示
    details: 现成的单文件 HTML 演示直接丢进 public 目录，用 DemoFrame 嵌进正文，手机上也能点。
  - title: 长得像"正经站"
    details: 深浅色切换、全文搜索、页内目录、上一篇／下一篇、最后更新时间，都是现成的。
---

## 最近在写

- [一次加法在硬件里走完 11 步](/notes/csapp-add) — 从取指到写回，附可点开的流水线演示
- [4 个核，12 个进程](/notes/process-scheduler) — 时间片、上下文切换、调度器的取舍
- [CUDA 向量加法](/notes/cuda-vecadd) — grid / block / coalescing 三件套
- [LaTeX 踩坑速查](/notes/latex) — 竖线档位、段落换行、四阶标题

> 这块是手写的，想自动生成"最近更新"列表的话，加一个构建期脚本扫 `lastUpdated` 就能做到，不值得为四篇文章上这一层。
