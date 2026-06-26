{
  inputs,
  den,
  __findFile,
  ...
}: {
  flake-file.inputs = {
    qylock.url = "github:Darkkal44/qylock";
    qylock.inputs.nixpkgs.follows = "nixpkgs";
  };
  den.aspects.desktop.niri = {
    includes = [
      <noctalia-shell>
    ];
    nixos = {pkgs, ...}: {
      imports = [
        inputs.qylock.nixosModules.default
      ];
      environment.systemPackages = with pkgs; [
        xwayland-satellite # xwayland support
      ];
      services.displayManager = {
        # login manager
        sddm = {
          enable = true;
          enableHidpi = true;
          settings = {};
          wayland.enable = true;
        };
        defaultSession = "niri";
      };

      programs.niri.enable = true;
      programs.qylock = {
        enable = true;
        theme = "pixel-skyscrapers"; # any directory name under themes/
        # sddm.enable = true;             # installs theme + sets it active (default)
        # quickshell.enable = true;       # adds `qylock-lock` to PATH (default)

        # Optional per-theme tweaks (replaces the interactive prompts):
        # themeOptions = {
        #   terraria.backgroundMode = "time";              # time | random | static                    # menu | game
        # };
      };
    };

    provides.to-users = {
      homeManager = {
        pkgs,
        # config,
        #inputs,
        ...
      }: {
        xdg.configFile."niri/config.kdl".source = ../assets/config/niri/config.kdl;
      };
    };
  };
}
