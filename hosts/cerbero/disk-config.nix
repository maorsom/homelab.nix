{
  disko.devices = {
    disk.ssd = {
      device = "/dev/sda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "512M";
            type = "EF00";
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

    # 🔵 HDDs for Btrfs RAID 0
    disk.hdd1 = {
      device = "/dev/sdb";
      type = "disk";
      content = {
        type = "gpt";
        partitions.primary = {
          size = "100%";
          content = {
            type = "btrfs";
            raid = "0";  # Define RAID 0 here
            devices = ["/dev/sdb" "/dev/sdc"];  # Both drives in RAID 0
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
    };

    # Second HDD refers to the same RAID
    disk.hdd2 = {
      device = "/dev/sdc";
      type = "disk";
      content = {
        type = "gpt";
        partitions.primary = {
          size = "100%";
          content = "sameAs" "disk.hdd1";  # Uses the same RAID 0 setup

        };
      };
    };
  };
}
