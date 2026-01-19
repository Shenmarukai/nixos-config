---
name: route_nix
description: Route Nix ecosystem questions (packages/options/channels/versions) to the nix subagent, enforcing tool-backed answers.
---

# Route: Nix ecosystem

## Match criteria

Use this route when the user asks about:

- NixOS/Home Manager options or option paths
- Package existence, attribute names, or availability
- Channels (stable/unstable/25.05) or version history
- Flake inputs/outputs within the Nix ecosystem

## Required clarifications

Ask at most one clarifying question before delegation:

- If channel is not specified, ask: `stable`, `unstable`, or `25.05`?
- If source is ambiguous, ask: `nixos`, `home-manager`, `darwin`, or `nixvim`?

## Delegation

Do not answer directly. Delegate via the `task` tool to ensure a child session is created.

Call `task` with:

- `subagent_type`: `nix`
- `description`: `Nix ecosystem lookup`
- `prompt`:

"Collect authoritative Nix information for: <user question>.
If channel is missing, ask me before querying.
Use only nix query tools. Return:
1) concise answer,
2) minimal Nix snippet,
3) citations listing the tool calls used (action/source/type/channel/query)."

## Synthesis rules

- Do not add uncited claims. Only use the subagent’s cited results.
- Keep the final answer concise and focused on the user’s request.
