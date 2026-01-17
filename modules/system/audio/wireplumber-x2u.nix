{ ... }:
{
  services.pipewire.wireplumber.extraConfig."force-x2u-default-source" = {
    "monitor.alsa.rules" = [
      {
        matches = [
          {
            "node.name" = "alsa_input.usb-Shure_Incorporated_Shure_Digital-00.analog-stereo";
          }
        ];
        actions.update-props = {
          "priority.session" = 2200;
          "node.nick" = "X2u Mic";
        };
      }
    ];
  };
}
