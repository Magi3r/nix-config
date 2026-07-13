{
  den.aspects.services.adguard = {
    pkgs,
    lib,
    ...
  }: let
    url = "adguard.local.magi3r.de";
  in {
    nixos = {config, ...}: let
      port = config.alloc.ports.blocks.adguard.start;
    in {
    alloc.ports.blocks.adguard = {};
      services.adguardhome = {
        host = "localhost";
        enable = true;
        # Config is copied over manually
        settings = {
          http.address = "127.0.0.1:${port}";
        };
      };

      services.caddy.virtualHosts.${url}.extraConfig = ''
        reverse_proxy localhost:${port}
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
