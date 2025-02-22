{ config, lib, pkgs, ...}: {

  services.mongodb = {
    enable = true;
    package = pkgs.mongodb-ce;
    enableAuth = true;
    initialRootPassword = "A1B2345";
    dbpath = "/databases/mongodb";
    bind_ip = "0.0.0.0";
  };

}
