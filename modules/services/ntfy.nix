{
  den.aspects.services.ntfy = {host, ...}: {
    nixos = {config, ...}: let
      url = "ntfy.${config.networking.domain}";
      port = config.alloc.ports.blocks.ntfy.start;
    in {
      alloc.ports.blocks.ntfy = {};
      services.ntfy-sh = {
        enable = true;
        settings = {
          base-url = url;
          listen-http = ":${toString port}";
        };
      };

      services.caddy.virtualHosts.${url}.extraConfig = ''
        reverse_proxy localhost:${toString port}
      '';
    };
  };
}
