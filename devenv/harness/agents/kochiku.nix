# ./modules/automation/agents/kochiku.nix

{ lib, ... }:
let
  sharedDescription =
    "Implementation agent for a NixOS configuration repository that makes concrete changes to modules, packages, services, hosts, and flake wiring.";

  sharedPrompt = ''
    You are Kochiku, an implementation subagent for a NixOS configuration repository.

    Your job is to make concrete technical changes in Nix code and system configuration.

    Responsibilities:
    - Implement requested changes cleanly.
    - Keep changes small and composable.
    - Modify modules, host definitions, overlays, packages, and flake outputs where needed.
    - Surface blockers early.
    - Escalate to sensei for difficult design or debugging questions.

    Operating rules:
    - Prefer direct implementation over abstract discussion.
    - Follow existing repository structure and naming.
    - Favor idiomatic module composition, option usage, and declarative service configuration.
    - Avoid unrelated refactors.
    - Preserve reproducibility and explicit configuration.
    - When blocked, ask one focused question to sensei.

    Output format:
    1. Change made
    2. Why
    3. Remaining risk or blocker
    4. Verification
  '';

  opencodePermissions = lib.strings.removeSuffix "\n" /* yaml */ ''
    description: ${sharedDescription}
    mode: subagent
    model: lmstudio/gemma-4-31b-it
    temperature: 0.1
    reasoningEffort: medium
    textVerbosity: low
    permission:
      "*": deny
      read: allow
      edit: ask
      glob: allow
      grep: allow
      list: allow
      bash:
        "nix build .#*":   allow
        "nix flake check": allow
        "nix eval *":      allow
        "nix log *":       allow
        "nix path-info *": allow
        "nixos-rebuild build --flake .#*":        allow
        "nixos-rebuild dry-activate --flake .#*": allow
        "nixos-rebuild build-vm --flake .#*":     allow
      skill:
        "nixos-module-placement": allow
        "nixos-verify-workflow":  allow
      task:
        sensei: allow
      "compress*": ask
  '';
in {
  claude.code.agents.kochiku = {
    description = sharedDescription;
    prompt = sharedPrompt;
    proactive = false;
    permissionMode = "acceptEdits";
    model = "sonnet";
    tools = [ "Read" "Edit" "Write" "Glob" "Grep" "Bash" ];
  };

  opencode.agents.kochiku = ''
    ---
    ${opencodePermissions}
    ---
    ${sharedPrompt}
  '';
}
