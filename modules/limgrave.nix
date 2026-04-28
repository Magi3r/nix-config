{
  den,
  __findFile,
  ...
}: {
  # host aspect
  den.aspects.limgrave = {
    # host NixOS configuration
    nixos = {
      pkgs,
      lib,
      ...
    }: {
      console.keyMap = lib.mkForce "us";
      # environment.systemPackages = [pkgs.hello];
      imports = [
        ./_hosts/limgrave/hardware-configuration.nix
      ];
    };

    includes = [
      # den.default.includes
      <audio>
      <bluetooth>
      <desktop/niri>
      <print-and-scan>
      <programs/gui>
      <wubbaboo>
      ##############
      <locale>
      <fonts>
      <networking>
      <bootloader>
      <nix>
      <programs/default>
      <tailscale>
    ];

    # host provides default home environment for its users
    # provides.to-users.homeManager =
    #   { pkgs, ... }:
    #   {
    #     home.packages = [ pkgs.vim ];
    #   };
  };
}
