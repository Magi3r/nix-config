{
  den,
  __findFile,
  ...
}: {
  # user aspect
  den.aspects.wubbaboo = {
    includes = [
      den.provides.define-user
      den.provides.primary-user
      (den.provides.user-shell "fish")
      <git>
      <shell>
      <discord>
      <ghostty>
    ];

    homeManager = {pkgs, ...}: {
      home.packages = [];
      home.sessionVariables = {
        # EDITOR = "emacs";
        EDITOR = "hx";
        TERMINAL = "ghostty";
        XDG_TERMINAL_EMULATOR = "ghostty";

        NIXOS_OZONE_WL = "1"; # Hint electron apps to use wayland
        ELECTRON_OZONE_PLATFORM_HINT = "auto";

        XDG_SESSION_TYPE = "wayland";

        QT_AUTO_SCREEN_SCALE_FACTOR = "1.25";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1.25";
        QT_QPA_PLATFORM = "wayland;xcb";
      };
    };

    # user can provide NixOS configurations
    # to any host it is included on
    # provides.to-hosts.nixos = { pkgs, ... }: { };
  };
}
