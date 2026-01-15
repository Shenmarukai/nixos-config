{ inputs, pkgs, lib, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
in {
  home.packages = [
    inputs.opencode.packages.${system}.default
  ];

  xdg.configFile."opencode/opencode.jsonc".source =
    ../../../home/shane/opencode/opencode.jsonc;

  xdg.configFile."opencode/agent" = {
    source = ../../../home/shane/opencode/agent;
    recursive = true;
  };

  xdg.configFile."opencode/prompt" = {
    source = ../../../home/shane/opencode/prompt;
    recursive = true;
  };

  xdg.configFile."opencode/command" = {
    source = ../../../home/shane/opencode/command;
    recursive = true;
  };

  xdg.configFile."opencode/tools" = {
    source = ../../../home/shane/opencode/tool;
    recursive = true;
  };

  xdg.configFile."opencode/skills" = {
    source = ../../../home/shane/opencode/skill;
    recursive = true;
  };
}
