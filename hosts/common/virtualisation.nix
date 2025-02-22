{config, pkgs, ...}: {
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  users.users.myuser = {
    isNormalUser = true;
    extraGroups = [ "podman" ];
  };
}
