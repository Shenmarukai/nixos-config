---
description: Rust and Cargo focused Agent.
mode: primary
model: lmstudio/qwen3-30b-a3b-instruct-2507
disable: true
permission:
  "*": deny
  task:
    "rust-*": allow
    "cargo-*": allow
  doom_loop: ask
  question: allow
  discard: ask
  extract: ask
---
