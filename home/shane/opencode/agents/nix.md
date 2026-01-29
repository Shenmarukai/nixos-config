---
description: Nix focused Agent.
mode: primary
model: lmstudio/qwen3-30b-a3b-instruct-2507
disable: true
permission:
  "*": deny
  task:
    "nix-*": allow
  doom_loop: ask
  question: allow
  discard: ask
  extract: ask
---
