{config,pkgs,...}:
let
  domain = "home.somech.lab";
in { 
  services.dashy = {
    enable = true;   
    package = pkgs.dashy;
  };

  services.caddy.virtualHosts.${domain} = {
    extraConfig = ''
      reverse_proxy http://localhost:8080
    '';
  };
}
