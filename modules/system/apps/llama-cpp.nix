{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    llama-cpp-vulkan
  ];
}
#let
#  llamaPkg = inputs.llama-cpp.packages.x86_64-linux.cuda;
#
#  llamaWrapper = pkgs.stdenv.mkDerivation {
#    pname = "llama-wrapper";
#    version = inputs.llama-cpp.rev;
#    src = ./.;
#    dontUnpack = true;
#
#    buildPhase = ''
#      mkdir -p $out/bin
#      ln -s ${llamaPkg}/bin/llama $out/bin/llama
#      if [ -x ${llamaPkg}/bin/llama ]; then
#        ln -s ${llamaPkg}/bin/llama $out/bin/llama-native || true
#      fi
#    '';
#
#    installPhase = ''
#      true
#    '';
#
#    meta = with pkgs.lib; {
#      description = "User-facing symlink wrapper for llama-cpp (CUDA)";
#      license = licenses.mit;
#      platforms = platforms.linux;
#    };
#  };
#in {
#  environment.systemPackages = [
#    llamaWrapper
#  ];
#}
