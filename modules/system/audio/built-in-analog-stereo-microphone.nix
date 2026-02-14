{ ... }:
{
  services.pipewire.wireplumber.extraConfig."11-built-in-microphone" = {
    "monitor.alsa.rules" = [
      {
        matches = [
          {
            "node.name" = "alsa_input.pci-0000_00_1f.3.analog-stereo";
          }
        ];
        actions.update-props = {
          "priority.session" = 2200;
          "node.nick" = "Built In Microphone";
        };
      }
    ];
  };
}
