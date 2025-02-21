{
  inputs,
  config,
  lib,
  ...
}: let
  prometheus_ip = "10.0.0.103";
in {
    services.prometheus.exporters.node = {
    enable = true;
    port = 9100;
  };

  networking.firewall.extraCommands = ''
    iptables -A INPUT -p tcp --dport 9100 -s ${prometheus_ip} -j ACCEPT
    iptables -A INPUT -p tcp --dport 9100 -j DROP
  '';

    services.prometheus.extraScrapeConfigs = lib.mkBefore [
    {
      job_name = "node_exporter";
      scrape_interval = "15s";
      static_configs = [
        { targets = [ "localhost:9100" ]; }
      ];
    }
  ];

}
