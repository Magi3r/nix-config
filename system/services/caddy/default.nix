{ config, lib, pkgs, ... }:
let
  vhosts = config.my.caddy.virtualHosts;
  hasVHosts = vhosts != { };
in {
  options.my.caddy.virtualHosts = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    default = { };
    description = "Map of hostname -> reverse proxy target";
  };

  config = lib.mkIf hasVHosts {
    services.caddy = {
      enable = true;

      acme = {
        email = "jvd@outlook.de";
        dns = {
          provider = "cloudflare";
          credentialsFile = config.sops.secrets.cloudflare.path;
        };
      };

      virtualHosts = lib.mapAttrs (_host: upstream: {
        extraConfig = ''
          reverse_proxy ${upstream}
        '';
      }) vhosts;
    };

  };
}
