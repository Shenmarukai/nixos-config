# ./modules/automation/permissions/default.nix

{ ... }: {
  claude.code.permissions = {
    defaultMode = "default";

    rules.nix-readonly = {
      allow = [
        "Bash(nix flake show *)"
        "Bash(nix flake metadata *)"
        "Bash(nix flake info *)"
        "Bash(nix eval *)"
        "Bash(nix search *)"
        "Bash(nix repl *)"
        "Bash(nix show-config *)"
        "Bash(nix path-info *)"
        "Bash(nix log *)"
      ];
    };

    rules.nix-format = {
      allow = [
        "Bash(nix fmt *)"
      ];
    };

    rules.nix-build = {
      allow = [
        "Bash(nix flake check)"
        "Bash(nix build .#*)"
        "Bash(nixos-rebuild build --flake .#*)"
        "Bash(nixos-rebuild dry-activate --flake .#*)"
        "Bash(nixos-rebuild build-vm --flake .#*)"
      ];
    };

    rules.nix-verify = {
      allow = [
        "Bash(nix flake check)"
        "Bash(nix build .#*)"
        "Bash(nix eval *)"
        "Bash(nix log *)"
        "Bash(nix path-info *)"
        "Bash(nixos-rebuild build --flake .#*)"
        "Bash(nixos-rebuild dry-activate --flake .#*)"
        "Bash(nixos-rebuild test --flake .#*)"
        "Bash(nixos-rebuild build-vm --flake .#*)"
      ];
      ask = [
        "Bash(nixos-rebuild switch --flake .#*)"
      ];
    };

    rules.nix-dangerous = {
      deny = [
        "Bash(nixos-rebuild boot *)"
        "Bash(nixos-rebuild --rollback *)"
        "Bash(nixos-rebuild * --target-host *)"
        "Bash(nixos-rebuild * --build-host *)"
        "Bash(nixos-rebuild * --use-remote-sudo *)"
        "Bash(nix flake update *)"
        "Bash(nix registry *)"
        "Bash(nix profile *)"
        "Bash(nix-env *)"
        "Bash(nix store delete *)"
        "Bash(nix store gc *)"
        "Bash(nix store repair *)"
        "Bash(nix store optimise *)"
      ];
    };
  };
}
