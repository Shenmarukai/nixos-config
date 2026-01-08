final: prev:
let
  inherit (prev) lib python3 requireFile;
  setupScript = requireFile {
    name = "ida-pro-setup.py";
    url = "Run `nix store add-file ida-pro-setup.py` to provide this script";
    sha256 = "efa29b12888b5b8ef7c8c2bea1dac1b24f56fe137752f436c8ef88bfdf4fe89b";
  };
  appendPostInstall = ''
    IDADIR="$out/opt"
    cd "$IDADIR"
    ${python3}/bin/python ${setupScript} --oneshot --name "shane"
  '';
in {
  ida-pro = prev.ida-pro.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ python3 ];
    postInstall = lib.concatStringsSep "\n" (lib.filter (s: s != "") [
      (old.postInstall or "")
      appendPostInstall
    ]);
  });
}
