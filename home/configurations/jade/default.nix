{pkgs, ...}: {
  imports = [
    ../../modules
  ];

  homeModules = {
    programs = {
      bash.enable = true;
      direnv.enable = true;
      git.enable = true;
      discord.enable = true;
      neovim.enable = true;
      spicetify.enable = true;
      firefox.enable = true;
      vscode.desktopConfig.enable = true;
      alacritty.desktopConfig.enable = true;
      polybar.desktopConfig.enable = true;
      dunst.desktopConfig.enable = true;
      i3.desktopConfig.enable = true;
    };
    services = {
      spotifyd.enable = true;
    };
  };

  home.packages = with pkgs; [
    # General
    obs-studio
    vlc
    webcord-vencord

    # Programming
    vscodium
    alejandra
    deadnix
    statix

    # Gaming
    osu-lazer-bin
    prismlauncher
    lunar-client
    lutris
    protonup-qt

    # Environment
    dmenu
    scrot
    feh
    pavucontrol
    gnome.nautilus
    neofetch
    redshift
    easyeffects
  ];

  home.stateVersion = "23.05";
  home.homeDirectory = "/home/alex";
  sops.secrets.spotify_password.path = "/home/alex/.config/spotifyd/password";
  sops.defaultSopsFile = ../../../secrets/default.yaml;
  sops.age.sshKeyPaths = ["/home/alex/.ssh/id_ed25519"];
}
