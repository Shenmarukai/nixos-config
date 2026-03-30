{ ... }:
let
  name = "safe-rebuild-apply";

  description =
    "final-stage apply safety guidance for this personal nixos configuration repository. use when deciding whether to stop at build, use dry-activate, run test, or proceed to switch for shane-desktop or shane-laptop.";

  body = ''
    This skill governs the final apply decision for this personal NixOS repository.

    Known hosts:
    - `shane-desktop`
    - `shane-laptop`

    Apply ladder:
    - `nix flake check`
    - `nix build`
    - `nixos-rebuild build --flake .#<host>`
    - `nixos-rebuild dry-activate --flake .#<host>`
    - `nixos-rebuild test --flake .#<host>`
    - `nixos-rebuild switch --flake .#<host>`

    Decision rules:
    - Stop at `build` when the change only needs compile/evaluation confidence.
    - Use `dry-activate` when activation behavior matters but live application is not yet justified.
    - Use `test` when live validation is needed but the change should not yet become the default boot generation.
    - Use `switch` only when earlier checks have passed and the caller is ready to apply the configuration on the target machine.
    - Never guess the host if the next step is `test` or `switch`.
    - If the scope or host is ambiguous, recommend the safest lower step instead of escalating.
    - Treat shared module changes with wider blast radius more conservatively than host-local changes.

    Refuse to recommend immediate `switch` when:
    - host targeting is unclear
    - earlier checks have not passed
    - the change affects flake wiring or shared core modules and has not been validated sufficiently
    - the requested step is riskier than necessary to answer the question

    Return:
    1. Host target confidence
    2. Highest justified step
    3. Why that step is justified
    4. Whether `switch` is appropriate now
    5. Exact next command
  '';
in {
  files.".claude/skills/${name}/SKILL.md".text = ''
    ---
    name: ${name}
    description: ${description}
    allowed-tools: Read, Glob, Grep, Bash
    disable-model-invocation: true
    model: sonnet
    effort: medium
    context: fork
    agent: tenken
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
