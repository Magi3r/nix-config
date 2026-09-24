{den, ...}: {
  den.aspects.services.bentopdf = {host, ...}: {
    nixos = {config, ...}: let
      url = "pdf.${config.networking.domain}";
      # port = config.alloc.ports.blocks.bentopdf.start;
    in {
      # alloc.ports.blocks.bentopdf = {};

      services.bentopdf = {
        enable = true;
        domain = url;
        caddy.enable = true;
      };

      # services.caddy.virtualHosts.${url}.extraConfig = ''
      #   reverse_proxy localhost:${toString port}
      # '';
    };
  };
}
