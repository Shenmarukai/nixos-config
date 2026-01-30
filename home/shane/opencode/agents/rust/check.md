---
description: Check Rust code.
mode: subagent
hidden: true
permission:
  "*": deny
  bash:
    "cargo check*": ask
  read:
    "*.rs": allow
  edit:
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
  discard: ask
  extract: ask
---
