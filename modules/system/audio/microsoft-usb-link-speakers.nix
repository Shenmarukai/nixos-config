{ ... }:
{
  services.pipewire.wireplumber.extraConfig."10-microsoft-speaker" = {
    "monitor.alsa.rules" = [
      {
        matches = [
          {
            "node.name" = "alsa_output.usb-Microsoft_Microsoft_USB_Link_0V333DQ215100F-00.analog-stereo";
          }
        ];
        actions.update-props = {
          "priority.session" = 2200;
          "node.nick" = "Microsoft Link Speakers";
        };
      }
    ];
  };
}
