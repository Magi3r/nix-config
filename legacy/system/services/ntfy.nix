{ config, lib, pkgs, ... }:
let cfg = config.my.ntfy;
in {

  options.my.ntfy = {
    enable = lib.mkEnableOption "ntfy";

    url = lib.mkOption {
      type = lib.types.str;
      default = "ntfy.local";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8081;
    };
  };

  config = lib.mkIf cfg.enable {
    services.ntfy-sh = {
      enable = true;
      settings = {
        base-url = "https://${cfg.url}";
        listen-http = ":${toString cfg.port}";
      };
    };
  };

  my.caddy.virtualHosts.${cfg.url} = {
    proxyPass = "http://localhost:${toString cfg.port}";
  };

  my.homepage.services = [{
    "Services" = [{
      "ntfy" = {
        description = "Push-Notifications";
        href = "https://${cfg.url}";
        icon = "ntfy.png";
      };
    }];
  }];
}
