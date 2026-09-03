{
  den,
  __findFile,
  ...
}: {
  den.aspects.services.anno-domini = {
    includes = [
      <virtualisation>
      <services/caddy>
    ];

    nixos = {
      config,
      pkgs,
      lib,
      ...
    }: let
      hostUrl = "ad.${config.networking.domain}";
      port = config.alloc.ports.blocks.anno-domini.start;
    in {
      alloc.ports.blocks.anno-domini = {};

      # Mount games directory (read-only) for all game content
      systemd.tmpfiles.rules = [
        "d /var/lib/games 0750 root root -"
      ];

      # OCI container for the Node.js app
      virtualisation.oci-containers.containers = {
        anno-domini = {
          image = "magi3r/anno-domini:v1.1.0";
          autoStart = true;
          ports = [
            "127.0.0.1:${toString port}:8080"
          ];
          volumes = [
            "/var/lib/games:/app/games:ro"
          ];
        };
      };

      # Caddy handles TLS + firewall; no direct port exposure needed.
      services.caddy.virtualHosts.${hostUrl}.extraConfig = ''
        reverse_proxy localhost:${toString port}
      '';
    };
  };
}
