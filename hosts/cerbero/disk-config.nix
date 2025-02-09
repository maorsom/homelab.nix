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
              pool = "zpool";
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
              pool = "zpool";
            };
          };
        };
      };
    };

    # 🔥 ZFS Pool Configuration (RAID-1 Mirror)
    zpool.zpool = {
      type = "zpool";

      mode = "mirror"; # RAID-1 for redundancy
      options = {
        ashift = "12"; # Optimized for 4K sector drives
        autotrim = "on"; # Automatic SSD/HDD trim
        compression = "lz4"; # Lightweight compression
        atime = "off"; # Disable access time updates for performance
      };
      rootFsOptions = {
        compression = "lz4";
        xattr = "sa";
        acltype = "posixacl"; # ACL support
        relatime = "on"; # Reduce metadata writes
      };
      mountpoint = "/";
      postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot@blank$' || zfs snapshot zroot@blank";
      datasets = {
        "services" = {
          type = "zfs_fs";
          mountpoint = "/mnt/services"; # Store application data
          options = {
            compression = "lz4";
          };
        };
        "databases" = {
          type = "zfs_fs";
          mountpoint = "/mnt/databases"; # Store PostgreSQL, MongoDB
          options = {
            compression = "zstd";
            dedup = "off";
            recordsize = "16K";
            "com.sun:auto-snapshot" = "true";
          };
        };
        "logs" = {
          type = "zfs_fs";
          mountpoint = "/mnt/logs"; # Store logs for Loki, Prometheus
          options = {
            compression = "lz4";
            recordsize = "16k";
          };
        };
      };
    };
  };
}
