{pkgs, ...}: {
  imports = [
    ../../hardware/jet
    ../../modules/nixos
    ../../modules/server
  ];

  networking.hostName = "jet";

  users.users = {
    alex = {
      initialPassword = "xela";
      isNormalUser = true;
      extraGroups = ["networkmanager" "wheel" "video" "audio" "dialout"];
      shell = pkgs.fish;
    };
  };

  # Stop the power button from
  # shutting down the machine.
  # (long button press still works)
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
    HandleSuspendKey=ignore
    HandleHibernateKey=ignore
  '';

  programs.fish.enable = true;

  # This allows links to be
  # opened across applications.
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
    # Fix 'xdg-desktop-portal 1.17 reworked how
    # portal implementations are loaded' warning.
    config.common.default = "*";
  };

  hardware = {
    graphics = {
      enable = true;
    };
    asahi = {
      useExperimentalGPUDriver = true;
      setupAsahiSound = true;
      peripheralFirmwareDirectory = ../../firmware/jet;
    };
  };

  services.udev = {
		# Required for PlatformIO
		packages = [ 
    	pkgs.platformio-core
    	pkgs.openocd
  	];
		# ESP32-CYD2USB Support
		extraRules = ''
    	SUBSYSTEM=="tty", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="7523", SYMLINK+="ttyUSB0", MODE="0666", GROUP="dialout"
  	'';
	};

  boot = {
    kernelParams = [
      # Enables the pixels horizontal of the notch.
      "apple_dcp.show_notch=1"
      "quiet"
      # Redirect console messages.
      "console=tty3"
      # Disable cursor to stop blinking.
      "vt.global_cursor_default=0"
      # Wipe the vendor logo earlier in the boot sequence.
      "fbcon=nodefer"
    ];
    initrd.verbose = false;
    consoleLogLevel = 0;
    m1n1CustomLogo = ../../assets/m1n1CustomLogo_sus.png;
  };

  # Hide the 'File descriptor leaked on LVM invocation' warning on boot.
  environment.etc."lvm/lvm.conf".text = ''
    devices {
        suppress_fd_warnings = 1;
    }
    logging {
        level = 0;
    }
  '';

  # Autologin and hide getty messages.
  services.getty = {
    autologinUser = "alex";
    extraArgs = [
      "--skip-login"
      "--nonewline"
      "--noissue"
      "--noclear"
    ];
  };
  environment.loginShellInit = ''
    [[ "$(tty)" == /dev/tty1 ]] && dbus-run-session Hyprland
  '';

  swapDevices = [
    {
      device = "/swapfile";
      size = 4 * 1024;
    }
  ];

  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      XDG_SESSION_TYPE = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

      # Temporary fix for nautilus not launching on hyprland.
      # https://bbs.archlinux.org/viewtopic.php?pid=2196562#p2196562
      GSK_RENDERER = "ngl";
      # Temporary fix for the cursor being offset slightly on hyprland.
      # https://github.com/hyprwm/Hyprland/issues/7244
      AQ_NO_ATOMIC = "0";
    };
  };

  modules = {
    core.enable = true;
    bluetooth.enable = true;
    # Sound is managed via the setupAsahiSound option
    # and I do not need easyeffects installed on Jet.
    # pipewire.enable = true;
    systemd-boot.enable = true;
    filesystem = {
      enable = true;
      apfsSupport = true;
    };
    zram.enable = true;
    tailscale.enable = true;

    server = {
      docker.enable = true;
    };
  };

  # Did you read the comment?
  system.stateVersion = "24.11";
}
