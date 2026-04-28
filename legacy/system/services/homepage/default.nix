{ config, lib, pkgs, ... }:
let
  services = lib.flatten config.my.homepage.services;
  cfg = config.my.homepage;
in {

  options.my.homepage = {
    enable = lib.mkEnableOption "Homepage";

    services = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = [ ];
    };

    url = lib.mkOption {
      type = lib.types.str;
      default = "hompage.local";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8082;
    };
  };

  config = lib.mkIf cfg.enable {
    services.homepage-dashboard = {
      services = services;
      allowedHosts = cfg.url;
    };
  };

  my.caddy.virtualHosts.${cfg.url} = {
    proxyPass = "http://localhost:${toString cfg.port}";
  };
}
