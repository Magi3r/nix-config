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
      services.xserver.xkb.layout = lib.mkForce  "us";

      services.upower.enable = true;
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
      <apps/gui>
      <wubbaboo>
      # ##############
      # <locale>
      # <fonts>
      # <networking>
      # <bootloader>
      # <nix>
      # <apps/default>
      # <tailscale>
    ];

    # host provides default home environment for its users
    # provides.to-users.homeManager =
    #   { pkgs, ... }:
    #   {
    #     home.pkgs = []
    #   };
    # }:
  };
}
