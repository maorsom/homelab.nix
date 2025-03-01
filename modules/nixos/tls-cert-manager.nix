{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.tls-cert-manager;
in
{

  options = {
    services.tls-cert-manager = {
      enable = mkEnableOption "Enable automatic TLS certificate generation and renewal";

      domain = mkOption {
        type = types.str;
        description = "The domain name for which the certificate will be issued.";
      };

      certPath = mkOption {
        type = types.str;
        default = "/var/lib/tls/${cfg.domain}/server.crt";
        description = "Path where the generated TLS certificate will be stored.";
      };

      keyPath = mkOption {
        type = types.str;
        default = "/var/lib/tls/${cfg.domain}/server.key";
        description = "Path where the generated TLS private key will be stored.";
      };

      caPath = mkOption {
        type = types.str;
        default = "/var/lib/tls/${cfg.domain}/root.crt";
        description = "Path where the CA certificate will be stored.";
      };

      acmeUseCertbot = mkOption {
        type = types.bool;
        default = false;
        description = "Use Certbot (ACME) instead of Step-CA if applicable.";
      };


      stepCAUrl = mkOption {
        type = types.str;

        default = "https://ca-server.local:9000";

        description = "The URL of the Step-CA server.";
      };

      acmeServer = mkOption {
        type = types.str;
        default = "https://ca-server.local:9000/acme/acme-provisioner/directory";
        description = "ACME directory URL for Certbot if using ACME.";

      };

      renewCommand = mkOption {
        type = types.str;

        description = "Command to run after certificate renewal (e.g., restart a service).";
      };

    };
  };

  config = mkIf cfg.enable {
    system.activationScripts.generateTLSCert = ''
      mkdir -p /var/lib/tls/${cfg.domain}

      if [ ! -f ${cfg.certPath} ]; then

        echo "Generating TLS certificates for ${cfg.domain}..."
        ${
          if cfg.acmeUseCertbot then
            ''
              certbot certonly --standalone \
                --server "${cfg.acmeServer}" \
                -d "${cfg.domain}" \
                --agree-tos --no-eff-email --email admin@${cfg.domain}
              cp /etc/letsencrypt/live/${cfg.domain}/fullchain.pem ${cfg.certPath}

              cp /etc/letsencrypt/live/${cfg.domain}/privkey.pem ${cfg.keyPath}
            ''
          else
            ''
              step ca certificate "${cfg.domain}" \
                ${cfg.certPath} ${cfg.keyPath} \
                --ca-url "${cfg.stepCAUrl}" \
                --provisioner "admin"
              cp /var/lib/step-ca/root_ca.crt ${cfg.caPath}
            ''

        }
        chmod 600 ${cfg.keyPath}
        chown root:root ${cfg.certPath} ${cfg.keyPath} ${cfg.caPath}

      fi
    '';


    systemd.services."tls-cert-renew-${cfg.domain}" = {

      description = "Auto-renew TLS certificate for ${cfg.domain}";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";

        ExecStart = "/bin/sh -c '${
          if cfg.acmeUseCertbot then
            ''
              certbot renew --deploy-hook "${cfg.renewCommand}"
            ''
          else
            ''

              step ca renew --daemon --exec "${cfg.renewCommand}" ${cfg.certPath} ${cfg.keyPath}
            ''
        }'";
        Restart = "always";
        User = "root";

      };
    };
  };
}
