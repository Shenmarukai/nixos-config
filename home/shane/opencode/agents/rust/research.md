---
description: Research Rust information.
mode: subagent
hidden: true
permission:
  "*": deny
  bash:
    "cargo*": ask
  read:
    "*.rs": allow
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
