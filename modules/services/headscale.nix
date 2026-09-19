{
  inputs,
  den,
  __findFile,
  ...
}: {
  den.aspects.services.headscale = {
    nixos = {
      config,
      pkgs,
      ...
    }: let
      url = "tailscale.${config.networking.domain}";
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
          policy.path = inputs.self + "/assets/config/headscale/acl.hujson";
          dns = {
            base_domain = "headscale.${config.networking.domain}";
            nameservers.global = [
              "1.1.1.1"
              "1.0.0.1"
            ];
          };
          logtail.enabled = false;
        };
      };

      systemd.tmpfiles.rules = [
        "d /var/lib/headscale 0750 headscale headscale -"
        "Z /var/lib/headscale 0750 headscale headscale -"
      ];

      # Caddy reverse proxy to headscale
      services.caddy.virtualHosts.${url}.extraConfig = ''
        reverse_proxy localhost:${toString port}
      '';
    };
  };
}
