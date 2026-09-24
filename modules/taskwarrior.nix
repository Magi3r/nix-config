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
      config,
      ...
    }: {
      home.sessionVariables = {
        TASKRC = "$HOME/.config/task/taskrc";
      };

      sops.secrets."taskwarrior/client_id" = {};
      sops.secrets."taskwarrior/encryption_secret" = {};
      sops.templates."task-secrets" = {
        path = "/home/${user.name}/.config/task/secrets";
        content = ''
          sync.server.client_id=${config.sops.placeholder."taskwarrior/client_id"}
          sync.encryption_secret=${config.sops.placeholder."taskwarrior/encryption_secret"}
        '';
      };

      home.file.".config/task/taskrc".text = ''
        sync.server.url=https://tasks.magi3r.de
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
