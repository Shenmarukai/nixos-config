{ ... }: {
  hardware.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    wireplumber.extraConfig = {
      "force-x2u-default-source" = {
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

      "force-usb-speakers-default-sink" = {
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
    };
  };
}
