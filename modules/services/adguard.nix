{
  den.aspects.services.adguard = {
    host,
    ...
  }: let
    url = "adguard.local.magi3r.de";
  in {
    nixos = {host, config, ...}: let
      port = config.alloc.ports.blocks.adguard.start;
    in {
    alloc.ports.blocks.adguard = {};
      services.adguardhome = {
        host = "localhost";
        enable = true;
        # Config is copied over manually
        settings = {
          http.address = "127.0.0.1:${toString port}";
        };
      };

      services.caddy.virtualHosts.${url}.extraConfig = ''
        reverse_proxy localhost:${toString port}
      '';
      networking.firewall = {
        allowedTCPPorts = [
          53
        ];

        allowedUDPPorts = [
          53
        ];
      };
    };
  };
}
