{config,pkgs,...}: {
  services.grafana = {
    enable = true;
    domain = "grafana.somech.local";
    port = 2342;
    addr = "127.0.0.1";
  };

  services.nginx.virtualHosts.${config.services.grafana.domain} = {
    default = true;
    locations."/" = {
      proxyPass = "https://127.0.0.1:${toString config.services.grafana.port}";
    };
  };
}
