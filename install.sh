#!/bin/bash
# Быстрая установка конфигурации Claude Code
# Использование: bash <(curl -s https://raw.githubusercontent.com/Likolus/claude-config/main/install.sh)

set -e

REPO_URL="https://github.com/Likolus/claude-config.git"
TEMP_DIR="/tmp/claude-config-install"

echo "🚀 Быстрая установка конфигурации Claude Code"
echo "=============================================="
echo ""

# Клонировать репозиторий
echo "📥 Загрузка конфигурации..."
rm -rf "$TEMP_DIR"
git clone "$REPO_URL" "$TEMP_DIR"

# Запустить скрипт восстановления
cd "$TEMP_DIR"
bash restore.sh

# Очистка
rm -rf "$TEMP_DIR"

echo ""
echo "🎉 Установка завершена!"
