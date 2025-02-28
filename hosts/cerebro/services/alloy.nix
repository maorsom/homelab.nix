{ config, lib, pkgs, ...} :
let
  domain = "alloy.somech.lab";
in {
  services.alloy = {
    enable = true;
    configPath = ./alloy-config.alloy;
  };

}
