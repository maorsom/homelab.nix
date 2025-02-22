{ config, lib, pkgs, ...}: {
  
  virtualisation.oci-containers = {
    backend = "podman"; # Use Podman for containers
    containers = {
      mongodb = {
        image = "docker.io/mongo:latest";
        autoStart = true;
        ports = [ "27017:27017" ];
        environment = {
          MONGO_INITDB_ROOT_USERNAME = "admin";
          MONGO_INITDB_ROOT_PASSWORD = "secret";
        };
        volumes = [
          "/databases/mongodb:/data/db" # Persistent storage
        ];
      };
    };
  };

}
