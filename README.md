# HR Skill Hub 🤖

萨罗斯 HR 团队专属的 AI 能力索引中心。把零散的 Skill、操作指北、工具配置、场景方案、避坑经验、灵感储备，全部集中到一个可搜可筛的网页里，方便团队同事复用。

> 当前版本：v1.1

---

## 📁 项目结构

```
skill-hub/
├─ skill-hub.html          # 主页面（独立可运行）
├─ data/
│  └─ skills.json          # 所有 skill 数据（增删改这里就行）
└─ README.md               # 本文档
```

只有两个真正要维护的文件：**skill-hub.html**（前端逻辑） + **skills.json**（内容数据）。

---

## 🚀 三种打开方式

### 方式 1：本地双击预览（最快）

直接双击 `skill-hub.html` 不行 ❌——浏览器会拦截 fetch 本地 json，需要用 HTTP 服务器。

**Windows 推荐：**

```powershell
# 进到 skill-hub 目录
cd c:\Users\yvonezzhang\WorkBuddy\20260428175905\skill-hub

# 用 Python 起个简易服务器（电脑装了 Python 就行）
python -m http.server 8000

# 浏览器打开：http://localhost:8000/skill-hub.html
```

或者用 VS Code 装 **Live Server** 插件，右键 `skill-hub.html` → Open with Live Server。

### 方式 2：GitHub Pages 部署（推荐给团队用）

```bash
# 1. 进项目根
cd c:\Users\yvonezzhang\WorkBuddy\20260428175905

# 2. 初始化 git（如果还没初始化）
git init
git add skill-hub/
git commit -m "feat: HR Skill Hub v1.0 上线"

# 3. 推到 GitHub（需先在 github.com/ttttyu019 建好仓库，比如叫 hr-skill-hub）
git remote add origin https://github.com/ttttyu019/hr-skill-hub.git
git branch -M main
git push -u origin main

# 4. 在 GitHub 仓库 → Settings → Pages
#    Source: Deploy from a branch
#    Branch: main / 目录选 / (root) 或 /skill-hub
#    保存，等 1-2 分钟
```

部署成功后访问：`https://ttttyu019.github.io/hr-skill-hub/skill-hub.html`

### 方式 3：内网共享（不上 GitHub）

把整个 `skill-hub/` 文件夹放到团队共享盘 / OneDrive，同事用 Live Server 打开即可。

---

## ✏️ 如何新增一条 Skill / 内容

打开 `data/skills.json`，在 `skills` 数组里加一条：

```json
{
  "id": "my-new-skill",                    // 唯一 ID，建议 kebab-case
  "name": "我的新 Skill",                  // 显示名
  "category": "skill-tools",               // 6 选 1，见下方
  "version": "v1.0",                       // 可选
  "tags": ["招聘", "JD"],                  // 标签数组，用于搜索
  "scenarios": ["JD 撰写", "简历筛选"],    // 适用场景
  "summary": "一句话说清楚这个东西是干啥的",
  "highlights": ["亮点1", "亮点2"],        // 可选
  "install": "use_skill: my-new-skill",   // 可选，安装命令
  "trigger": "招聘 / JD / 写岗位描述",    // 可选，触发关键词
  "owner": "章老师",                       // 维护人
  "status": "stable"                       // stable / wip / draft / idea
}
```

### 6 大分类（category 字段）

| ID | 名称 | 用途 |
|---|---|---|
| `skill-tools` | 📦 Skill 工具库 | 可直接 use_skill 加载的能力包 |
| `ai-howto` | 📘 AI 操作指北 | 提示词技巧、工作心法 |
| `toolchain` | 🔧 工具链配置 | 环境搭建、API 配置 |
| `playbook` | 🎯 场景实战 | 端到端业务流程 SOP |
| `faq` | ⚠️ 避坑 FAQ | 踩过的坑和解法 |
| `inspiration` | 💡 灵感待探索 | 想做但还没做的方向 |

### 4 种状态（status 字段）

- `stable` 🟢 已稳定 → 大家可放心用
- `wip` 🔵 建设中 → 在做，可能不稳定
- `draft` 🟡 草稿 → 框架有了，内容待完善
- `idea` 🔴 想法 → 还在脑暴阶段

---

## 🎨 后续可演进方向（Roadmap）

| 阶段 | 工作量 | 价值 |
|---|---|---|
| **Phase 1（已完成）** Skill 索引站 | 1 天 | 信息集中，团队复用 |
| **Phase 2** 在线试用：高频 skill 浏览器内直接跑（OpenAI/Claude API 直连） | 1-2 周 | 同事不装 Claude Code 也能用 |
| **Phase 3** 私有数据 + 微调小模型（简历打分 / 离职预测等） | 1-2 月 | 真正的 AI 能力沉淀，需数据合规审查 |

---

## ⚠️ 隐私与合规提醒

1. **不要把员工真实姓名 / 薪资 / 绩效数据写进 `skills.json`**——它会被推到 GitHub Pages
2. 对外分享 Hub 链接前，确认所选 skill 不包含内部敏感信息
3. 涉及员工个人信息的 skill，建议标 `status: idea` + 加注 `"requires": "数据合规审查"` 字段

---

## 🤝 反馈渠道

- 内容建议：直接改 `data/skills.json` 提 PR，或找章老师
- 页面问题：在 GitHub Issues 提 issue
- 紧急联系：章老师（GitHub @ttttyu019）

---

_HR Skill Hub · Made with ❤️ by 章老师 · 持续生长中_
