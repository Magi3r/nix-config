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
      pkgs,
      ...
    }: let
      url = "e2ee.remote.magi3r.de";
      port = config.alloc.ports.blocks.minecraft.start;
    in {
      alloc.ports.blocks.minecraft = {};
      systemd.tmpfiles.rules = [
        "d /var/lib/minecraft/e2ee 0755 root root -"
      ];

      sops.secrets.minecraft_env = {};

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
          environmentFiles = [
            config.sops.secrets.minecraft_env.path
          ];
          environment = {
            EULA = "TRUE";
            TYPE = "AUTO_CURSEFORGE";
            CF_PAGE_URL = "https://www.curseforge.com/minecraft/modpacks/enigmatica-2-expert-extended";
            MEMORY = "6G";
            USE_AIKAR_FLAGS = "true";
            TZ = "Europe/Berlin";
            ENABLE_WHITELIST = "TRUE";
            OVERRIDE_WHITELIST = "TRUE";
            OVERRIDE_OPS = "TRUE";
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
