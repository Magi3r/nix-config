{den, ...}: {
  den.aspects.bitwarden-desktop = {
    host,
    user,
    ...
  }: {
    nixos = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        bitwarden-desktop
      ];
    };
    homeManager = {config, ...}: {
      home.sessionVariables = {
        SSH_AUTH_SOCK = config.home.homeDirectory + "/.bitwarden-ssh-agent.sock";
      };
    };
  };
}
