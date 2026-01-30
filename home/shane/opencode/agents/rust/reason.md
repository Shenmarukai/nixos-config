---
description: Reason about Rust information.
mode: subagent
reasoningEffort: high
textVerbosity: low
reasoningSummary: auto
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
