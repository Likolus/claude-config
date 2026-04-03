#!/bin/bash
# Wrapper для Windows Task Scheduler - запускает update-all.sh и логирует результат
# Исправлена кодировка для Windows

export LANG=ru_RU.UTF-8
export LC_ALL=ru_RU.UTF-8

LOG_FILE=~/.claude/update-log.txt
SCRIPT=~/.claude/update-all.sh

echo "=== Автообновление $(date '+%Y-%m-%d %H:%M:%S') ===" >> "$LOG_FILE"

if [ -f "$SCRIPT" ]; then
    bash "$SCRIPT" >> "$LOG_FILE" 2>&1
    echo "" >> "$LOG_FILE"
else
    echo "Ошибка: скрипт $SCRIPT не найден" >> "$LOG_FILE"
fi
