# ./modules/automation/skills/default.nix

{ ... }: {
  imports = [
    ./tauri-architecture.nix
    ./tauri-ipc.nix
    ./tauri-linux-runtime.nix
    ./tauri-devenv-workflow.nix
    ./tauri-release-checklist.nix
    ./tauri-skill-index.nix
  ];
}
