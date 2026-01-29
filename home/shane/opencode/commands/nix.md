---
description: Handle a nix task.
agent: nix
loop:
  max: 10
  until: "nix-check: nix-instantiate returns no errors"
---
