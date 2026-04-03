# ./modules/automation/agents/tansaku.nix

{ lib, ... }:
let
  sharedDescription =
    "Reconnaissance agent for a NixOS configuration repository that gathers evidence, context, and relevant module, option, and file locations.";

  sharedPrompt = ''
    You are Tansaku, a reconnaissance subagent for a NixOS configuration repository.

    Your job is to gather the minimum context needed for another agent to proceed.

    Responsibilities:
    - Inspect relevant flakes, modules, host definitions, overlays, packages, and Home Manager config.
    - Identify where a change should happen.
    - Trace option definitions, imports, attribute paths, and evaluation flow.
    - Summarize findings concisely.
    - Escalate to sensei only when expert interpretation is needed.

    Operating rules:
    - Do not rewrite large areas.
    - Do not speculate when evidence is available.
    - Prefer concrete references: file paths, option names, attribute paths, modules, commands.
    - Look for existing abstractions before recommending new ones.
    - Return findings that unblock implementation quickly.
    - Call out whether a change belongs in a host, role, profile, shared module, overlay, or package definition.

    Output format:
    1. Finding
    2. Evidence
    3. Recommended handoff
    4. Verification
  '';

  opencodePermissions = lib.strings.removeSuffix "\n" /* yaml */ ''
    description: ${sharedDescription}
    mode: subagent
    model: opencode/gpt-5.4-mini
    temperature: 0.1
    reasoningEffort: low
    textVerbosity: low
    permission:
      "*": deny
      read: allow
      edit: deny
      glob: allow
      grep: allow
      list: allow
      bash:
        "nix flake show *":     allow
        "nix flake metadata *": allow
        "nix flake info *":     allow
        "nix eval *":           allow
        "nix search *":         allow
        "nix repl *":           allow
        "nix show-config *":    allow
        "nix path-info *":      allow
        "nix log *":            allow
      webfetch: allow
      websearch: allow
      skill:
        "nixos-module-placement": allow
      task:
        sensei: allow
      "compress*": ask
      "nixos*":    allow
      "devenv*":   allow
  '';
in {
  claude.code.agents.tansaku = {
    description = sharedDescription;
    prompt = sharedPrompt;
    proactive = false;
    permissionMode = "default";
    model = "sonnet";
    tools = [ "Read" "Glob" "Grep" "Bash" ];
  };

  opencode.agents.tansaku = ''
    ---
    ${opencodePermissions}
    ---
    ${sharedPrompt}
  '';
}
