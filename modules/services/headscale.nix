{
  inputs,
  den,
  __findFile,
  ...
}: {
  den.aspects.services.headscale = {
    includes = [
      <services/caddy>
    ];

    nixos = {config, pkgs, ...}: let
      url = "headscale.${config.networking.domain}";
      port = config.alloc.ports.blocks.headscale.start;
    in {
      alloc.ports.blocks.headscale = {};

      services.headscale = {
        enable = true;
        address = "127.0.0.1";
        port = port;
        settings = {
          server_url = "https://${url}";
          metrics_listen_addr = "127.0.0.1:9877";
        };
      };

      sops.secrets.headscale_config = {};

      systemd.tmpfiles.rules = [
        "d /var/lib/headscale 0750 root root -"
      ];

      # Caddy reverse proxy to headscale
      services.caddy.virtualHosts.${url}.extraConfig = ''
        reverse_proxy localhost:${toString port}
      '';
    };
  };
}
