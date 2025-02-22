# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Allowing non-Free/Libre packages
  nixpkgs.config.allowUnfree = true;

  # Boot Kernel Packages
  #boot.kernelPackages = pkgs.linuxPackages_latest;

  # Boot Kernel Modules
  #boot.kernelModules = [ "nvidia_uvm" "nvidia_modeset" "nvidia_drm" "nvidia" "wacom" ];

  # Specify Kernel Modules in the initial RAM disk
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "nvme" "sd_mod" "sr_mod" ];

  # Additional kernel parameters
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];

  # Filesystems supported by the bootloader
  boot.supportedFilesystems = [ "ext4" "vfat" "ntfs" "exfat" ];

  # Reduce swap utilization and prioritize physical memory
  boot.kernel.sysctl."vm.swappiness" = 10;

  # Intel CPU Microcode update
  hardware.cpu.intel.updateMicrocode = true;


  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  # Enable 32 Bit OpenGL DRI Support
    enable32Bit = true;
  };


  # Enable Blutooth
  hardware.bluetooth.enable = true;

  # Load nvidia driver for Xorg and Wayland
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    wacom.enable = true;

  # Enable the GNOME Desktop Environment.
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  
  };

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    #package = pkgs.linuxPackages_latest.nvidiaPackages.stable;
  }; 

# Enable Nvidia/OpenGL

  #hardware.graphics= {
  #  enable = true;
  #  enable32Bit = true;
  #};

  #services.xserver.videoDrivers = ["nvidia"];
  #hardware.nvidia.modesetting.enable = true;
  #hardware.nvidia.open = false;
  #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.latest;
  #services.nvidia-persistenced.enable = true;




  # Use the GRUB 2 boot loader.
  boot.loader.grub = {
    enable = true;
    device = "/dev/nvme1n1";
  };
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "vix"; # Define your hostname.
  # Pick only one of the below networking options.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Riyadh";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };


  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
#  hardware.pulseaudio.enable = true;
  # OR
   services.pipewire = {
     enable = true;
     alsa.enable = true;
     alsa.support32Bit = true;
     pulse.enable = true;
     jack.enable = true;
   };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.f423 = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.bash;
    packages = with pkgs; [
      tree
      vim
   #   rustup
      python3
   #   nmap
   #   wireshark
   #  john
    #  hashcat
     # metasploit
     # sqlmap
     # burpsuite
     # ettercap
     # hydra
     # aircrack-ng
     # brave
     # lutris
     # mangohud
      wget
     # protonup
      git
      htop
      neofetch
      #nvidia-settings
     # alacritty
     # nitrokey-app
    ];
  };


  # steam

   # programs.steam.enable = true;
    #programs.steam.gamescopeSession.enable = true;
    #programs.gamemode.enable = true;

   # environment.sessionVariables = {
    #  STEAM_EXTRA_COMPAT_TOOLS_PATHS =
   #     "/home/user/.steam/rootcompatibilitytools.d";
   # };


  # System Packages
  # List packages installed in system profile. To search, run:
  #$ nix search wget
  environment.systemPackages = with pkgs; [
    vim
   # mangohud
    wget
  # protonup
    git
    htop
    neofetch
    #nvidia-settings
    #nitrokey-app
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Ollama
  #services.ollama = {
   # enable = true;
   # acceleration = "cuda";
  #};

  # Clam AV
  #services.clamav.daemon.enable = true;

  # NitroKey
#  services.udev.packages = [ pkgs.nitrokey-udev-rules ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}


