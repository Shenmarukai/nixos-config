# ./devenv/scripts/nix-store-add-files.nix

{ ... }: {
  scripts.nix-store-add-files = {
    description = "Add local dependencies to nix store.";
    exec = /* bash */ ''
      set -euo pipefail

      for file in .dependencies/*; do
        if [ -f "$file" ]; then
          nix store add-file "$file"
        fi
      done
    '';
  };
}
