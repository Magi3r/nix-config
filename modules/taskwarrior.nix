{
  den.aspects.taskwarrior = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        taskwarrior3
      ];
    };
    homeManager = {
      pkgs,
      user,
      ...
    }: {
      home.sessionVariables = {
        TASKRC = "$HOME/.config/task/taskrc";
      };

      sops.secrets.taskwarrior = {
        path = "/home/${user.name}/.config/task/secrets";
      };

      home.file.".config/task/taskrc".text = ''
        sync.server.url=https://tasks.magi3r.de
        sync.server.client_id=837b8561-b29a-41a4-a9cf-fe69d2ea9619
        include ~/.config/task/secrets
        data.location=~/.local/share/task
        hooks.location=~/.config/task/hooks
      '';

      home.packages = with pkgs; [
        taskwarrior-tui
      ];
    };
  };
}
