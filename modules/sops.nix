{
  den,
  inputs,
  ...
}: {
  flake-file.inputs = {
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.sops = {
    nixos = {
      imports = [inputs.sops-nix.nixosModules.sops];
      sops = {
        defaultSopsFile = inputs.self + "/secrets/secrets.yaml";
        age.keyFile = "/etc/sops/age/keys.txt";
        # useSystemdActivation = true;
      };
    };

    homeManager = {user}: {
      imports = [inputs.sops-nix.homeManagerModules.sops];
      sops = {
        defaultSopsFile = inputs.self + "/secrets/secrets.yaml";
        age.keyFile = "/home/${user.name}/.config/sops/age/keys.txt";
      };
      # programs.sops.enable = true;
    };
  };
}
