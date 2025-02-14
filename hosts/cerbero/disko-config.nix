{
  disko.devices = {
    # 🟢 SSD for NixOS System
    disk.ssd = {
      device = "/dev/sda"; # Adjust based on your actual SSD
      type = "disk";

      content = {
        type = "gpt";
        partitions = {
          ESP = {
	    priority = 1;
	    name = "ESP";
	    start = "1M";
            end = "512M";
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
              subvolumes = {
		"/rootfs" = {
			mountpoint = "/";
		};
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = ["noatime" "compress=zstd"];
                };
		"/swap" = {
			mountpoint = "/.swapvol";
			swap = {
				swapfile.size = "8G";
			};
		};
              };
            };
          };
        };
      };
    };

    # 🔵 RAID 0 (Striping) or RAID 1 (Mirroring) for HDDs
    disk.hdd = {
      device = "/dev/sdb";  # First HDD
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          primary = {
            size = "100%";
            content = {
              type = "btrfs";
	      extraArgs = [
		"-d raid0"
		"/dev/sdc"
		"-f"
	      ];
              subvolumes = {
                "@data" = {
                  mountpoint = "/data";
                  mountOptions = ["noatime" "compress=zstd"];
                };
                "@databases" = {
                  mountpoint = "/databases";
                  mountOptions = ["noatime" "compress=lzo" "nodatacow"];
                };
                "@backups" = {
                  mountpoint = "/backups";
                  mountOptions = ["noatime" "compress=zstd"];
                };
                "@logs" = {
                  mountpoint = "/logs";
                  mountOptions = ["noatime"];
                };

                "@containers" = {
                  mountpoint = "/containers";
                  mountOptions = ["noatime" "compress=zstd"];
                };

                "@snapshots" = {
                  mountpoint = "/snapshots";
                  mountOptions = ["noatime" "compress=zstd"];
                };

              };
            };
          };
        };
      };
    };
  };
}
