{
  den,
  __findFile,
  ...
}: {
  den.aspects.services.grimoire-codex = {
    includes = [
      <virtualisation>
    ];

    nixos = {
      config,
      pkgs,
      lib,
      ...
    }: let
      url = "grimoire.${config.networking.domain}";
      port = config.alloc.ports.blocks.grimoire.start;
    in {
      alloc.ports.blocks.grimoire = {};

      systemd.tmpfiles.rules = [
        "d /var/lib/grimoire 0755 root root -"
        "d /var/lib/grimoire/data 0755 root root -"
        "d /var/lib/grimoire/library 0755 root root -"
      ];

      virtualisation.oci-containers.containers.grimoire = {
        image = "hunterreadca/grimoire:latest";
        autoStart = true;
        ports = [
          "127.0.0.1:${toString port}:9481"
        ];
        volumes = [
          "/var/lib/grimoire/data:/data"
          "/var/lib/grimoire/library:/library"
        ];
        environment = {
          LIBRARY_PATH = "/library";
          DATA_PATH = "/data";
          WORKERS = "1";
          BASE_URL = "https://${url}";
          TZ = "Europe/Berlin";
        };
      };

      services.caddy.virtualHosts.${url}.extraConfig = ''
        reverse_proxy localhost:${toString port}
      '';
    };
  };
}
