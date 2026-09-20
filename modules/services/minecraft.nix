{
  den,
  inputs,
  lib,
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
      url = "e2ee.${config.networking.domain}";
      port = config.alloc.ports.blocks.minecraft.start;

      serverPackZip = pkgs.fetchurl {
        url = "https://github.com/Krutoy242/Enigmatica2Expert-Extended/releases/download/v1.87.1/E2E-Extended-v1.87.1-server.zip";
        hash = "sha256-By98KHGTlzHLleUah9qQzdxZPe7pldveBHZVGBb1Vik=";
      };

      # Prepare server files with declarative configs from assets/
      serverBase =
        pkgs.runCommand "e2ee-server-base" {
          nativeBuildInputs = [pkgs.unzip];
        } ''
          mkdir -p $out
          unzip -q ${serverPackZip} -d $out
          chmod -R u+w $out

          # Copy declarative configs from assets/config/minecraft-e2ee
          cp ${inputs.self}/assets/config/minecraft-e2ee/server-setup-config.yaml $out/server-setup-config.yaml
          mkdir -p $out/custom-configs
          cp ${inputs.self}/assets/config/minecraft-e2ee/justenoughdimensions.cfg $out/custom-configs/justenoughdimensions.cfg
        '';
    in {
      alloc.ports.blocks.minecraft = {};
      systemd.tmpfiles.rules = [
        "d /var/lib/minecraft/e2ee 0755 1000 1000 -"
      ];

      # Automatically populate server files if not already installed
      systemd.services."docker-minecraft-e2ee".preStart = lib.mkAfter ''
        if [ ! -f /var/lib/minecraft/e2ee/serverstarter.lock ] && [ ! -f /var/lib/minecraft/e2ee/cleanroom-0.6.11-alpha.jar ]; then
          rm -rf /var/lib/minecraft/e2ee/* /var/lib/minecraft/e2ee/.* 2>/dev/null || true
          cp -r ${serverBase}/* /var/lib/minecraft/e2ee/
          chmod -R u+rwX /var/lib/minecraft/e2ee
          chown -R 1000:1000 /var/lib/minecraft/e2ee
        fi
      '';

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
            TYPE = "CUSTOM";
            CUSTOM_SERVER = "https://github.com/EnigmaticaModpacks/ServerStarter/releases/download/v2.4.6/serverstarter-2.4.6.jar";
            LEVEL_TYPE = "BIOMESOP";
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
