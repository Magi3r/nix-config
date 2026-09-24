{
  den,
  inputs,
  ...
}: {
  den.aspects.services.matrix-server = {host, ...}: {
    nixos = {
      config,
      pkgs,
      ...
    }: let
      url = "matrix.${config.networking.domain}";
      port = config.alloc.ports.blocks.tuwunel.start;
      whatsappPort = config.alloc.ports.blocks.mautrix-whatsapp.start;
    in {
      alloc.ports.blocks.tuwunel = {};
      alloc.ports.blocks.mautrix-whatsapp = {};

      # Permit libolm for mautrix-whatsapp
      nixpkgs.config.permittedInsecurePackages = [
        "olm-3.2.16"
      ];

      systemd.tmpfiles.rules = [
        "d /var/lib/tuwunel-appservices 0750 tuwunel tuwunel -"
        "L+ /var/lib/tuwunel-appservices/whatsapp-registration.yaml - - - - /var/lib/mautrix-whatsapp/whatsapp-registration.yaml"
      ];

      # --- Tuwunel Matrix Homeserver ---
      services.matrix-tuwunel = {
        enable = true;
        settings.global = {
          server_name = "${config.networking.domain}";
          port = [port];
          appservice_dir = "/var/lib/tuwunel-appservices";
          well_known = {
            client = "https://${url}";
            server = "${url}:443";
            livekit_url = ""; # TODO add livekit
          };
        };
      };

      systemd.services.tuwunel = {
        # wants = ["mautrix-whatsapp.service"];
        # after = ["mautrix-whatsapp.service"];
        serviceConfig.SupplementaryGroups = ["mautrix-whatsapp"];
      };

      # --- Mautrix-WhatsApp Bridge ---
      services.mautrix-whatsapp = {
        enable = true;
        serviceDependencies = [];
        settings = {
          homeserver = {
            address = "http://127.0.0.1:${toString port}";
            domain = config.networking.domain;
          };
          appservice = {
            hostname = "127.0.0.1";
            port = whatsappPort;
            address = "http://127.0.0.1:${toString whatsappPort}";
          };
          bridge = {
            permissions = {
              "*" = "relay";
              "${config.networking.domain}" = "user";
              "@admin:${config.networking.domain}" = "admin";
            };
          };
        };
      };

      # --- Reverse Proxy (Caddy) ---
      services.caddy.virtualHosts.${url}.extraConfig = ''
        reverse_proxy localhost:${toString port}
      '';
      services.caddy.virtualHosts."${config.networking.domain}".extraConfig = ''
        reverse_proxy /.well-known/matrix/* localhost:${toString port}
      '';

      # Shortcut for creating initial user
      environment.systemPackages = [
        (pkgs.writeScriptBin "tuwunel-create-user"
          (builtins.readFile "${inputs.self}/assets/scripts/tuwunel-create-user.sh"))
      ];
    };
  };
}
