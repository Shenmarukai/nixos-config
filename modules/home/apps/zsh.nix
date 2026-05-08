{ pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initExtraFirst = ''
      setopt promptsubst

      git_status_symbols() {
        local out=""

        if ! git diff --cached --quiet 2>/dev/null; then
          out="$out %F{#a6e3a1}✓%f"
        fi

        if ! git diff --quiet 2>/dev/null; then
          out="$out %F{#f38ba8}✗%f"
        fi

        echo "$out"
      }

      _show_context_once() {
        local branch git_marks
        branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
        git_marks="$(git_status_symbols)"

        if [ -n "$branch" ]; then
          print -P "%F{#89b4fa}%n%f %F{#cdd6f4}on%f %F{#94e2d5}%m%f %F{#cdd6f4}in%f %F{#f9e2af}%~%f at %F{#a6adc8}$branch%f$git_marks"
        else
          print -P "%F{#89b4fa}%n%f %F{#cdd6f4}on%f %F{#94e2d5}%m%f %F{#cdd6f4}in%f %F{#f9e2af}%~%f"
        fi
      }

      _show_context_once

      chpwd() {
        _show_context_once
      }

      clear() {
        command clear
        _show_context_once
      }

      _clear_and_redraw() {
        command clear
        _show_context_once
        zle reset-prompt
      }
      zle -N _clear_and_redraw
      bindkey '^L' _clear_and_redraw

      PROMPT='%F{#89b4fa}❯%f '
    '';

    plugins = [];
  };

   #catppuccin.zsh-syntax-highlighting.enable = true;
}
