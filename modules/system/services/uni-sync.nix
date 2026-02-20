{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.uniSync;

  channelOptions =
    { ... }:
    {
      options = {
        mode = lib.mkOption {
          type = lib.types.enum [
            "Manual"
            "PWM"
          ];
          description = "Channel control mode.";
        };

        speed = lib.mkOption {
          type = lib.types.int;
          description = "Fan speed percentage (1-100).";
        };
      };
    };

  deviceOptions =
    { ... }:
    {
      options = {
        deviceId = lib.mkOption {
          type = lib.types.str;
          description = "Identifier emitted by uni-sync for the controller.";
        };

        syncRgb = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether to mirror motherboard ARGB output.";
        };

        channels = lib.mkOption {
          type = lib.types.listOf (lib.types.submodule channelOptions);
          description = "Per-channel fan configuration.";
        };
      };
    };

  configPayload = {
    configs = map (deviceCfg: {
      device_id = deviceCfg.deviceId;
      sync_rgb = deviceCfg.syncRgb;
      channels = map (channelCfg: {
        mode = channelCfg.mode;
        speed = channelCfg.speed;
      }) deviceCfg.channels;
    }) cfg.configs;
  };

in
{
  options.services.uniSync = {
    enable = lib.mkEnableOption "Uni-Sync service";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.uni-sync;
      description = "Package providing the uni-sync binary.";
    };

    configs = lib.mkOption {
      default = [ ];
      type = lib.types.listOf (lib.types.submodule deviceOptions);
      description = "Declarative Uni-Sync device configurations.";
    };
  };

  config = lib.mkIf cfg.enable (
    let
      runtimeConfigPath = "/var/lib/uni-sync/uni-sync.json";
      configSource = pkgs.writeText "uni-sync.json" (builtins.toJSON configPayload);
    in
    {
      systemd.services.uni-sync = {
        description = "Uni-Sync service";
        wantedBy = [ "multi-user.target" ];
        before = [ "coolercontrold.service" ];
        after = [ "multi-user.target" ];
        preStart = ''
          install -Dm644 ${configSource} ${runtimeConfigPath}
        '';

        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${cfg.package}/bin/uni-sync ${runtimeConfigPath}";
          Restart = "on-failure";
          StateDirectory = "uni-sync";
        };
      };
    }
  );
}
