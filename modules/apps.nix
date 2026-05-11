{
  den,
  __findFile,
  ...
}: {
  den.aspects.apps = {
    nixos = {pkgs, ...}: {
      # Disable if you don't want unfree packages
      nixpkgs.config.allowUnfree = true;
      programs = {
        # firefox.enable = true;

        # fish.enable = true;
        # Enable Nix-ld for dynamic linking (running elf binaries)
        nix-ld.enable = true;
        # steam.enable = true;
        # to use gamemode with steam edit launch options inside
        # game -> general -> launch options -> `gamemoderun %command%`
        # gamemode.enable = true;

        # virtualisation
        # virt-manager.enable = true;
        # adb.enable = true;
      };
    };
    default = {
      includes = [<apps/cli>];
    };
    cli = {
      nixos = {pkgs, ...}: {
        programs = {
          nh.enable = true;
        };
        environment.systemPackages = with pkgs; [
          home-manager

          # CLI tools # TODO: look into disabled options
          # android-tools
          bat # imported though programs
          btop
          # bottom # task manager
          curl
          delta # fancy diffs
          dust
          fd # better find
          file
          fzf
          git # imported through programs
          # k3s
          lazygit
          # miniserve
          procs # ps
          ripgrep # better grep
          # rsync
          # sd
          # tokei
          tldr
          unzip
          webwormhole
          wget
          # yt-dlp

          # networking
          dnsutils # dig
          iputils # ping
          # nettools

          # archives
          gnutar
          p7zip
          unzip
          # xz
          zip

          # system
          # lsof
          # ltrace
          pciutils # lspci
          # strace
          # sysstat
          usbutils # lsusb
          brightnessctl
          wl-clipboard
          # pass
        ];

        nixpkgs = {
          # You can add overlays here
          overlays = [
            # If you want to use overlays exported from other flakes:
            # neovim-nightly-overlay.overlays.default

            # Or define it inline, for example:
            # (final: prev: {
            #   hi = final.hello.overrideAttrs (oldAttrs: {
            #     patches = [ ./change-hello-to-hi.patch ];
            #   });
            # })
          ];
        };
      };
    };
    gui = {
      nixos = {pkgs, ...}: {
        programs.firefox.enable = true;
        environment.systemPackages = with pkgs; [
          # GUI
          libreoffice
          zed-editor
          # protonvpn-gui
          # qbittorrent
          # gimp
          # godot

          # Gaming
          # lutris
          # heroic
        ];
      };
      includes = [
        # <discord>
        # <ghostty>
      ];
    };

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };
  };
}
