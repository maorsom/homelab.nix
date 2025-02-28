{config,pkgs,...}: {
  services.grafana = {
    enable = true;
    domain = "grafana.somech.local";
    port = 2342;
    addr = "0.0.0.0";
  };

  services.caddy.virtualHosts.${config.services.grafana.domain} = {
    extraConfig = ''
      reverse_proxy http://localhost:2342
    '';
  };
}
