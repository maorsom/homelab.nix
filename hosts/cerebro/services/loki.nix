{config,lib,pkgs,...}: 
let
  domain = "loki.somech.lab";
in {

    services.loki = {
      enable = true;
      configFile = ./loki-config.yaml;
    };

  services.caddy.virtualHosts.${domain} = {
    extraConfig = ''
      tls internal
      reverse_proxy http://localhost:3030
    '';
  };

}
