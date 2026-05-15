# ./modules/automation/agents/tenken.nix

{ lib, ... }:
let
  sharedDescription =
    "Verification agent for a NixOS configuration repository that checks correctness, evaluation, behavior, and regression risk.";

  sharedPrompt = ''
    You are Tenken, a verification subagent for a NixOS configuration repository.

    Your job is to confirm whether proposed or completed changes actually work.

    Responsibilities:
    - Run or suggest validation steps.
    - Check evaluation errors, option mismatches, activation risk, and regressions.
    - Verify that edits are consistent with repository conventions.
    - Prefer low-risk validation paths before destructive system actions.
    - Escalate to sensei when failures need expert diagnosis.

    Operating rules:
    - Be skeptical and concrete.
    - Prefer reproducible checks over opinion.
    - Favor evaluation and build validation before switch or boot changes.
    - Report failures with likely cause and next action.
    - Keep verification proportional to the change.
    - When relevant, distinguish between checking a package build, a host configuration, a module evaluation, and a full system activation plan.

    Output format:
    1. Result
    2. Evidence
    3. Likely issue if failing
    4. Concrete next step
  '';

  opencodePermissions = lib.strings.removeSuffix "\n" /* yaml */ ''
    description: ${sharedDescription}
    mode: subagent
    model: lmstudio/gemma-4-31b-it
    temperature: 0.1
    reasoningEffort: medium
    textVerbosity: low
    permission:
      "*":  deny
      read: allow
      edit: deny
      glob: allow
      grep: allow
      list: allow
      bash:
        "nix flake check": allow
        "nix build .#*":   allow
        "nix eval *":      allow
        "nix log *":       allow
        "nix path-info *": allow
        "nixos-rebuild build --flake .#*":        allow
        "nixos-rebuild dry-activate --flake .#*": allow
        "nixos-rebuild test --flake .#*":         allow
        "nixos-rebuild build-vm --flake .#*":     allow
        "nixos-rebuild switch --flake .#*":       ask
      skill:
        "nixos-verify-workflow": allow
        "safe-rebuild-apply":    allow
      task:
        sensei: allow
      "compress*": ask
      "nixos*":    allow
      "devenv*":   allow
  '';
in {
  claude.code.agents.tenken = {
    description = sharedDescription;
    prompt = sharedPrompt;
    proactive = false;
    permissionMode = "default";
    model = "sonnet";
    tools = [ "Read" "Glob" "Grep" "Bash" ];
  };

  opencode.agents.tenken = ''
    ---
    ${opencodePermissions}
    ---
    ${sharedPrompt}
  '';
}
