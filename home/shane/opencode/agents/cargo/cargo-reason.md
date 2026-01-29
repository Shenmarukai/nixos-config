---
description: Reason about Cargo information.
mode: subagent
model: lmstudio/qwen3-30b-a3b-thinking-2507
reasoningEffort: high
textVerbosity: low
reasoningSummary: auto
hidden: true
permission:
  "*": deny
  bash:
    "cargo*": ask
  read:
    "Cargo.toml": allow
    "Cargo.lock": allow
  grep: allow
  glob:
    "Cargo.toml": allow
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
    nix: allow
  discard: ask
  extract: ask
  "nixos_nix*": allow
  "github-read-only*": ask
---
