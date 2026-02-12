---
description: generate a git commit message based on staged changes
model: google/gemini-3-flash-preview
agent: build
---

Recent commits:
!`git log -5 --oneline`

Files with staged changes:
!`git diff --name-only --cached`

Based on the recent commits and the changes in the currently **staged** files, generate a concise and descriptive git commit message. Output only the commit message. Do NOT consider changes in unstaged files.
