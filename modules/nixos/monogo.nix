{config,pkgs,lib, ...}:

{

  services.mongodb.enable = true;

  services.mongodb.packge = pkgs.mongodb-ce;

  services.mongodb.enableAuth = true;
  services.mongodb.initialRootPassword = "Oran1Ofir2!";
}
