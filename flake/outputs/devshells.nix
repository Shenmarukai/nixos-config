args@{ forEachSystem, pkgsFor, ... }:
{
  devShells = forEachSystem (system:
    let pkgs = pkgsFor system;
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [
          git
          home-manager
          nixd
          nixfmt-rfc-style
        ];
      };
    });
}
