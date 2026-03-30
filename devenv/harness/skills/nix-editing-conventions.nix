{ ... }:
let
  name = "nix-editing-conventions";

  description =
    "editing conventions for this nix and nixos configuration repository. use when preparing patches, revising module text, updating small feature modules, improving comments, or making idiomatic nix edits that should match the repository's existing structure and style.";

  body = ''
    Optimize for minimal, repository-consistent Nix edits.

    Repository editing conventions:
    - Prefer the smallest diff that solves the problem.
    - Preserve the existing top-level structure and folder boundaries.
    - Prefer extending an existing module or file pattern over inventing a new abstraction.
    - Many modules in this repository are small and single-purpose; preserve that style.
    - Keep system concerns in `modules/system/...` and user concerns in `modules/home/...` or `home/shane/...`.
    - Keep package-specific logic in `pkgs/` or `overlays/` when appropriate.
    - Keep flake wiring changes isolated to `flake/outputs/...` when possible.

    Comment and documentation rules:
    - Avoid comment churn.
    - Add comments only when they clarify intent, scope, or non-obvious behavior.
    - Do not add obvious comments that restate syntax.
    - If changing a reusable shared module, note compatibility or blast-radius concerns.

    Editing rules:
    - Prefer existing option and module patterns over introducing new abstractions.
    - Keep attribute structure tidy and readable.
    - Avoid broad rewrites when a targeted change is enough.
    - If a new abstraction would only be used once, prefer not to add it.
    - Formatting should generally be run after edits.

    For every proposed edit, provide:
    1. Exact change
    2. Why it matches repo conventions
    3. Any compatibility or structure concern
    4. Whether formatting should be run afterward
  '';
in {
  files.".claude/skills/${name}/SKILL.md".text = ''
    ---
    name: ${name}
    description: ${description}
    allowed-tools: Read, Edit, Glob, Grep, Bash
    model: sonnet
    effort: low
    context: fork
    agent: kosei
    ---
    ${body}
  '';

  opencode.skills.${name} = ''
    ---
    name: ${name}
    description: ${description}
    ---
    ${body}
  '';
}
