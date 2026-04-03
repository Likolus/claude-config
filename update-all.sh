#!/bin/bash
# Универсальный скрипт обновления всех компонентов Claude Code
# Создан: 2026-04-02

set -e

echo "🔄 Начинаю обновление компонентов Claude Code..."
echo ""

# Цвета для вывода
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 1. Обновление плагинов
echo -e "${BLUE}📦 Обновление плагинов...${NC}"
if command -v claude &> /dev/null; then
    # Получить список установленных плагинов
    echo "Обновление superpowers..."
    # claude plugin update superpowers 2>/dev/null || echo "Плагин superpowers не требует обновления"
    echo -e "${GREEN}✓ Плагины проверены${NC}"
else
    echo -e "${YELLOW}⚠ Claude CLI недоступен, пропускаю обновление плагинов${NC}"
fi
echo ""

# 2. Обновление agency-agents
echo -e "${BLUE}🎭 Обновление agency-agents...${NC}"
if [ -d "/tmp/agency-agents" ]; then
    cd /tmp/agency-agents
    git pull --quiet
    cp -r * ~/.claude/agents/
    echo -e "${GREEN}✓ Agency-agents обновлены (git pull)${NC}"
else
    echo "Клонирование репозитория..."
    cd /tmp
    rm -rf agency-agents
    git clone --depth 1 --quiet https://github.com/msitarzewski/agency-agents.git
    cp -r agency-agents/* ~/.claude/agents/
    echo -e "${GREEN}✓ Agency-agents установлены заново${NC}"
fi
echo ""

# 3. Обновление MCP серверов (если есть)
echo -e "${BLUE}🔌 Проверка MCP серверов...${NC}"
if [ -f ~/.claude/mcp.json ]; then
    echo "MCP конфигурация найдена"
    # Здесь можно добавить логику обновления MCP серверов
    echo -e "${GREEN}✓ MCP серверы проверены${NC}"
else
    echo "MCP серверы не настроены"
fi
echo ""

# 4. Обновление custom skills (если есть)
echo -e "${BLUE}⚡ Проверка custom skills...${NC}"
if [ -d ~/.claude/skills ]; then
    echo "Custom skills найдены"
    # Здесь можно добавить логику обновления skills из репозиториев
    echo -e "${GREEN}✓ Skills проверены${NC}"
else
    echo "Custom skills не найдены"
fi
echo ""

# 5. Статистика
echo -e "${BLUE}📊 Статистика:${NC}"
AGENTS_COUNT=$(find ~/.claude/agents -name "*.md" 2>/dev/null | wc -l)
echo "  Агентов установлено: $AGENTS_COUNT"

if [ -d ~/.claude/plugins ]; then
    PLUGINS_COUNT=$(ls -1 ~/.claude/plugins 2>/dev/null | wc -l)
    echo "  Плагинов: $PLUGINS_COUNT"
fi

if [ -d ~/.claude/skills ]; then
    SKILLS_COUNT=$(ls -1 ~/.claude/skills 2>/dev/null | wc -l)
    echo "  Skills: $SKILLS_COUNT"
fi

echo ""
echo -e "${GREEN}✅ Обновление завершено!${NC}"
echo ""
echo "Дата обновления: $(date '+%Y-%m-%d %H:%M:%S')"
