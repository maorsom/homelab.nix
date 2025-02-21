{config,lib,pkgs,...}: 
let
  domain = "loki.somech.lab";
in {

  services.loki = {

    enable = true;
    configFile = ./loki-local-config.yaml;
  };

  systemd.services.promtail = {
    description = "Promtail service for Loki";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = ''
        ${pkgs.grafana-loki}/bin/promtail --config.file ${./promtail.yaml}
      '';
    };
  };

  services.caddy.virtualHosts.${domain} = {
    extraConfig = ''
      tls internal
      reverse_proxy http://localhost:9090
    '';
  };

}
