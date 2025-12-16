{ pkgs, ... }: {
  # Disable if you don't want unfree packages
  nixpkgs.config.allowUnfree = true;

  programs = {
    firefox.enable = true;

    fish.enable = true;
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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.

    home-manager

    # CLI tools # TODO: look into disabled options
    # android-tools
    bat
    # bottom
    curl
    # delta
    dust
    # fd
    # file
    # fzf
    git
    # k3s
    # lazygit
    # miniserve
    # procs
    # ripgrep
    # rsync
    # sd
    # tokei
    unzip
    wget
    yt-dlp

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
    # wl-clipboard
    # pass

    # GUI
    # libreoffice
    # protonvpn-gui
    # qbittorrent
    gimp
    # godot

    # Gaming
    # lutris
    # heroic
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


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };


}
