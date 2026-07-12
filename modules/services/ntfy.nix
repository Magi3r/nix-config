{
  den.aspects.services.ntfy = {
    pkgs,
    lib,
    ...
  }: let
    url = "ntfy.local.magi3r.de";
    port = 8080;
  in {
    nixos = {config, ...}: {
      services.ntfy-sh = {
        enable = true;
        settings = {
          base_url = url;
          listen-http = ":${port}";
        };
      };

      services.caddy.virtualHosts.${url}.extraConfig = ''
        reverse_proxy localhost:${port}
      '';
    };
  };
}
