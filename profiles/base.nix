# TODO add descriptive comments
{
  pkgs,
  ...
}: {
  imports = [
    ../system/locale.nix
    ../system/programs.nix
    ../system/users.nix
    ../system/nix-config.nix

    ../system/network.nix
  ];
}
