{ ... }:
{
  services.pipewire.wireplumber.extraConfig."11-microsoft-mic" = {
    "monitor.alsa.rules" = [
      {
        matches = [
          {
            "node.name" = "alsa_input.usb-Microsoft_Microsoft_USB_Link_0V333DQ215100F-00.mono-fallback";
          }
        ];
        actions.update-props = {
          "priority.session" = 2200;
          "node.nick" = "Microsoft Link Mic";
        };
      }
    ];
  };
}
