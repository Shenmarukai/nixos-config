# ./modules/automation/skills/default.nix

{ ... }: {
  imports = [
    ./nixos-verify-workflow.nix
    ./nixos-module-placement.nix
    ./nix-editing-conventions.nix
    ./safe-rebuild-apply.nix
  ];
}
