{ config, lib, pkgs, ... }:
let cfg = config.my.searxng;
in {

  options.my.searxng = {
    enable = lib.mkEnableOption "SearXNG";

    url = lib.mkOption {
      type = lib.types.str;
      default = "searxng.local";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
    };
  };

  config = lib.mkIf cfg.enable {
    services.searxng = {
      enable = true;
      settings = {
        server.port = cfg.port;
        server.bind_address = "localhost";
      };
    };
  };

  my.caddy.virtualHosts.${cfg.url} = {
    proxyPass = "http://localhost:${toString cfg.port}";
  };

  my.homepage.services = [{
    "Services" = [{
      "SearXNG" = {
        description = "Metasearchengine";
        href = "https://${cfg.url}";
        icon = "searxng.png";
      };
    }];
  }];
}
