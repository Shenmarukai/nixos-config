# ./modules/automation/agents/default.nix

{ ... }: {
  imports = [
    ./sensei.nix  # expert advisor
    ./shirei.nix  # orchestrator
    ./tansaku.nix # investigator
    ./kosei.nix   # editor
    ./kochiku.nix # builder
    ./tenken.nix  # validator
  ];
}
