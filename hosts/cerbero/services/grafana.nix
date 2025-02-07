{config,pkgs,...}: {
  services.grafana = {
    enable = true;
    domain = "grafana.somech.local";
    port = 2342;
    addr = "127.0.0.1";
  };

  services.nginx.virtualHosts.${config.services.grafana.domain} = {
    locations."/" = {
      proxPass = "https://127.0.0.1:${toString config.services.grafana.port}";
      porxyWebsockets = true;
    };
  };
}
