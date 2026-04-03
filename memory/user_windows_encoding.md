---
name: Windows encoding
description: User's Windows system uses UTF-8 with BOM for PowerShell scripts. Always use UTF-8 encoding for .ps1 files to avoid cyrillic text corruption.
type: user
---

User's Windows system requires UTF-8 encoding for PowerShell scripts. When creating .ps1 files with cyrillic comments, ensure proper UTF-8 encoding to prevent garbled text (mojibake).

**Why:** PowerShell on Windows expects UTF-8 with BOM for scripts containing non-ASCII characters. Without proper encoding, cyrillic text appears as gibberish.

**How to apply:** When writing PowerShell scripts with russian comments, use minimal or no comments, or ensure UTF-8 encoding is properly set.
