{
  den,
  inputs,
  __findFile,
  ...
}: {
  flake-file.inputs = {
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects."farum-azula" = {
    # host NixOS configuration
    nixos = {
      imports = [
        inputs.disko.nixosModules.disko
        ./_hosts/farum-azula/disko.nix
        ./_hosts/farum-azula/hardware-configuration.nix
      ];

      networking.domain = "magi3r.de";

      # Lock root account
      users.users.root.hashedPassword = "!";

      # Passwordless sudo for wheel users (required for non-root deploy-rs activation)
      security.sudo.wheelNeedsPassword = false;
    };

    includes = [
      <bootloader/systemd-boot>
      <ssh>
      <wubbaboo>
      <builder>

      <services/caddy>
      <services/anno-domini>
      <services/headscale>
    ];
  };
}
