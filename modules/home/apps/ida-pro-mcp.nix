{ pkgs, ... }:
let
  pythonVersion = pkgs.python311.pythonVersion or "3.11";
  pythonSitePackages = "lib/python${pythonVersion}/site-packages";
  baseDir = "${pkgs.ida-pro-mcp}/${pythonSitePackages}/ida_pro_mcp";
  pluginDir = "${baseDir}/ida_mcp";
  loaderPath = "${baseDir}/ida_mcp.py";
in
{
  home.packages = with pkgs; [
    ida-pro-mcp
  ];

  home.file.".idapro/plugins/ida_mcp".source = pluginDir;
  home.file.".idapro/plugins/ida_mcp.py".source = loaderPath;
}
