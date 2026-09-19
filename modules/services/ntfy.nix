{
  den.aspects.services.ntfy = {host, ...}: let
    url = "ntfy.local.magi3r.de";
    # port = 8080;
  in {
    nixos = {config, ...}: let
      port = config.alloc.ports.blocks.ntfy.start;
    in {
      alloc.ports.blocks.ntfy = {};
      services.ntfy-sh = {
        enable = true;
        settings = {
          base_url = url;
          listen-http = ":${toString port}";
        };
      };

      services.caddy.virtualHosts.${url}.extraConfig = ''
        reverse_proxy localhost:${toString port}
      '';
    };
  };
}
