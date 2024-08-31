{ config, pkgs, ... }:


{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];



  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Jerusalem";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IL";

  # i18n.extraLocaleSettings = {
  #   LC_ADDRESS = "en_IL.UTF-8";
  #   LC_IDENTIFICATION = "en_IL.UTF-8";
  #   LC_MEASUREMENT = "en_IL.UTF-8";
  #   LC_MONETARY = "en_IL.UTF-8";
  #   LC_NAME = "en_IL.UTF-8";
  #   LC_NUMERIC = "en_IL.UTF-8";
  #   LC_PAPER = "en_IL.UTF-8";
  #   LC_TELEPHONE = "en_IL.UTF-8";
  #   LC_TIME = "en_IL.UTF-8";
  # };

  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.cinnamon.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.keyd = {
    enable = true;
    keyboards = {
      "default" = {
        settings = {
          main = {
            capslock = "overload(control, esc)";
            "`" = "exec(kitty --single-instance)";
          };
        };
      };
    };
  };

  users.users.yarden = {
    isNormalUser = true;
    description = "Yarden Zamir";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "yarden";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
      google-chrome
      github-desktop
      vscode
      neovim
      xdg-utils # for keyring
      pass
      fd
      kitty
      wget
      vlc
      git
      nixd
      nil
      steam-run
      cosmic-term
  ];
  # List services that you want to enable:

  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?


}
