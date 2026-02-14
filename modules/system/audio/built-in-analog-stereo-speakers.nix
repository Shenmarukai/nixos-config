{ ... }:
{
  services.pipewire.wireplumber.extraConfig."10-built-in-speaker" = {
    "monitor.alsa.rules" = [
      {
        matches = [
          {
            "node.name" = "alsa_output.pci-0000_00_1f.3.analog-stereo";
          }
        ];
        actions.update-props = {
          "priority.session" = 2200;
          "node.nick" = "Built In Speakers";
        };
      }
    ];
  };
}
