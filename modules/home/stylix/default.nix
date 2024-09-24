{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: {
  options.modules.stylix.enable = lib.mkEnableOption "";

  config = lib.mkIf config.modules.stylix.enable {
    stylix = {
      enable = true;
      autoEnable = false;
      image = /home/alex/.config/wallpaper/wallpaper.png;
      polarity = "dark";

      fonts = {
        monospace = {
          package = pkgs.agave;
          name = "Agave";
        };
        sansSerif = config.stylix.fonts.monospace;
        serif = config.stylix.fonts.monospace;
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
      };

      cursor = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
        size = 24;
      };
    };
  };
}
