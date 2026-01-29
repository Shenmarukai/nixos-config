---
description: Handle a rust task.
agent: rust
loop:
  max: 10
  until: "rust-check: cargo check returns no errors"
---
