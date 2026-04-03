#!/bin/bash
# Скрипт резервного копирования конфигурации Claude Code в GitHub
# Создан: 2026-04-02

set -e

REPO_URL="https://github.com/Likolus/claude-config.git"
BACKUP_DIR=~/.claude-backup
CLAUDE_DIR=~/.claude

echo "🔄 Резервное копирование конфигурации Claude Code..."

# Создать директорию для бэкапа если её нет
mkdir -p "$BACKUP_DIR"

# Инициализировать git репозиторий если нужно
if [ ! -d "$BACKUP_DIR/.git" ]; then
    echo "📦 Инициализация git репозитория..."
    cd "$BACKUP_DIR"
    git init
    git remote add origin "$REPO_URL" 2>/dev/null || git remote set-url origin "$REPO_URL"

    # Создать .gitignore
    cat > .gitignore << 'EOF'
# Исключить чувствительные данные
*.log
*.tmp
transcripts/
sessions/
cache/
temp/
.DS_Store

# Исключить большие файлы
*.sqlite
*.db
EOF

    echo "✅ Репозиторий инициализирован"
fi

cd "$BACKUP_DIR"

# Копировать конфигурационные файлы
echo "📋 Копирование файлов..."

# 1. Основные настройки
cp "$CLAUDE_DIR/settings.json" . 2>/dev/null || echo "settings.json не найден"

# 2. Агенты
if [ -d "$CLAUDE_DIR/agents" ]; then
    rm -rf agents
    cp -r "$CLAUDE_DIR/agents" .
    echo "✓ Агенты скопированы"
fi

# 3. Skills
if [ -d "$CLAUDE_DIR/skills" ]; then
    rm -rf skills
    cp -r "$CLAUDE_DIR/skills" .
    echo "✓ Skills скопированы"
fi

# 4. Скрипты обновления
cp "$CLAUDE_DIR/update-all.sh" . 2>/dev/null || true
cp "$CLAUDE_DIR/update-cron.sh" . 2>/dev/null || true
cp "$CLAUDE_DIR/manage-updates.ps1" . 2>/dev/null || true
cp "$CLAUDE_DIR/aliases.sh" . 2>/dev/null || true

# 5. Память (без чувствительных данных)
if [ -d "$CLAUDE_DIR/projects" ]; then
    mkdir -p memory
    find "$CLAUDE_DIR/projects" -name "*.md" -path "*/memory/*" -exec cp {} memory/ \; 2>/dev/null || true
    echo "✓ Память скопирована"
fi

# 6. MCP конфигурация (если есть)
if [ -f "$CLAUDE_DIR/mcp.json" ]; then
    cp "$CLAUDE_DIR/mcp.json" .
    echo "✓ MCP конфигурация скопирована"
fi

# 7. Создать README с инструкциями
cat > README.md << 'EOF'
# Claude Code Configuration Backup

Автоматический бэкап конфигурации Claude Code.

## Содержимое

- `settings.json` - основные настройки
- `agents/` - коллекция специализированных агентов (200+)
- `skills/` - пользовательские навыки
- `memory/` - сохранённая память и предпочтения
- `*.sh`, `*.ps1` - скрипты автоматизации
- `mcp.json` - конфигурация MCP серверов

## Быстрое развёртывание

### Автоматическая установка (рекомендуется)

```bash
bash <(curl -s https://raw.githubusercontent.com/Likolus/claude-config/main/install.sh)
```

### Ручная установка

```bash
# 1. Клонировать репозиторий
git clone https://github.com/Likolus/claude-config.git ~/.claude-restore

# 2. Запустить скрипт восстановления
cd ~/.claude-restore
bash restore.sh
```

## Что восстанавливается

✅ Все настройки и предпочтения
✅ 200+ специализированных агентов
✅ Пользовательские навыки
✅ Память и контекст
✅ Скрипты автоматизации
✅ Хуки и автоформатирование
✅ MCP серверы

## Автообновление

Конфигурация автоматически сохраняется в GitHub:
- Ежедневно в 21:00
- После значительных изменений

---

Последнее обновление: $(date '+%Y-%m-%d %H:%M:%S')
EOF

# Создать манифест с версией
cat > manifest.json << EOF
{
  "version": "1.0.0",
  "updated": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "components": {
    "agents": $([ -d agents ] && echo "true" || echo "false"),
    "skills": $([ -d skills ] && echo "true" || echo "false"),
    "memory": $([ -d memory ] && echo "true" || echo "false"),
    "settings": $([ -f settings.json ] && echo "true" || echo "false"),
    "mcp": $([ -f mcp.json ] && echo "true" || echo "false")
  }
}
EOF

# Коммит и пуш
echo "💾 Сохранение в GitHub..."

git add .
git commit -m "Auto-backup: $(date '+%Y-%m-%d %H:%M:%S')" 2>/dev/null || {
    echo "⚠️  Нет изменений для сохранения"
    exit 0
}

# Настроить аутентификацию через токен из переменной окружения
if [ -z "$GITHUB_TOKEN" ]; then
    echo "⚠️  GITHUB_TOKEN не установлен. Используйте: export GITHUB_TOKEN=your_token"
    exit 1
fi

git remote set-url origin "https://${GITHUB_TOKEN}@github.com/Likolus/claude-config.git"

# Пуш в репозиторий
git push -u origin main 2>/dev/null || git push -u origin master 2>/dev/null || {
    echo "⚠️  Первый пуш, создаём ветку main..."
    git branch -M main
    git push -u origin main
}

echo "✅ Конфигурация сохранена в GitHub!"
echo "📍 Репозиторий: $REPO_URL"
