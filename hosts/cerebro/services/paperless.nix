{config,pkgs,...}:
let
  domain = "docs.somech.lab";
in {

  sops.secrets.paperless_pass = {};
  
  services.paperless = {
    enable = true;
    passwordFile = config.sops.secrets.paperless_pass.path;
  };

  services.caddy.virtualHosts.${domain} = {
    extraConfig = ''
      reverse_proxy http://localhost:28981
    '';
  };
}
