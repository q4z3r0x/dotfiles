{
  lib,
  config,
  pkgs,
  ...
}: {
  options.modules.theme.enable = lib.mkEnableOption "";

  config = lib.mkIf config.modules.theme.enable {
    
    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 16;
    };
  

    gtk = {
      enable = true;
      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
      theme = {
        name = "Adwaita";
        package = pkgs.gnome-themes-extra;
      };
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };

    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "adwaita";
      style.name = "adwaita-dark";
    };

    fonts.fontconfig = {
      enable = true;
      defaultFonts.monospace = [
        "Agave"
      ];
    };

    home.packages = with pkgs; [
      atkinson-hyperlegible
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      agave
      terminus_font
      departure-mono

      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      nerd-fonts.iosevka
      nerd-fonts.liberation
    ];
  };
}
