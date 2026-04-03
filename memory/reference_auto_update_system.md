---
name: Auto-update system
description: Automatic daily updates for all Claude Code components (plugins, agents, MCP, skills)
type: reference
---

Система автоматического обновления всех компонентов Claude Code.

**Установлено:** 2026-04-02
**Исправлена кодировка:** UTF-8 для корректной работы в Windows

## Компоненты системы

### 1. Основной скрипт обновления

**Путь:** `~/.claude/update-all.sh`

Обновляет:

- Плагины Claude Code
- Agency-agents (200+ агентов)
- MCP серверы
- Custom skills

**Запуск вручную:**

```bash
bash ~/.claude/update-all.sh
# или через алиас (в новой сессии):
claude-update
```

### 2. Wrapper для автоматизации

**Путь:** `~/.claude/update-cron.sh`

Запускает update-all.sh и логирует результаты в `~/.claude/update-log.txt`
Использует UTF-8 кодировку для корректной работы в Windows.

### 3. PowerShell менеджер

**Путь:** `~/.claude/manage-updates.ps1`

Интерактивное меню для управления автообновлением:

```powershell
powershell -ExecutionPolicy Bypass -File ~/.claude/manage-updates.ps1
# или через алиас:
claude-manage
```

### 4. Планировщик задач Windows

**Имя задачи:** ClaudeCodeUpdate
**Расписание:** Ежедневно в 9:17 утра
**Команда:** `bash C:\Users\Likolus\.claude\update-cron.sh`

**Управление задачей:**

```powershell
# Проверить статус (с правильной кодировкой)
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
schtasks /Query /TN "ClaudeCodeUpdate" /FO LIST

# Запустить вручную
schtasks /Run /TN "ClaudeCodeUpdate"

# Отключить
schtasks /Change /TN "ClaudeCodeUpdate" /DISABLE

# Включить
schtasks /Change /TN "ClaudeCodeUpdate" /ENABLE

# Удалить
schtasks /Delete /TN "ClaudeCodeUpdate" /F

# Изменить время (например, на 8:00)
schtasks /Change /TN "ClaudeCodeUpdate" /ST 08:00
```

## Быстрые команды (алиасы)

После перезапуска терминала доступны:

```bash
claude-update       # Запустить обновление сейчас
claude-manage       # Открыть меню управления (PowerShell)
claude-logs         # Показать последние 50 строк лога
claude-status       # Статус задачи автообновления
claude-update-now   # Запустить задачу планировщика
```

**Файл алиасов:** `~/.claude/aliases.sh` (автоматически загружается из `~/.bashrc`)

## Логи обновлений

Все обновления логируются в: `~/.claude/update-log.txt`

**Просмотр последних обновлений:**

```bash
tail -50 ~/.claude/update-log.txt
# или через алиас:
claude-logs
```

## Что обновляется автоматически

✅ **Agency-agents** - 200+ специализированных агентов
✅ **Плагины** - superpowers и другие установленные плагины
✅ **MCP серверы** - если настроены
✅ **Custom skills** - если установлены

## Ручное обновление

Если нужно обновить прямо сейчас:

```bash
bash ~/.claude/update-all.sh
```

## Изменение расписания

Чтобы изменить время обновления (например, на 8:00):

```powershell
schtasks /Change /TN "ClaudeCodeUpdate" /ST 08:00
```
