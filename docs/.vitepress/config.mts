import { defineConfig } from 'vitepress'
import mathjax3 from 'markdown-it-mathjax3'

// 部署位置由环境变量控制：
//   用户站  username.github.io        ->  BASE=/
//   项目站  username.github.io/notes  ->  BASE=/notes/
// 本地开发不用管，默认就是 /
const base = process.env.BASE || '/'

export default defineConfig({
  base,
  lang: 'zh-CN',
  title: '奇怪小问题',
  description: '一个用 Markdown 写、用 GitHub Pages 发布的笔记本',
  lastUpdated: true,
  head: [
    ['link', { rel: 'icon', href: '/favicon.svg' }],
  ],
  markdown: {
    math: true,
    config(md) {
      md.use(mathjax3)
    },
  },
  themeConfig: {
    nav: [
      { text: '笔记', link: '/notes/', activeMatch: '/notes/' },
      { text: '关于', link: '/about' },
    ],
    sidebar: {
      '/notes/': [
        {
          text: '操作系统',
          items: [
            { text: '进程 / 核 / 时间片', link: '/notes/process-scheduler' },
          ],
        },
        {
          text: '体系结构',
          items: [
            { text: '一次加法的 11 步', link: '/notes/csapp-add' },
          ],
        },
        {
          text: '并行计算',
          items: [
            { text: 'CUDA 向量加法', link: '/notes/cuda-vecadd' },
          ],
        },
        {
          text: '排版',
          items: [
            { text: 'LaTeX 踩坑速查', link: '/notes/latex' },
          ],
        },
      ],
    },
    outline: { level: [2, 3], label: '本页目录' },
    search: { provider: 'local' },
    docFooter: { prev: '上一篇', next: '下一篇' },
    lastUpdated: {
      text: '最后更新',
      formatOptions: { dateStyle: 'short', timeStyle: 'short' },
    },
    editLink: {
      pattern: 'https://github.com/LinkCutY/LinkCutY.github.io/edit/main/docs/:path',
      text: '在 GitHub 上编辑这页',
    },
    socialLinks: [{ icon: 'github', link: 'https://github.com/LinkCutY' }],
    darkModeSwitchLabel: '配色',
    sidebarMenuLabel: '目录',
    returnToTopLabel: '回到顶部',
    footer: {
      message: '用 Markdown 写，用 GitHub Pages 发。',
      copyright: '© 2026 LinkCutY',
    },
  },
})
