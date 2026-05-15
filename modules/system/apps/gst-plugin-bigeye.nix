{ pkgs, lib, ... }:

let
  libuvcWithJpeg = pkgs.libuvc.overrideAttrs (old: {
    buildInputs = (old.buildInputs or []) ++ [
      pkgs.libusb1
      pkgs.libjpeg_turbo
    ];

    cmakeFlags = (old.cmakeFlags or []) ++ [
      "-DBUILD_UVC_EXAMPLE=OFF"
      "-DENABLE_JPEG=ON"
    ];
  });

  gst-plugin-bigeye = pkgs.rustPlatform.buildRustPackage rec {
    pname = "gst-plugin-bigeye";
    version = "0.1.1";

    src = pkgs.fetchFromGitHub {
      owner = "foxyote";
      repo = "gst-plugin-bigeye";
      rev = "8b2f550";
      hash = "sha256-pqTak1o9UYOgtsgZFvfXzH0lNLmyoKL5C/jvqwxCywc=";
    };

    cargoHash = "sha256-g2dy5C7tZS+T4np1h5sG7CmijG8Z+9k9dM4W+wF0D04=";

    nativeBuildInputs = [
      pkgs.pkg-config
      pkgs.rustPlatform.bindgenHook
    ];

    buildInputs = [
      pkgs.gst_all_1.gstreamer
      pkgs.gst_all_1.gst-plugins-base
      pkgs.libusb1
      libuvcWithJpeg
      pkgs.libjpeg_turbo
    ];

    PKG_CONFIG_PATH = "${libuvcWithJpeg}/lib/pkgconfig";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/gstreamer-1.0

      echo "Built shared objects:"
      find target -name "*.so" -print

      find target -name "*.so" -exec cp -v {} $out/lib/gstreamer-1.0/ \;

      echo "Installed plugin files:"
      find $out -type f -print

      runHook postInstall
    '';

    meta = {
      description = "GStreamer source plugin for Bigscreen Beyond 2E cameras";
      homepage = "https://github.com/foxyote/gst-plugin-bigeye";
      license = lib.licenses.asl20;
      platforms = lib.platforms.linux;
    };
  };

  baballonia-bigeye = pkgs.writeShellScriptBin "baballonia-bigeye" ''
    set -euo pipefail

    BABALLONIA_DIR="$HOME/.local/share/Steam/steamapps/common/Baballonia"

    cd "$BABALLONIA_DIR"

    export GST_PLUGIN_PATH="${gst-plugin-bigeye}/lib/gstreamer-1.0:${pkgs.gst_all_1.gstreamer.out}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-base}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-good}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-bad}/lib/gstreamer-1.0''${GST_PLUGIN_PATH:+:$GST_PLUGIN_PATH}"

    export LD_LIBRARY_PATH="$BABALLONIA_DIR:${pkgs.gst_all_1.gstreamer.out}/lib:${pkgs.xorg.libICE.out}/lib:${pkgs.xorg.libSM.out}/lib:/run/current-system/sw/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

    exec ${pkgs.steam-run}/bin/steam-run ./Baballonia.Desktop
  '';
in
{
  environment.systemPackages = [
    baballonia-bigeye

    gst-plugin-bigeye
    pkgs.gst_all_1.gstreamer
    pkgs.gst_all_1.gst-plugins-base
    pkgs.gst_all_1.gst-plugins-good
    pkgs.gst_all_1.gst-plugins-bad
  ];

  environment.sessionVariables.GST_PLUGIN_PATH = lib.concatStringsSep ":" [
    "${gst-plugin-bigeye}/lib/gstreamer-1.0"
    "${pkgs.gst_all_1.gstreamer.out}/lib/gstreamer-1.0"
    "${pkgs.gst_all_1.gst-plugins-base}/lib/gstreamer-1.0"
    "${pkgs.gst_all_1.gst-plugins-good}/lib/gstreamer-1.0"
    "${pkgs.gst_all_1.gst-plugins-bad}/lib/gstreamer-1.0"
  ];

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="35ca", MODE="0666", TAG+="uaccess"
  '';
}
