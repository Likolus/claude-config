---
name: Agency-agents update command
description: Command to update agency-agents collection in Claude Code
type: reference
---

Команда для обновления коллекции agency-agents в Claude Code.

**Репозиторий:** https://github.com/msitarzewski/agency-agents

**Команда обновления:**

```bash
cd /tmp && \
rm -rf agency-agents && \
git clone --depth 1 https://github.com/msitarzewski/agency-agents.git && \
cp -r agency-agents/* ~/.claude/agents/ && \
echo "Agency-agents обновлены успешно"
```

**Быстрая команда (если репозиторий уже клонирован):**

```bash
cd /tmp/agency-agents && \
git pull && \
cp -r * ~/.claude/agents/ && \
echo "Agency-agents обновлены"
```

**Установлено:** 2026-04-02
**Количество агентов:** 200+
**Категории:** engineering, marketing, design, sales, product, project-management, strategy, support, testing, game-development, spatial-computing, academic, specialized
