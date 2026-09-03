{
  inputs,
  lib,
  ...
}: {
  flake-file.inputs = {
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.builder = {
    nixos = {
      users.users.builder = {
        isNormalUser = true;
        extraGroups = ["wheel"];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPLwPQ7gVfjmUVIzj4d/DYeIMe3Ph2iNNEsp3EPiOHSa"
        ];
      };

      # Only allow the builder user passwordless sudo for activations
      security.sudo.extraRules = [
        {
          users = ["builder"];
          commands = [
            {
              command = "ALL";
              options = ["NOPASSWD"];
            }
          ];
        }
      ];

      # Allow builder to talk to nix daemon for remote builds and closures
      nix.settings.trusted-users = ["builder"];
    };
  };

  flake = {
    deploy = {
      nodes = {
        gelmir = {
          hostname = "gelmir";
          sshUser = "builder";
          remoteBuild = true;
          profiles.system = {
            user = "root";
            path = inputs.deploy-rs.lib.aarch64-linux.activate.nixos inputs.self.nixosConfigurations.gelmir;
          };
        };
        # altus = {
        #   hostname = "altus";
        #   sshUser = "wubbaboo";
        #   remoteBuild = true;
        #   profiles.system = {
        #     user = "root";
        #     path = inputs.deploy-rs.lib.aarch64-linux.activate.nixos inputs.self.nixosConfigurations.altus;
        #   };
        # };
        "farum-azula" = {
          # TODO: replace with the real IP once assigned by Webtropia.
          hostname = "farum-azula";
          sshUser = "builder";
          # After the first nixos-anywhere install, switch to remoteBuild = true
          # to avoid shipping the nix store across the line on every deploy.
          remoteBuild = false;
          profiles.system = {
            user = "root";
            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos inputs.self.nixosConfigurations."farum-azula";
          };
        };
      };
    };
  };

  perSystem = {
    pkgs,
    system,
    ...
  }: {
    packages = {
      deploy-rs = inputs.deploy-rs.packages.${system}.default;
      nixos-anywhere = pkgs.nixos-anywhere;
    };

    checks = lib.optionalAttrs (inputs.deploy-rs ? lib.${system}) {
      deploy-schema = (inputs.deploy-rs.lib.${system}.deployChecks inputs.self.deploy).deploy-schema;
    };
  };
}
