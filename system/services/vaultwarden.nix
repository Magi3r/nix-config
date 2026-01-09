{ config, lib, pkgs, ... }:
let cfg = config.my.vaultwarden;
in {

  options.my.vaultwarden = {
    enable = lib.mkEnableOption "Vaultwarden";

    url = lib.mkOption {
      type = lib.types.str;
      default = "vaultwarden.local";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8222;
    };
  };

  config = lib.mkIf cfg.enable {
    services.vaultwarden = {
      enable = true;
      config = {
        ROCKET_PORT = cfg.port;
        ROCKET_ADDRESS = "localhost";
        DOMAIN = "https://${cfg.url}";
        # TODO: Admin password
      };
      dbBackend = "postgresql";
      configurePostgres = true;
    };
  };

  my.caddy.virtualHosts.${cfg.url} = {
    proxyPass = "http://localhost:${toString cfg.port}";
  };

  my.homepage.services = [{
    "Services" = [{
      "Vaultwarden" = {
        description = "Password Manager";
        href = "https://${cfg.url}";
        icon = "vaultwarden.png";
      };
    }];
  }];
}
