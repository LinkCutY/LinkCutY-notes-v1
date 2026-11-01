# notes-site

一个能直接发到 GitHub Pages 的笔记站。**VitePress + GitHub Pages，没有后端，纯静态。**

## 本地跑起来

```bash
npm install
npm run dev      # http://localhost:5173
```

改 `docs/` 里的 Markdown，浏览器会自动刷新。

## 加一篇笔记

1. 在 `docs/notes/` 里新建 `我的笔记.md`，开头写 `# 标题`。
2. 在 `docs/.vitepress/config.mts` 的 `sidebar` 里加一行：

```ts
{ text: '我的笔记', link: '/notes/我的笔记' }
```

3. 存盘就完事了。

## 发到 github.io

### 第一步：建仓库

两种都行，差别只在网址：

| 仓库名 | 网址 | 备注 |
| --- | --- | --- |
| `<用户名>.github.io` | `https://<用户名>.github.io` | 根目录，不用改 base |
| 任意名字（如 `notes`） | `https://<用户名>.github.io/notes/` | 自动加 base，不用手动改 |

### 第二步：推上去

```bash
git init
git add -A
git commit -m "init"
git remote add origin https://github.com/<用户名>/<仓库名>.git
git branch -M main
git push -u origin main
```

### 第三步：开 Pages

仓库 **Settings → Pages → Build and deployment → Source 选 "GitHub Actions"**。

推完等一分钟，地址栏输入 `https://<用户名>.github.io[/仓库名]` 就能看到。

> 构建用的 `BASE` 由工作流根据仓库名自动判断：叫 `<用户名>.github.io` 就用 `/`，其它仓库用 `/<仓库名>/`。所以两种仓库都不用改配置。

## 目录

```
docs/
├─ index.md                 首页（hero 大标题 + 功能卡片）
├─ about.md                 关于页
├─ notes/                   笔记正文，一个文件一篇
│  ├─ index.md              笔记索引
│  ├─ csapp-add.md
│  ├─ process-scheduler.md
│  ├─ cuda-vecadd.md
│  └─ latex.md
├─ public/                  原样复制到站点根目录
│  ├─ favicon.svg
│  └─ demos/                可交互的单文件 HTML 演示
└─ .vitepress/
   ├─ config.mts            站名 / 导航 / 侧边栏 / 搜索
   └─ theme/
      ├─ index.ts
      ├─ DemoFrame.vue      内嵌演示的外框组件
      └─ custom.css         配色与排版微调
.github/workflows/deploy.yml  自动部署
.vscode/                    编辑器配置与"预览/发布"任务
tools/publish.ps1           发布脚本
发布.bat / 预览.bat           双击就能用的入口
```

## 在文章里嵌演示

把单文件 HTML 丢进 `docs/public/demos/`，正文里写：

```md
<DemoFrame src="/demos/xxx.html" title="演示标题" height="560px" />
```

组件会自动处理 base 路径，并给一个"新窗口打开"的入口。

## 图形化怎么管

四条路，按"要装多少东西"排：

| 入口 | 干什么 | 适合 |
| --- | --- | --- |
| **双击 `发布.bat`** | 构建自检 + 提交 + 推送，一条龙 | 只想发文章，不想碰命令 |
| **双击 `预览.bat`** | 起本地服务，自动开浏览器，改完自动刷新 | 边写边看效果 |
| **VS Code 任务** | `Ctrl+Shift+P` → `Tasks: Run Task` → 选"预览"或"发布" | 编辑和发布在同一个窗口 |
| **笔记页底部"在 GitHub 上编辑这页"** | 跳到 GitHub 网页编辑器，选 Commit changes 后自动重新部署 | 临时改一两句话，手边没电脑 |

另外装了 **GitHub Desktop** 的话，直接 Add existing repository 选这个文件夹，改动列表、提交、推送全是点按钮。

发布脚本 `tools/publish.ps1` 做三件事，构建不过就不会推：

1. `npm run build` —— Markdown 写坏了（比如没闭合的代码块、坏掉的链接）这里就会报错并停下；
2. `git add -A` + `git commit`，提交信息自动带上时间；
3. `git push` —— GitHub Actions 收到后大约一分钟重新部署。

## 想改的东西

- **站名、描述**：`docs/.vitepress/config.mts` 里的 `title` / `description`，首页文案在 `docs/index.md` 的 frontmatter。
- **配色**：`docs/.vitepress/theme/custom.css` 里的 `--vp-c-brand-1/2/3`。
- **自定义域名**：Pages 设置里填域名，同时在 `docs/public/` 放一个内容为域名的 `CNAME` 文件。
- **数学公式**：已启用 MathJax，正文直接写 `$E=mc^2$` 或 $$ 块。

## 常见问题

**推上去 404**
检查 Settings → Pages 里 Source 是不是选了 GitHub Actions，以及 Actions 那一栏有没有跑绿。

**页面能开但样式全丢**
仓库不是 `<用户名>.github.io` 时，base 没生效。确认是走的工作流构建，而不是本地手动 `npm run build` 后推 `dist`。

**本地 build 通过、线上失败**
本地 Node 版本和 `setup-node` 里写的不一致，把后者改成 `lts/` 或与本地相同的大版本。
