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
}
