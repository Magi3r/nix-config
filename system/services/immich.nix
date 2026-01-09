{ config, lib, pkgs, ... }:
let cfg = config.my.immich;
in {

  options.my.immich = {
    enable = lib.mkEnableOption "Immich";

    url = lib.mkOption {
      type = lib.types.str;
      default = "immich.local";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 2283;
    };
  };

  config = lib.mkIf cfg.enable {
    services.immich = {
      enable = true;
      port = cfg.port;
      allowedHosts = cfg.url;

      settings = {
        server.externalDomain = "https://${cfg.url}";
      }; # TODO: add more settings, like oauth
    };
  };

  my.caddy.virtualHosts.${cfg.url} = {
    proxyPass = "http://localhost:${toString cfg.port}";
  };

  my.homepage.services = [{
    "Services" = [{
      "Immich" = {
        description = "Fotos";
        href = "https://${cfg.url}";
        icon = "immich.png";
      };
    }];
  }];
}
