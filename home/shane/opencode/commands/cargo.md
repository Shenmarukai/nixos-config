---
description: Handle a cargo task.
agent: cargo
loop:
  max: 10
  until: "cargo-check: cargo check returns no errors"
---
