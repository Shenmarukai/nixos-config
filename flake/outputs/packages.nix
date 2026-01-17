args@{
  forEachSystem,
  pkgsFor,
  inputs,
  self,
  ...
}:
{
  packages = forEachSystem (
    system:
    let
      pkgs = pkgsFor system;
    in
    import (self + "/pkgs") { inherit pkgs inputs; }
  );
}
