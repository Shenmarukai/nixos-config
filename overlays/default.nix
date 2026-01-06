final: prev: {
  vrr-status = prev.writeShellScriptBin "vrr-status" ''
    state=$(
      swaymsg -r -t get_outputs |
      jq -r '.[] | select(.name=="DP-3") | .adaptive_sync_status'
    )

    if [ "$state" = "enabled" ]; then
      alt="on"
    else
      alt="off"
    fi

    printf '{"text":"%s","alt":"%s"}\n' "$alt" "$alt"
  '';

  uni-sync = prev.rustPlatform.buildRustPackage {
    pname = "uni-sync";
    version = "0.3.1";

    src = prev.fetchFromGitHub {
      owner = "EightB1ts";
      repo = "uni-sync";
      rev = "0.3.1";
      sha256 = "05afs06pgbskrs9k9l760kz2mv7smn2i54i8kkf12x3r7q72vzj1";
    };

    cargoHash = "sha256-ot2pbCddvw3njsz36WbFFJ9AAtmojUnRxlUbym1RcgU=";

    patches = [
      ./uni-sync-cli-config-path.patch
    ];

    nativeBuildInputs = [ prev.pkg-config ];
    buildInputs = [ prev.hidapi prev.libusb1 ];

    meta = with prev.lib; {
      description = "Synchronization tool for Lian Li Uni controllers";
      homepage = "https://github.com/EightB1ts/uni-sync";
      license = licenses.mit;
      mainProgram = "uni-sync";
      platforms = platforms.linux;
    };
  };
}
