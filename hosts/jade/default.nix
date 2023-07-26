{ config, pkgs, inputs, ... }: {
  # Imports
  imports = [

    # Common
    ../common
    ../common/overlays

    # Hardware Configuration
    ./hardware-configuration.nix

    # Software Configuration
    ./configs/polybar
    ./configs/i3
    ./configs/alacritty
    ./configs/dunst
    ./configs/picom

    # Modules
    ../../modules

  ];

  modules = {
    boot = {
      loader.systemd-boot.enable = true;
    };
    desktop = {
      gdm.enable = true;
      gdm.autologin.enable = false;
      i3.enable = true;
    };
    system = {
      udev.via.enable = true;
      kernelConfig.desktop.enable = true;
    };
    network = {
      networkmanager.enable = true;
      networkmanager.firewall.enable = false;
    };
    audio = {
      pipewire.enable = true;
    };
    video = {
      nvidia.enable = true;
    };
    gaming = {
      steam.enable = true;
    };
    misc = {
      colemak.enable = true;
      fonts.enable = true;
      keyring.enable = true;
      mouseaccel.enable = true;
      zram.enable = true;
      tlp.enable = false;
    };
  };

  # Hostname
  networking.hostName = "jade";

  # Users
  users.users.alex = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Home Manager
  home-manager.users.alex = {

    # State Version (HM)
    home.stateVersion = "23.05";
    
    # Packages
    home.packages = with pkgs; [

      # General
      firefox
      obs-studio
      vlc
      webcord-vencord

      # Programming
      vscodium

      # Gaming
      osu-lazer-bin
      jdk8
      prismlauncher
      lunar-client
      lutris
      protonup-qt

      # Environment
      polybarFull
      dmenu
      dunst
      scrot
      feh
      pavucontrol
      alacritty
      gnome.nautilus
      neofetch
      redshift
      easyeffects
      
    ];

    # Text Editor
    programs.neovim = {
      enable = true;
      vimAlias = true;
      plugins = with pkgs.vimPlugins; [
        vim-nix
      ];
    };

    # Picom
    services.picom.enable = true;
    
    # Direnv
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # Bash
    programs.bash.enable = true;
    
    # Automount
    services.udiskie = {
      enable = true;
      notify = true;
    };

    # Git Version Control
    programs.git = {
      enable = true;
      userName = "alexvasilkovski";
      userEmail = "alexvasilkovski@outlook.com";
    };
  };
}
