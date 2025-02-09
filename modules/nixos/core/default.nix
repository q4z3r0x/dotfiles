{
  lib,
  config,
  inputs,
  self,
  pkgs,
  ...
}: {
  options.modules.core.enable = lib.mkEnableOption "";

  # This module is a replacement to having a shared
  # folder in the hosts directory.
  #
  # All options defined in this module are meant to be
  # enabled on all hosts.
  #
  # All settings defined here can be overridden using
  # lib.mkForce in the configuration files for specific hosts.

  config = lib.mkIf config.modules.core.enable {
    ########## NIX ##########

    nix = let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        flake-registry = "";
        # https://github.com/NixOS/nix/issues/9574
        nix-path = config.nix.nixPath;
        keep-derivations = true;
        keep-outputs = true;
        auto-optimise-store = true;
        sandbox = true;
        # Required for remote builds.
        require-sigs = false;
      };
      channel.enable = false;
      registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };

    ########## NIXPKGS ##########

    nixpkgs = {
      config = {
        # Permit the install of packages
        # that have unfree licences.
        allowUnfree = true;
      };
      overlays = [
        self.overlays.additions
        # Enabling the modifications overlay for all machines
        # means that any package which has an overlay will be
        # changed for all hosts. I may remove this in the future
        # but it works fine with my configuration for now.
        self.overlays.modifications
      ];
    };

    ########## NETWORKING ##########

    networking = {
      networkmanager.enable = true;
      # Allow all the IP's in the tailscale subnet to bypass firewall.
      firewall.extraInputRules = ''
        -A INPUT -i tailscale0 -j ACCEPT
        -A INPUT -s 100.64.0.0/10 -j ACCEPT
      '';
    };
    systemd = {
      services.NetworkManager-wait-online.enable = false;
      # Disables the service because it hangs on boot.
      services.NetworkManager-dispatcher.enable = false;
    };

    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = true;
      };
    };

    ########## KEYMAP ##########

    console.keyMap = "colemak";
    services.xserver.xkb = {
      layout = "gb";
      variant = "colemak";
    };

    ########## LOCALE ##########

    time.timeZone = "Europe/London";
    i18n.defaultLocale = "en_GB.UTF-8";

    ########## SOPS ##########

    sops.defaultSopsFormat = "yaml";
    sops.defaultSopsFile = ../../../secrets/default.yaml;
    sops.age.keyFile = "/home/alex/.config/sops/age/keys.txt";

    ########## ENVIRONMENT ##########

    environment = {
      defaultPackages = lib.mkForce [];
      sessionVariables = {
        # Additional session variables can be used via
        # delcaring environment.sessionVariables in
        # the configuration for a specific host.
        NIXPKGS_ALLOW_UNFREE = "1";
        NIXPKGS_ALLOW_INSECURE = "1";
      };
    };

    ########## MISC ##########

    # Fix 'command-not-found' error 'failed to open database'.
    programs.command-not-found.enable = false;

    programs.dconf.enable = true;
    security.polkit.enable = true;
    systemd.coredump.enable = false;

    # High performance implementation of the dbus specification.
    services.dbus.implementation = "broker";

    # Here for testing purposes, I will move this
    # into a seperate module if I decide to use it.
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [ glibc libcxx ];
    };
  };
}
