{
  lib,
  config,
  ...
}: let
  aliases = {
    "check" = ''nix-shell -p alejandra -p deadnix -p statix --command "alejandra -q **/* && deadnix -e && statix fix"'';
    "nrebuild" = "sudo nixos-rebuild switch --flake github:qazer2687/dotfiles#$(hostname) --refresh --option eval-cache false";
    "debuild" = "darwin-rebuild switch --flake github:qazer2687/dotfiles#$(hostname) --refresh --option eval-cache false";
    "ls" = "eza --colour=always --icons=always --all";
  };
in {
  options.modules.fish.enable = lib.mkEnableOption "";

  config = lib.mkIf config.modules.fish.enable {
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
      '';
      shellAliases = aliases;
    };

    programs.eza.enable = true;
  };
}
