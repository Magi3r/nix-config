{
  den,
  inputs,
  lib,
  __findFile,
  ...
}: {
  flake-file.inputs = {
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.gelmir = {
    # host NixOS configuration
    nixos = {
      pkgs,
      lib,
      ...
    }: {
      imports = [
        inputs.disko.nixosModules.disko
        ./_hosts/gelmir/disko.nix
        ./_hosts/gelmir/hardware-configuration.nix
      ];

      networking.domain = "remote.magi3r.de";
    };

    includes = [
      <bootloader/systemd-boot>
      <ssh>
      <wubbaboo>
      <builder>

      <services/caddy>
      <services/homepage>
      <services/searxng>
      <services/palworld>
      # <services/minecraft>
      # <services/actual-budget>
    ];
  };
}
