{ config, pkgs, ... }:


{
  imports =
    [
      # Include the results of the hardware scan.
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

  services.xserver.enable = true;
  # services.xserver.desktopManager.pantheon.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.cinnamon.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
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
    shell = pkgs.zsh;
    # packages = with pkgs; [];
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
  programs.zsh = {
    enable = true;
    #   autosuggestions.enable = true;

    #   plugins = [
    #     { name = "zsh-users/zsh-autosuggestions"; } # Simple plugin installation
    #     { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; } # Installations with additional options. For the list of options, please refer to Zplug README.
    #   ];
  };
  environment.systemPackages = with pkgs; [
    zsh-powerlevel10k
    meslo-lgs-nf
    # zsh
    google-chrome
    github-desktop
    nixpkgs-fmt
    vscode
    neovim
    xdg-utils # for keyring
    pass
    fd
    kitty
    wget
    vlc
    # beep
    git
    nixd
    nil
    steam-run
    cosmic-term
    fzf
  ];

  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  networking.firewall.enable = false;


  system.stateVersion = "unstable";

}
