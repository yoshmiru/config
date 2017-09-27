# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    kernelModules = [ "snd-aloop" "snd-seq" "snd-rawmidi" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "localhost"; # Define your hostname.
#    extraHosts = "192.168.179.100 mym.mywire.org";
#    wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networkmanager.enable = true; # Automaticaly enabled by gnome.
    firewall.enable = false;
#    nat = {
#      enable = true;
#    internalInterfaces = [ "br-e2eb2ef68e39" ];
#    };
  };

# Select internationalisation properties.
    i18n = {
#   consoleFont = "Lat2-Terminus16";
      consoleKeyMap = "us";
      defaultLocale = "en_US.UTF-8";
      inputMethod = {
        enabled = "fcitx";
        fcitx.engines = with pkgs.fcitx-engines; [ mozc ];
      };
    };

# Set your time zone.
  time.timeZone = "Asia/Tokyo";

# List packages installed in system profile. To search by name, run:
# $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget
    nix-repl
    gitMinimal
#    dhcpcd
    #nfs-utils samba sshfsFuse
    #dmenu xscreensaver stalonetray #networkmanagerapplet
    #xfce.thunar xfce.tumbler xfce.gvfs gnome.gnome_icon_theme
    #gnome3.nautilus gnome3.gvfs
    #i3status i3lock dmenu xss-lock
    jack2Full qjackctl
    wireshark
  ];

# List services that you want to enable:

# Enable CUPS to print documents.
  services = {
# Enable the OpenSSH daemon.
    openssh.enable = true;

# プリントサーバー
    printing = {
      enable = true;
      drivers = [ pkgs.gutenprint ];
    };

# Enable the X11 windowing system.
# Enable the KDE Desktop Environment.
    xserver = {
      enable = true;
      layout = "us";
#    xkbOptions = "eurosign:e";
#      displayManager.gdm.enable = true;
#      desktopManager.gnome3.enable = true;
#      windowManager.sawfish.enable = true;
#      synaptics = {
#        enable = true;
#        twoFingerScroll = true;
#        tapButtons = false;
#        additionalOptions = ''
#          Option "VertScrollDelta" "-111"
#          Option "HorizScrollDelta" "-111"
#          '';
#      };
      libinput = {
        enable = true;
        naturalScrolling = true;
      };
    };

    # Lidを閉じたらサスペンド
    logind.extraConfig = ''
      HandleLidSwitchDocked=suspend
      HandlePowerKey=suspend
      RuntimeDirectorySize=20%
      '';

    # 自動マウントファイルシステム
#    autofs = {
#      enable = true;
#      # timeout = 60;
#      debug = true;
#      autoMaster = let
#        mapConfSsh = pkgs.writeText "auto.sshfs"  ''
#        explop.com -fstype=fuse,allow_other :sshfs\#explop.com\:
#        '';
#        mapConf = pkgs.writeText "auto"  ''
#        workspace    -fstype=nfs4,rw 10.0.1.101:/home/sunny/workspace
#        '';
#      in ''
#        /auto file:${mapConf}
#        /auto/sshfs file:${mapConfSsh} uid=1000,gid=100,--timeout=30,--ghost
#        '';
#    };
    pcscd.enable = true;
  };


# for wireshark
  security.wrappers = {
    dumpcap = {
      source  = "${pkgs.wireshark.out}/bin/dumpcap";
      owner = "root";
      group = "wireshark";
      setuid = true;
      setgid = false;
      permissions = "u+rx,g+x";
    };
  };

# Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    extraUsers.miru = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = [ "wheel" "audio" "vboxusers" "docker" "wireshark" "dialout"];
    };

# for wireshark
    extraGroups.wireshark.gid = 500;
  };

# The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";

  virtualisation = {
    virtualbox.host.enable = true;
    docker.enable = true;
  };

#  services.nginx = {
#      enable = true;
#      appendHttpConfig = pkgs.lib.readFile /home/miru/.nginx/http.conf;
#      appendConfig = pkgs.lib.readFile /home/miru/.nginx/mail.conf;
#  };

#  services.httpd = {
#    adminAddr = "yos1127@gmail.com";
#    enable = true;
#    enablePHP = true;
#    phpPackage = pkgs.php56;
#    phpOptions = ''
#      display_errors = On
#      error_log = "syslog"
#    '';
#    enableUserDir = true;
#    port=81;
#    virtualHosts = [{
#      hostName = "localhost";
#     # documentRoot = "/var/www";
#      servedDirs = [{
#        urlPath = "/animal/service";
#        dir = "/var/www/service";
#      }];
#      port=81;
#    }];
#  };

#  services.mysql = {
#    enable = true;
#    package = pkgs.mysql;
#  };
#  services.postgresql = {
#    enable = true;
#    package = pkgs.postgresql;
#    authentication = "local all all ident";
#  };

  #powerManagement = {
  #  enable = true;
  #  powerDownCommands = "";
  #};

  nixpkgs.config = {
    allowUnfree = true;
    #packageOverrides = pkgs: {
    #  bluez = pkgs.bluez4;
    #};
    #virtualbox.enableExtensionPack = true;
  };
  hardware = {
    pulseaudio.enable = true;
    pulseaudio.package = pkgs.pulseaudioFull;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    #enableAllFirmware = true;
  };

#  fileSystems."/boot" =
#  { device = "/dev/sda2";
#    fsType = "vfat";
#    options = [ "defaults" ];
#  };
#  fileSystems."/mnt/windows" =
#  { device = "/dev/disk/by-label/windows";
#    fsType = "ntfs";
#    options = [ "noauto" "user" ];
#  };
#  fileSystems."/mnt/home" =
#  { device = "/dev/sda6";
#    fsType = "ext4";
#    options = [ "defaults" ];
#  };
  fileSystems."/mnt/HD-PNTU3" =
  { device = "/dev/disk/by-label/HD-PNTU3";
    fsType = "ntfs";
    options = [ "noauto" "user" ];
  };                                                                          

#  swapDevices = [{ device = "/dev/disk/by-uuid/72dd4271-d77c-420b-b6d9-34c249edbcc2";}];

  #services.acpid = {
  #  enable = true;
  #  powerEventCommands = "systemctl suspend";
  #};

#  services.strongswan = {
#    enable = true;
#    secrets = [ "/etc/ipsec.secret" ];
#    connections = {
#      hide-nl = {
#        keyexchange = "ike";
#        dpdaction = "clear";
#        dpddelay = "300s";
#        eap_identity = "yoshmiru";
#        leftauth = "eap-mschapv2";
#        left = "%defaultroute";
#        leftsourceip = "%config";
#        right = "free-sg.hide.me";
#        rightauth = "pubkey";
#        rightsubnet = "0.0.0.0/0";
#        rightid = "%any";
#        type = "tunnel";
#        auto = "add";
#      };
#    };
#  };

}
