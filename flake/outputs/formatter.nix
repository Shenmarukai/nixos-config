args@{ forEachSystem, pkgsFor, ... }:
{
  formatter = forEachSystem (
    system:
    let
      pkgs = pkgsFor system;
    in
    pkgs.nixfmt-rfc-style
  );
}
