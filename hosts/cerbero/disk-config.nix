{
  disko.devices = {
    # 🟢 SSD for NixOS System
    disk.ssd = {
      device = "/dev/sda"; # Adjust based on your actual SSD
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "512M";
            type = "EF00"; # EFI Partition for UEFI booting
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };

    # 🔵 HDDs for ZFS Storage (RAID-1 Mirror)
    disk.hdd1 = {
      device = "/dev/sdb";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          "zfs" = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "zroot";
            };
          };
        };

      };
    };

    disk.hdd2 = {
      device = "/dev/sdc";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          "zfs" = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "zroot";
            };
          };
        };
      };
    };

    # 🔥 ZFS Pool Configuration (RAID-1 Mirror)
    zpool.zroot = {
      type = "zpool";

      mode = "mirror"; # RAID-1 for redundancy
      options.cachefile = "none";
      rootFsOptions = {
        compression = "lz4";
        "com.sun:auto-snapshot" = "true";
      };
      datasets = {
        services = {
          type = "zfs_fs";
          mountpoint = "/services"; # Store application data
        };
        databases = {
          type = "zfs_fs";
          mountpoint = "/databases"; # Store PostgreSQL, MongoDB
        };
        logs = {
          type = "zfs_fs";
          mountpoint = "/logs"; # Store logs for Loki, Prometheus
        };
      };
    };
  };
}
