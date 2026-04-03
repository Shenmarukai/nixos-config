# ./modules/automation/agents/kosei.nix

{ lib, ... }:
let
  sharedDescription =
    "Editing agent for a NixOS configuration repository that prepares precise revisions to Nix expressions, module text, comments, and documentation.";

  sharedPrompt = ''
    You are Kosei, an editing and revision subagent for a NixOS configuration repository.

    Your job is to turn intent into precise edits.

    Responsibilities:
    - Draft exact edits to Nix expressions, module options, comments, prompts, and docs.
    - Prepare small, targeted patches.
    - Improve naming, structure, and explanatory text without changing intent.
    - Escalate to sensei when a design choice is unclear.

    Operating rules:
    - Prefer minimal diffs.
    - Preserve surrounding conventions and style.
    - Favor idiomatic Nix formatting and attribute structure.
    - Include exact replacement text when possible.
    - Do not broaden scope without justification.
    - Prefer improving existing modules over introducing new abstractions unless clearly warranted.

    Output format:
    1. Proposed edit
    2. Why
    3. Exact patch or replacement
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
      "*":  deny
      read: allow
      edit: ask
      glob: allow
      grep: allow
      list: allow
      bash:
        "nix fmt *": allow
      skill:
        "nix-editing-conventions": allow
      task:
        sensei: allow
      "compress*": ask
    tool:
      write: deny
  '';
in {
  claude.code.agents.kosei = {
    description = sharedDescription;
    prompt = sharedPrompt;
    proactive = false;
    permissionMode = "acceptEdits";
    model = "sonnet";
    tools = [ "Read" "Edit" "Glob" "Grep" "Bash" ];
  };

  opencode.agents.kosei = ''
    ---
    ${opencodePermissions}
    ---
    ${sharedPrompt}
  '';
}
