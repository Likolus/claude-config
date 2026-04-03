# Алиасы для управления Claude Code
# Добавьте эти строки в ваш ~/.bashrc или ~/.bash_profile

# Обновление всех компонентов Claude Code
alias claude-update='bash ~/.claude/update-all.sh'

# Управление автообновлением (PowerShell)
alias claude-manage='powershell -ExecutionPolicy Bypass -File ~/.claude/manage-updates.ps1'

# Просмотр логов обновлений
alias claude-logs='tail -50 ~/.claude/update-log.txt'

# Статус задачи автообновления
alias claude-status='powershell -Command "[Console]::OutputEncoding = [System.Text.Encoding]::UTF8; schtasks /Query /TN \"ClaudeCodeUpdate\" /FO LIST"'

# Запустить обновление сейчас
alias claude-update-now='powershell -Command "schtasks /Run /TN \"ClaudeCodeUpdate\""'

# Автоматически доверять директориям (отключить проверку безопасности)
alias claude='claude --trust'
