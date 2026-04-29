# HR Skill Hub · Roadmap 🛣

> 版本演进路线，重点说明「记忆 / 团队统计」三阶段方案。

---

## 🟢 v1.1（当前版本，已上线）

### 已完成功能
- ✅ 6 大分类索引、搜索、筛选、排序
- ✅ 卡片网格 + 详情弹窗 + 一键复制安装命令
- ✅ **个人本地记忆**（v1.1 新增）
  - 「📋 复制」自动埋点 → `localStorage.usageStats`
  - 顶部「🔥 我最常用的 Skill」面板（Top 5）
  - 「清空记录」按钮
  - 数据**仅存浏览器本地**，不上传

### 数据存储位置
```js
localStorage['hr-skill-hub.usageStats.v1'] =
  { "interview-summary-formatter": { count: 12, lastAt: "2026-04-29T..." }, ... }
```

---

## 🟡 v2.0（团队级记忆，1-2 周可做）

### 核心目标
让全团队的「谁复制了哪个 skill」可见，识别真正高价值的 skill，淘汰冷门。

### 三种后端方案对比

| 方案 | 成本 | 难度 | 隐私 | 适合场景 |
|---|---|---|---|---|
| **A. GitHub Issues 当数据库** | ¥0 | ⭐ | Public 仓库人人可见 | 团队内部、不介意公开 |
| **B. Vercel KV / Cloudflare KV** | ¥0~少量 | ⭐⭐ | 私有 | 小团队首选 ⭐ |
| **C. 自建 tRPC + Postgres** | 服务器费 | ⭐⭐⭐⭐ | 完全可控 | 上规模后再上 |

### 推荐路径：方案 B（Cloudflare Workers + KV）

**为什么**：
- Cloudflare Workers 免费额度：10万次请求/天 → 团队级使用够用
- 全球 CDN，国内访问也快
- 无需服务器运维

**实现要点**：
```js
// 前端：替换 skill-hub.html 里的 pushUsageToServer
async function pushUsageToServer(skillId, action) {
  await fetch('https://hr-skill-hub-api.your-name.workers.dev/usage', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ skillId, action, ts: Date.now() })
  });
}

// 后端：Cloudflare Worker（约 30 行代码）
// - POST /usage：原子计数 +1，写入 KV
// - GET /trending：返回 Top 10 热门 skill
```

**新增 UI**：
- 顶部新增「🌟 团队热榜」面板（与「🔥 我最常用」并列）
- 卡片右上角显示团队复制次数 badge

### 隐私设计
- 不收集用户身份（匿名计数）
- 只统计 `skillId + action + 时间戳`
- 不记录 IP、UA、Cookie

---

## 🔵 v3.0（私有数据 + 微调小模型，远期）

### 触发条件
当团队反馈「通用 LLM 在某个 HR 场景效果不稳定」时启动，例如：
- 简历与 JD 匹配度打分
- 离职原因分类（自由文本 → 7 大类）
- 文化匹配度评估

### 工程路径
1. **数据采集**：脱敏后的历史样本（≥ 1000 条）
2. **基线评估**：先用 GPT-4 / Claude 跑一遍，定 baseline
3. **微调决策**：差距 > 15% 才微调，否则优化 Prompt 即可
4. **模型选型**：Qwen-2.5-7B / Llama-3.1-8B 微调（LoRA）
5. **部署**：腾讯云 TI-ONE / 自建 vLLM
6. **合规**：数据全程脱敏 + DPIA 评估

### 必须先满足的前置条件
- [ ] 数据合规审查通过（HRBP + 法务 + 安全）
- [ ] 明确数据保留期限和销毁机制
- [ ] 模型输出结果有人工兜底（不允许自动决策）

---

## 📅 阶段判断标准

什么时候推进到下一阶段？

```
v1 → v2 触发条件：
  ✅ 累计 5 个以上同事开始用
  ✅ 「这个 skill 真的好用吗」需要数据回答
  ✅ 想做月度 skill 使用报表

v2 → v3 触发条件：
  ✅ 某个高频 HR 场景，通用 LLM 准确率 < 80%
  ✅ 数据量足够微调（≥ 1000 标注样本）
  ✅ 数据合规审查通过
```

---

_Roadmap by 章老师 · 不必着急上 v3，能用 Prompt 解决的就别上模型_
