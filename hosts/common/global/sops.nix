{
  inputs,
  config,
  ...
}: let
in {
  imports = [inputs.sops-nix.nixosModules.sops];

  sops = {
    age.keyFile = "/home/sysadmin/sops/age/keys.txt";
  };
}
