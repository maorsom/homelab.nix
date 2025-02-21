{
  inputs,
  config,
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

}
