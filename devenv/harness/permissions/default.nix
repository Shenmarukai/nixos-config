# ./modules/automation/permissions/default.nix

{ ... }: {
  imports = [
    ./defaults.nix
    ./read-only.nix
    ./file-edits.nix
    ./bash.nix
    ./tasking.nix
  ];
}
