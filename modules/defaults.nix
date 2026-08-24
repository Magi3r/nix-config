{
  lib,
  den,
  __findFile,
  ...
}: {
  den.default.nixos.system.stateVersion = "25.11";
  den.default.homeManager.home.stateVersion = "25.11";

  # enable hm by default
  den.schema.user.classes = lib.mkDefault ["homeManager"];

  # host<->user provides
  den.schema.user.includes = [den.batteries.mutual-provider];

  # Sets the system hostname as defined in den.hosts.<name>.hostName
  den.default.includes = [
    den.batteries.hostname
    # den.batteries.inputs'
    <locale>
    <networking>
    # <bootloader> # raspberry pi needs a special bootloader, so this has to be defined at host level
    <nix>
    <sops>
    <apps/default>
    <tailscale>
  ];
}
