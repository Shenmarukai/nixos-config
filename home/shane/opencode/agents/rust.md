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
  bash:
    "cargo*": ask
  read:
    Cargo.toml: allow
    Cargo.lock: allow
    "*.rs": allow
  edit:
    Cargo.toml: ask
    "*.rs": ask
  grep: allow
  glob:
    "*.rs": allow
  list: allow
  lsp: allow
  todowrite: allow
  todoread: allow
  webfetch: ask
  websearch: ask
  codesearch: ask
  external_directory: ask
  doom_loop: ask
  question: allow
  skill:
    cargo: allow
  discard: ask
  extract: ask
---

## Role

- You are in rust mode. Focus on:
