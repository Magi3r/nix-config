{
  den,
  __findFile,
  ...
}: {
  den.aspects.services.minecraft = {
    includes = [
      <virtualisation>
    ];

    nixos = {
      host,
      config,
      ...
    }: let
      url = "e2ee.remote.magi3r.de";
      port = config.alloc.ports.blocks.minecraft.start;
    in {
      alloc.ports.blocks.minecraft = {};
      systemd.tmpfiles.rules = [
        "d /var/lib/minecraft/e2ee 0755 root root -"
      ];

      virtualisation.oci-containers.containers = {
        mc-router = {
          image = "itzg/mc-router";
          autoStart = true;
          ports = [
            "25565:25565"
          ];
          environment = {
            MAPPING = "${url}=127.0.0.1:${toString port}";
            DEFAULT = "127.0.0.1:${toString port}";
          };
          extraOptions = [
            "--network=host"
          ];
        };
        minecraft-e2ee = {
          image = "itzg/minecraft-server:java25";
          autoStart = true;
          ports = [
            "127.0.0.1:${toString port}:25565"
          ];
          volumes = [
            "/var/lib/minecraft/e2ee:/data"
          ];
          environment = {
            EULA = "TRUE";
            TYPE = "CURSEFORGE";
            CF_SERVER_MOD = "https://github.com/Krutoy242/Enigmatica2Expert-Extended/releases/download/v1.85.1-beta/E2E-Extended-v1.85.1-beta-server.zip";
            MEMORY = "6G";
            USE_AIKAR_FLAGS = "true";
            TZ = "Europe/Berlin";
          };
        };
      };

      networking.firewall = {
        allowedTCPPorts = [25565];
        allowedUDPPorts = [25565];
      };
    };
  };
}
