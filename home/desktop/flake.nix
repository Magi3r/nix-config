{
  description = "Home Manager configuration of wubbaboo";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    yazi-flavors = {
      url = "github:yazi-rs/flavors";
      flake = false;
    };
    yazi-compress = {
      url = "github:KKV9/compress.yazi";
      flake = false;
    };

    zjstatus = { url = "github:dj95/zjstatus"; };
  };

  outputs = { nixpkgs, home-manager, catppuccin, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."wubbaboo" =
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [
            ./home.nix
            ./cosmic
            ./git
            ./gemini
            ./gtk
            ./helix
            ./inlyne
            ./kitty
            ./rofi
            ./shell
            ./starship
            ./yazi
            ./zellij
            catppuccin.homeModules.catppuccin
          ];

          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
          extraSpecialArgs = { inherit inputs; };
        };
    };
}
