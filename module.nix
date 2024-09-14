{ config, lib, pkgs, ...}:
let
  cfg = config.services.daveyjones;
in
{
  options = {
    services.daveyjones = {
      enabled = lib.options.mkOption {
        description = "Enable daveyjones service";
        default = false;
        type = lib.types.bool;
      };
      config = lib.options.mkOption {
        description = "Nix expression that will be written to config file.";
        default = "{}";
        type = lib.types.attrs;
        example = ''
          {
            topic = {
              default = "prometheusalerts";
              label = "topic";
            };
            ntfy = {
              url = "https://ntfy.example.com/";
              username = "user";
              password = "password";
            };
            templates = {
              title = "...";
              message = ''''''
                abcd
                '''''';
            };
          }
          '';
      };
    };
  };
  config = lib.mkIf cfg.enabled {
    # TODO: Integrate this better with systemd for privacy.
    system.environment.etc.davyjones = {
      "config.toml" = {
        source = builtins.writeText (pkgs.formats.toml.generate "config.toml" cfg.config);
        mode = "0444";
      };
    };
    systemd.services.daveyjones = {
      description = "daveyjones Dead Man Switch";
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.daveyjones}/bin/daveyjones";
        StateDirectory = "/var/lib/davyjones";
        DynamicUser = true;
        Restart = "on-failure";
        AmbientCapabilities = "cap_net_bind_service";
        RestartSec = 5;
      };
      unitConfig = {
        StartLimitIntervalSec = 0;
      };
    };
  };
}
