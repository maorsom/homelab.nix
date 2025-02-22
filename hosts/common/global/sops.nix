{
  inputs,
  config,
  ...
}: let
in {
  imports = [inputs.sops-nix.nixosModules.sops];

  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/sysadmin/sops/age/keys.txt";
  };
}
