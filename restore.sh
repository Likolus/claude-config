#!/bin/bash
# Скрипт восстановления конфигурации Claude Code из GitHub
# Использование: bash restore.sh

set -e

REPO_URL="https://github.com/Likolus/claude-config.git"
CLAUDE_DIR=~/.claude
BACKUP_DIR=~/.claude-restore

echo "🚀 Восстановление конфигурации Claude Code..."
echo ""

# Проверить, установлен ли Claude Code
if ! command -v claude &> /dev/null; then
    echo "⚠️  Claude Code не найден. Установите его сначала."
    echo "   Посетите: https://claude.ai/download"
    exit 1
fi

# Создать резервную копию текущей конфигурации
if [ -d "$CLAUDE_DIR" ]; then
    echo "💾 Создание резервной копии текущей конфигурации..."
    BACKUP_NAME="claude-backup-$(date +%Y%m%d-%H%M%S)"
    mv "$CLAUDE_DIR" ~/"$BACKUP_NAME"
    echo "✓ Резервная копия: ~/$BACKUP_NAME"
fi

# Клонировать репозиторий если нужно
if [ ! -d "$BACKUP_DIR" ]; then
    echo "📥 Клонирование конфигурации из GitHub..."
    git clone "$REPO_URL" "$BACKUP_DIR"
else
    echo "📥 Обновление конфигурации из GitHub..."
    cd "$BACKUP_DIR"
    git pull
fi

# Создать директорию Claude
mkdir -p "$CLAUDE_DIR"

echo "📋 Восстановление файлов..."

# 1. Основные настройки
if [ -f "$BACKUP_DIR/settings.json" ]; then
    cp "$BACKUP_DIR/settings.json" "$CLAUDE_DIR/"
    echo "✓ Настройки восстановлены"
fi

# 2. Агенты
if [ -d "$BACKUP_DIR/agents" ]; then
    cp -r "$BACKUP_DIR/agents" "$CLAUDE_DIR/"
    AGENTS_COUNT=$(find "$CLAUDE_DIR/agents" -name "*.md" | wc -l)
    echo "✓ Агенты восстановлены ($AGENTS_COUNT файлов)"
fi

# 3. Skills
if [ -d "$BACKUP_DIR/skills" ]; then
    cp -r "$BACKUP_DIR/skills" "$CLAUDE_DIR/"
    echo "✓ Skills восстановлены"
fi

# 4. Память
if [ -d "$BACKUP_DIR/memory" ]; then
    mkdir -p "$CLAUDE_DIR/projects/C--Users-$(whoami)/memory"
    cp -r "$BACKUP_DIR/memory/"* "$CLAUDE_DIR/projects/C--Users-$(whoami)/memory/" 2>/dev/null || true
    echo "✓ Память восстановлена"
fi

# 5. Скрипты
for script in update-all.sh update-cron.sh manage-updates.ps1 aliases.sh backup-to-github.sh; do
    if [ -f "$BACKUP_DIR/$script" ]; then
        cp "$BACKUP_DIR/$script" "$CLAUDE_DIR/"
        chmod +x "$CLAUDE_DIR/$script" 2>/dev/null || true
    fi
done
echo "✓ Скрипты восстановлены"

# 6. MCP конфигурация
if [ -f "$BACKUP_DIR/mcp.json" ]; then
    cp "$BACKUP_DIR/mcp.json" "$CLAUDE_DIR/"
    echo "✓ MCP конфигурация восстановлена"
fi

# 7. Добавить алиасы в bashrc
if [ -f "$CLAUDE_DIR/aliases.sh" ]; then
    if ! grep -q "claude/aliases.sh" ~/.bashrc 2>/dev/null; then
        cat >> ~/.bashrc << 'EOF'

# Claude Code управление (добавлено автоматически)
if [ -f ~/.claude/aliases.sh ]; then
    source ~/.claude/aliases.sh
fi
EOF
        echo "✓ Алиасы добавлены в ~/.bashrc"
    fi
fi

# 8. Установить необходимые инструменты
echo ""
echo "🔧 Проверка зависимостей..."

# Prettier для автоформатирования
if ! command -v prettier &> /dev/null; then
    echo "📦 Установка prettier..."
    npm install -g prettier 2>/dev/null || echo "⚠️  Не удалось установить prettier"
fi

# 9. Настроить автообновление (Windows)
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    echo ""
    echo "⏰ Настройка автообновления..."
    powershell -Command "schtasks /Create /TN 'ClaudeCodeUpdate' /TR 'bash $CLAUDE_DIR/update-cron.sh' /SC DAILY /ST 09:17 /F" 2>/dev/null || true

    echo "⏰ Настройка автобэкапа..."
    powershell -Command "schtasks /Create /TN 'ClaudeCodeBackup' /TR 'bash $CLAUDE_DIR/backup-to-github.sh' /SC DAILY /ST 21:00 /F" 2>/dev/null || true
fi

echo ""
echo "✅ Восстановление завершено!"
echo ""
echo "📊 Статистика:"
[ -d "$CLAUDE_DIR/agents" ] && echo "  Агентов: $(find "$CLAUDE_DIR/agents" -name "*.md" | wc -l)"
[ -d "$CLAUDE_DIR/skills" ] && echo "  Skills: $(ls -1 "$CLAUDE_DIR/skills" 2>/dev/null | wc -l)"
[ -f "$CLAUDE_DIR/settings.json" ] && echo "  Настройки: ✓"
[ -f "$CLAUDE_DIR/mcp.json" ] && echo "  MCP: ✓"

echo ""
echo "🎯 Следующие шаги:"
echo "  1. Перезапустите терминал для активации алиасов"
echo "  2. Запустите Claude Code"
echo "  3. Проверьте настройки: claude-status"
echo ""
echo "💡 Полезные команды:"
echo "  claude-update       - Обновить компоненты"
echo "  claude-manage       - Меню управления"
echo "  claude-logs         - Показать логи"
echo ""
