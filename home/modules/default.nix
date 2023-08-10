{...}: {
  imports = [
    # Programs
    ./programs/bash
    ./programs/direnv
    ./programs/git
    ./programs/neovim
    ./programs/alacritty
    ./programs/dunst
    ./programs/i3
    ./programs/polybar
    ./programs/spicetify
    ./programs/firefox
    ./programs/discord
    ./programs/vscode

    # Services
    ./services/mpd
    ./services/udiskie
    ./services/spotifyd
  ];
}
