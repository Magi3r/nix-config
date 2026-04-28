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
  den.ctx.user.includes = [den.provides.mutual-provider];

  # Sets the system hostname as defined in den.hosts.<name>.hostName
  den.default.includes = [
    den.provides.hostname
    <locale>
    <fonts>
    <networking>
    <bootloader>
    <nix>
    <programs/default>
    <tailscale>
  ];
}
