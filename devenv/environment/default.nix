# ./modules/environment/default.nix

{ ... }: {
  enterShell = ''
    if [ -z "$GITHUB_PERSONAL_ACCESS_TOKEN" ]; then
      if _token=$(gh auth token 2>/dev/null); then
        export GITHUB_PERSONAL_ACCESS_TOKEN="$_token"
      else
        echo "⚠ gh not authenticated — GITHUB_PERSONAL_ACCESS_TOKEN not set"
      fi
    fi
  '';
}
