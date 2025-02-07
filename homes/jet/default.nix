{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/home
  ];

  home.packages = with pkgs; [
    obsidian # Note Taking
    nautilus # File Browser
    fragments # Torrent Client
    calibre # E-Book Library
    vlc # Media Player
    # Causes electron-unwrapped to build from source.
    # teams-for-linux # Team Communication
    loupe # Image Viewer

    arnis

    # Development
    sqlitebrowser # SQLite Database Browser
  ];

  # Enable rich presence support for Discord on the web.
  # services.arrpc.enable = true;

  modules = {
    # Environment
    # sway.enable = true;
    hyprland.enable = true;
    #niri.enable = true;

    waybar.enable = true;
    foot.enable = true;
    mako.enable = true;
    wofi.enable = true;
    theme.enable = true;

    ags.enable = true;

    # Programs
    firefox.enable = true;
    fish.enable = true;
    webcam.enable = true;
    bat.enable = true;
    eza.enable = true;
    vscode.enable = true;
    git.enable = true;
    direnv.enable = true;
    # neovim.enable = true;

    # Security
    # gpg.enable = true;

    # Gaming
    prismlauncher.enable = true;
    mangohud.enable = true;
  };

  home.stateVersion = "24.11";
  home.homeDirectory = lib.mkForce "/home/alex";

  sops.defaultSopsFile = ../../../secrets/default.yaml;
  sops.age.sshKeyPaths = ["/home/alex/.ssh/id_ed25519"];
}
