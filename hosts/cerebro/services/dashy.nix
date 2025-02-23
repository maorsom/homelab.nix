{config,pkgs,...}:
let
  domain = "home.somech.lab";
in { 
  services.dashy = {
    enable = true;   
    package = pkgs.dashy-ui;
  };

  services.caddy.virtualHosts.${domain} = {
    extraConfig = ''
      tls internal
      reverse_proxy http://localhost:8080
    '';
  };
}
