{
  den.aspects.fonts = {
    nixos = { pkgs, ... }:{
      fonts.packages = with pkgs; [
        nerd-fonts.noto
        nerd-fonts.jetbrains-mono
      ];
      # fonts.fontconfig.enable = true;
      # fonts.fontconfig.defaultFonts.monospace = [ "JetBrainsMono Nerd Font" ];
    };
  };
}
