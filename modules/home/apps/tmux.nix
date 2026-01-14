{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    mouse = true;

    plugins = with pkgs.tmuxPlugins; [
      catppuccin
      cpu
      battery
      sensible
      vim-tmux-navigator
    ];

    extraConfig = ''
      set-option -sa terminal-overrides ",xterm*:Tc"

      bind M-r source-file ~/.config/tmux/tmux.conf

      unbind C-b
      set-option -g prefix C-Space
      bind-key C-Space send-prefix

      bind -n C-Left select-pane -L
      bind -n C-Right select-pane -R
      bind -n C-Up select-pane -U
      bind -n C-Down select-pane -D

      set -g mouse on
    '';
  };

  home.file.".tmux.conf".text = ''
    source-file ~/.config/tmux/tmux.conf
  '';
}
