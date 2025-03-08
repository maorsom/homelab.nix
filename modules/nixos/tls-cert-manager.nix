{ config, lib, pkgs, ... }:

with lib;

let
  acmeHome = "/var/lib/acme";  # Centralized storage for acme.sh
  acmeBin = "${pkgs.acme-sh}/bin/acme.sh";  # Use the NixOS-installed acme.sh


in
{
  options = {
    services.acme-sh = {
      enable = mkEnableOption "Enable acme.sh for automatic TLS certificate management";
      user = mkOption {
        type = types.str;
        default = "step-ca";
        description = "User that runs acme.sh";
      };
    };
  };

  config = mkIf config.services.acme-sh.enable {
    services.cron.enable = true;
    services.cron.systemCronJobs = [
      "0 0 * * * ${config.services.acme-sh.user} ${acmeBin} --cron --home ${acmeHome}"
    ];
  };
}

