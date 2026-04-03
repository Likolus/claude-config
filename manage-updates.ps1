# PowerShell скрипт для управления автообновлением Claude Code
# Использует правильную кодировку для Windows

# Установка UTF-8 кодировки
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

function Show-UpdateTaskStatus {
    Write-Host "📊 Статус задачи автообновления:" -ForegroundColor Cyan
    schtasks /Query /TN "ClaudeCodeUpdate" /FO LIST
}

function Start-UpdateNow {
    Write-Host "🚀 Запуск обновления..." -ForegroundColor Green
    schtasks /Run /TN "ClaudeCodeUpdate"
    Write-Host "✅ Обновление запущено" -ForegroundColor Green
}

function Disable-AutoUpdate {
    Write-Host "⏸️  Отключение автообновления..." -ForegroundColor Yellow
    schtasks /Change /TN "ClaudeCodeUpdate" /DISABLE
    Write-Host "✅ Автообновление отключено" -ForegroundColor Green
}

function Enable-AutoUpdate {
    Write-Host "▶️  Включение автообновления..." -ForegroundColor Green
    schtasks /Change /TN "ClaudeCodeUpdate" /ENABLE
    Write-Host "✅ Автообновление включено" -ForegroundColor Green
}

function Remove-AutoUpdate {
    $confirm = Read-Host "Вы уверены, что хотите удалить задачу автообновления? (y/n)"
    if ($confirm -eq 'y') {
        Write-Host "🗑️  Удаление задачи..." -ForegroundColor Red
        schtasks /Delete /TN "ClaudeCodeUpdate" /F
        Write-Host "✅ Задача удалена" -ForegroundColor Green
    } else {
        Write-Host "❌ Отменено" -ForegroundColor Yellow
    }
}

function Show-UpdateLog {
    $logFile = "$env:USERPROFILE\.claude\update-log.txt"
    if (Test-Path $logFile) {
        Write-Host "📋 Последние обновления:" -ForegroundColor Cyan
        Get-Content $logFile -Tail 50
    } else {
        Write-Host "⚠️  Лог-файл не найден" -ForegroundColor Yellow
    }
}

function Set-UpdateTime {
    param([string]$time = "09:17")
    Write-Host "⏰ Изменение времени обновления на $time..." -ForegroundColor Cyan
    schtasks /Change /TN "ClaudeCodeUpdate" /ST $time
    Write-Host "✅ Время обновления изменено" -ForegroundColor Green
}

# Меню
Write-Host ""
Write-Host "🔄 Управление автообновлением Claude Code" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Показать статус"
Write-Host "2. Запустить обновление сейчас"
Write-Host "3. Отключить автообновление"
Write-Host "4. Включить автообновление"
Write-Host "5. Показать лог обновлений"
Write-Host "6. Изменить время обновления"
Write-Host "7. Удалить задачу автообновления"
Write-Host "0. Выход"
Write-Host ""

$choice = Read-Host "Выберите действие"

switch ($choice) {
    "1" { Show-UpdateTaskStatus }
    "2" { Start-UpdateNow }
    "3" { Disable-AutoUpdate }
    "4" { Enable-AutoUpdate }
    "5" { Show-UpdateLog }
    "6" {
        $newTime = Read-Host "Введите новое время (HH:MM, например 08:00)"
        Set-UpdateTime -time $newTime
    }
    "7" { Remove-AutoUpdate }
    "0" { Write-Host "👋 До свидания!" -ForegroundColor Green }
    default { Write-Host "❌ Неверный выбор" -ForegroundColor Red }
}

Write-Host ""
