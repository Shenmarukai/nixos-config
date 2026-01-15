# Opencode Harness Policy

This repo uses the `opencode-general-harness` plugin together with
`opencode-sessions` as the primary harness for non-trivial work.

## Policy

- For any task that affects code, repos, builds, or tests:
  - Use `orchestrate_task` (from `opencode-general-harness`) to run a
    two-phase Plan → Build pipeline.
  - Do not bypass the planner/builder roles except for obviously trivial,
    non-mutating questions.

- Use `read_with_context` when reading files you intend to modify or rely on,
  so directory `AGENTS.md` and `README.*` instructions are respected.

- Use `todo_list` / `todo_update` to keep multi-step work tracked in the
  todo system.

- For multi-agent collaboration and handoffs, use the `session_message` /
  `session_new` / `session_fork` or `background_*` tools (wrapping the
  `session` tool from `opencode-sessions`).

## Further details

For full harness behavior, role mappings, and tool reference, see:

- `home/shane/code/shane/opencode-general-harness/README.md`
