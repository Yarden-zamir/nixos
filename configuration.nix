{ config, pkgs, ... }:


{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];


  systemd.user.services.atuind = {
    enable = true;

    environment = {
      ATUIN_LOG = "info";
    };
    serviceConfig = {
      ExecStart = "${pkgs.atuin}/bin/atuin daemon";
    };
    after = [ "network.target" ];
    wantedBy = [ "default.target" ];
  };

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


  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
  hardware.nvidia.open = false;
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
  # services.keyd = {
  #   enable = true;
  #   keyboards = {
  #     "default" = {
  #       settings = {
  #         main = {
  #           capslock = "overload(control, esc)";
  #           "`" = "exec(kitty --single-instance)";
  #         };
  #       };
  #     };
  #   };
  # };
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  users.users.yarden = {
    isNormalUser = true;
    description = "Yarden Zamir";
    extraGroups = [ "networkmanager" "wheel" ];
    useDefaultShell = true;
    # ignoreShellProgramCheck = true;

    # packages = with pkgs; [];
  };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.yarden = { pkgs, ... }: {
      home.packages = [ pkgs.atool pkgs.httpie ];
      programs = {
        atuin =  {
          enable = true;
        };
        zsh ={
          enable = true;
          enableCompletion = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;
          initExtra = "source ~/.p10k.zsh";
    plugins = [
      {
        # A prompt will appear the first time to configure it properly
        # make sure to select MesloLGS NF as the font in Konsole
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
            {
              name = "powerlevel10k-config";
              src = ./p10k;
              file = "p10k.zsh";
            }
            {
              name = "fzf-tab";
              src = pkgs.fetchFromGitHub {
                owner = "Aloxaf";
                repo = "fzf-tab";
                rev = "c2b4aa5ad2532cca91f23908ac7f00efb7ff09c9";
                sha256 = "1b4pksrc573aklk71dn2zikiymsvq19bgvamrdffpf7azpq6kxl2";
              };
            }
          ];
      };};

      # The state version is required and should stay at the version you
      # originally installed.
      home.stateVersion = "24.11";
    };
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
    zsh-powerlevel10k
    meslo-lgs-nf
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
