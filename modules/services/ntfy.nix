{
  den.aspects.services.ntfy = {
    pkgs,
    lib,
    ...
  }: let
    url = "ntfy.local.magi3r.de";
    # port = 8080;
  in {
    alloc.ports.blocks.ntfy = {};

    nixos = {config, ...}: let
      port = config.alloc.ports.blocks.ntfy.start;
    in {
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
