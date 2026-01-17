{ ... }:
{
  services.pipewire.wireplumber.extraConfig."force-usb-speakers-default-sink" = {
    "monitor.alsa.rules" = [
      {
        matches = [
          {
            "node.name" = "alsa_output.usb-Generic_USB_Audio-00.HiFi__Speaker__sink";
          }
        ];
        actions.update-props = {
          "priority.session" = 2200;
          "node.nick" = "USB Speakers";
        };
      }
    ];
  };
}
