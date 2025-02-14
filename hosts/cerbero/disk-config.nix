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
              type = "btrfs";
              extraArgs = [ "-f"];
              mountpoint = "/";
              mountOptions = ["compress=zstd" "noatime"];
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
          "primary" = {
            size = "100%";
            content = {
              type = "brtfs";
              mountpoint = "/mnt/storage";
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
          "primary" = {
            size = "100%";
            content = {
              type = "brtfs";
              mountpoint = "/mnt/storage";
            };
          };
        };
      };
    };

    raid.storage = {
      type = "brtfs-raid";
      level = "raid0";
      devices = ["/dev/sdb" "/dev/sdc"];
      content = {
        type = "brtfs";
        subvolumes = {
          "@data" = {
            mountpoint = "/mnt/storage/data";
            mountOptions = ["noatime" "compress=zstd"];
          };
          "@databases" = {
            mountpoint = "/mnt/storage/databases";
            mountOptions = ["noatime" "compress=lzo" "nodatacow"];
          };
          "@backups" = {
            mountpoint = "/mnt/storage/backups";
            mountOptions = ["noatime" "compress=zstd"];
          };
          "@logs" = {
            mountpoint = "/mnt/storage/logs";
            mountOptions = ["noatime"];
          };
          "@containers" = {
            mountpoint = "/mnt/storage/containers";
            mountOptions = ["noatime" "compress=zstd"];
          };
          "@snapshots" = {
            mountpoint = "/mnt/storage/snapshots";
            mountOptions = ["noatime" "compress=zstd"];
          };
        };
      };
    };
  };
}
