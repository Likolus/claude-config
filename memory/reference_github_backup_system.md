---
name: GitHub backup system
description: Automatic backup of Claude Code configuration to GitHub repository
type: reference
---

Система автоматического резервного копирования конфигурации Claude Code в GitHub.

**Репозиторий:** https://github.com/Likolus/claude-config
**Установлено:** 2026-04-02

## Что сохраняется

✅ **settings.json** - все настройки Claude Code
✅ **agents/** - 200+ специализированных агентов
✅ **skills/** - пользовательские навыки
✅ **memory/** - сохранённая память и предпочтения
✅ **Скрипты** - update-all.sh, manage-updates.ps1, aliases.sh
✅ **MCP конфигурация** - mcp.json (если есть)

## Автоматический бэкап

**Расписание:** Ежедневно в 21:00
**Задача Windows:** ClaudeCodeBackup
**Команда:** `bash ~/.claude/backup-to-github.sh`

**Проверка статуса:**

```powershell
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
schtasks /Query /TN "ClaudeCodeBackup" /FO LIST
```

## Ручной бэкап

```bash
export GITHUB_TOKEN="your_token"
bash ~/.claude/backup-to-github.sh
```

Токен хранится в `settings.json` в переменной `GITHUB_TOKEN`.

## Быстрое развёртывание на новой машине

### Вариант 1: Одна команда (рекомендуется)

```bash
bash <(curl -s https://raw.githubusercontent.com/Likolus/claude-config/main/install.sh)
```

### Вариант 2: Ручная установка

```bash
# 1. Клонировать репозиторий
git clone https://github.com/Likolus/claude-config.git ~/.claude-restore

# 2. Запустить восстановление
cd ~/.claude-restore
bash restore.sh
```

## Что восстанавливается автоматически

✅ Все настройки и предпочтения
✅ 200+ специализированных агентов
✅ Пользовательские навыки
✅ Память и контекст
✅ Скрипты автоматизации
✅ Хуки и автоформатирование
✅ MCP серверы
✅ Автообновление (планировщик задач)
✅ Автобэкап (планировщик задач)
✅ Алиасы командной строки

## Структура репозитория

```
claude-config/
├── README.md                    # Инструкции
├── manifest.json                # Версия и компоненты
├── settings.json                # Настройки Claude Code
├── agents/                      # 200+ агентов
├── skills/                      # Пользовательские навыки
├── memory/                      # Сохранённая память
├── backup-to-github.sh          # Скрипт бэкапа
├── restore.sh                   # Скрипт восстановления
├── install.sh                   # Быстрая установка
├── update-all.sh                # Обновление компонентов
├── update-cron.sh               # Wrapper для планировщика
├── manage-updates.ps1           # Меню управления
└── aliases.sh                   # Алиасы командной строки
```

## Управление задачей бэкапа

```powershell
# Запустить бэкап сейчас
schtasks /Run /TN "ClaudeCodeBackup"

# Отключить автобэкап
schtasks /Change /TN "ClaudeCodeBackup" /DISABLE

# Включить автобэкап
schtasks /Change /TN "ClaudeCodeBackup" /ENABLE

# Изменить время (например, на 22:00)
schtasks /Change /TN "ClaudeCodeBackup" /ST 22:00

# Удалить задачу
schtasks /Delete /TN "ClaudeCodeBackup" /F
```

## Безопасность

- GitHub токен хранится в `settings.json` в переменной окружения `GITHUB_TOKEN`
- `settings.json` НЕ должен коммититься с токенами в публичный репозиторий
- Скрипт бэкапа читает токен из переменной окружения
- Репозиторий публичный, но без чувствительных данных

## Логи бэкапа

Логи сохраняются в: `~/.claude/update-log.txt` (вместе с логами обновлений)

## Восстановление на новой машине - пошагово

1. Установить Claude Code
2. Запустить: `bash <(curl -s https://raw.githubusercontent.com/Likolus/claude-config/main/install.sh)`
3. Перезапустить терминал
4. Готово! Все настройки, агенты, память восстановлены

## Синхронизация между машинами

Если работаете на нескольких машинах:

1. На каждой машине настроен автобэкап (21:00)
2. На каждой машине настроено автообновление (9:17)
3. Изменения с одной машины автоматически попадают на другие через GitHub

**Важно:** Возможны конфликты при одновременной работе. Последний бэкап перезаписывает предыдущий.
