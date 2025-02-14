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
              extraArgs = [ "-f" ];
              mountpoint = "/";
              mountOptions = ["compress=zstd" "noatime"];
              subvolumes = {
                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = ["noatime" "compress=zstd"];
                };
              };
            };
          };
        };
      };
    };

    # 🔵 RAID 0 (Striping) or RAID 1 (Mirroring) for HDDs
    disk.hdd1 = {
      device = "/dev/sdb";  # First HDD
      type = "disk";
      content = {

        type = "gpt";
        partitions = {
          primary = {
            size = "100%";
            content = {

              type = "btrfs";
              raid = "0";  # 🚀 Use "1" for RAID 1 (mirroring)

              devices = [ "/dev/sdb" "/dev/sdc" ];  # Two disks in RAID
              mountpoint = "/mnt/storage";  # Main mountpoint for the RAID

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

    };

    # 🔵 Second HDD, part of the RAID setup
    disk.hdd2 = {

      device = "/dev/sdc";  # Second HDD
      type = "disk";
      content = {

        type = "gpt";
        partitions = {
          primary = {
            size = "100%";
            content = "sameAs" "disk.hdd1";  # Uses the same RAID 0 setup
          };
        };
      };
    };

  };
}
