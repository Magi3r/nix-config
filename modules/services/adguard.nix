{
  den.aspects.services.adguard = {
    pkgs,
    lib,
    ...
  }: let
    url = "adguard.local.magi3r.de";
  in {
    nixos = {
      services.adguardhome = {
        host = "localhost";
        enable = true;
        # Config is copied over manually
      };

      services.caddy.virtualHosts.${url}.extraConfig = ''
        reverse_proxy localhost:3000
      '';
    };

    networking.firewall = {
      allowedTCPPorts = [
        53
      ];

      allowedUDPPorts = [
        53
      ];
    };
  };
}
