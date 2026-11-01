# 这个站是怎么做的

一句话：**VitePress（一个静态站点生成器）+ GitHub Pages（免费托管）**。

## 为什么是这两个

| 方案 | 上手 | 要写代码吗 | 适合谁 |
| --- | --- | --- | --- |
| VitePress / Docusaurus | 装一次依赖 | 基本不用 | 想要文档站质感、有搜索、有侧边栏 |
| Hexo / Hugo | 装一次依赖 | 不用，但要选主题 | 想要博客流、按时间倒序 |
| Jekyll | 不用装（GitHub 内置） | 一点点 | 想少依赖，但本地预览要装 Ruby |
| Docsify | 不用装 | 不用，纯前端渲染 | 极简，一行 index.html 就能跑 |

选 VitePress 的理由很实际：Markdown 就是最终形态，构建产物是纯静态文件，**没有任何后端**，所以能白嫖 GitHub Pages，而且搜索是构建期生成的索引，不依赖外部服务。

## 它其实就三步

1. **写**：在 `docs/` 里新建 `.md`，就是一篇笔记。
2. **构建**：`npm run build`，产出 `docs/.vitepress/dist/`，一堆 HTML。
3. **发布**：把 `dist` 推给 GitHub Pages（用 Actions 自动做）。

推送之后 GitHub 会跑一遍构建，大约一分钟后 `https://用户名.github.io` 就能打开。整个网站就是静态文件，没有数据库、没有服务器，所以永远不会"挂"。

## 目录长什么样

```
notes-site/
├─ docs/                    ← 所有内容
│  ├─ index.md              首页
│  ├─ about.md              这一页
│  ├─ notes/                笔记正文
│  ├─ public/               原样复制的文件（演示 HTML、图片）
│  │  └─ demos/
│  └─ .vitepress/
│     ├─ config.mts         站名、导航、侧边栏、搜索
│     └─ theme/             自定义样式和一个 DemoFrame 组件
├─ .github/workflows/       ← 自动部署脚本
└─ package.json
```

## 三个你可能想改的地方

- **站名和导航**：`docs/.vitepress/config.mts` 里的 `title`、`nav`、`sidebar`。
- **配色**：`docs/.vitepress/theme/custom.css` 顶部的 CSS 变量。
- **域名**：GitHub 仓库 Settings → Pages 里绑自定义域名，同时在 `docs/public/` 放一个 `CNAME` 文件。
