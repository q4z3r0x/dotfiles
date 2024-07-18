{
  pkgs,
  lib,
  config,
  ...
}: {
  options.modules.waybar.enable = lib.mkEnableOption "";

  config = lib.mkIf config.modules.waybar.enable {
    wayland.windowManager.sway.config.bars = [
      {
        command = "${pkgs.waybar}/bin/waybar";
      }
    ];

    # Config
    programs.waybar = {
      enable = true;
      settings = [
        {
          layer = "top";
          height = 28;
          margin = "0 0 0 0";
          modules-left = ["clock" "sway/workspaces"];
          modules-center = [];
          modules-right = ["network" "pulseaudio" "battery"];

          # Pulseaudio
          pulseaudio = {
            tooltip = false;
            scroll-step = 1;
            format = "{icon}";
            format-alt = "{volume}%";
            format-muted = " ";
            format-icons = {
              default = [" " " " " "];
            };
          };

          # Clock
          clock = {
            format-alt = "{:%Y/%m/%d | %H:%M:%S}";
          };

          # Battery
          battery = {
            format = "{icon}"; # {icon}
            format-icons = [" " " " " " " " " "];
            format-charging = " ";
            format-alt = "{capacity}%";
            tooltip = false;
            interval = 5;
          };

          # Workspaces
          "sway/workspaces" = {
            format = "{icon}";
            format-icons = {
              "1" = "1";
              "2" = "2";
              "3" = "3";
              "4" = "4";
              "5" = "5";
              "6" = "6";
              "7" = "7";
              "8" = "8";
              "9" = "9";
              "0" = "10";
            };
            sort-by-number = true;
          };

          # Network
          network = {
            tooltip = false;
            format-wifi = " "; # 󱐋 {frequency}
            format-disconnected = " ";
            format-alt = "{ipaddr}";
            format-ethernet = "󰈁";
            interval = 5;
          };
        }
      ];

      style = ''
        * {
          font-family: FiraCode Mono Nerd Font;
          font-size: 12px;
          background-color: transparent;
          border-radius: 0px;
          margin-left: 4px;
          margin-right: 4px;
        }

        window#waybar {
          background-color: #000;

          margin-top: 4px;
          margin-bottom: 4px;
        }

        #memory,
        #custom-power,
        #battery,
        #backlight,
        #pulseaudio,
        #network,
        #clock,
        #cpu,
        #memory,
        #temperature,
        #disk,
        #mpris,
        #tray {
          border-radius: 6px;
          padding: 4px 4px;
          color: #ffffff;
        }

        #workspaces button {
          all: initial; /* Remove GTK theme values (waybar #1351) */
          min-width: 0; /* Fix weird spacing in materia (waybar #450) */
          padding: 4px 4px;
          border-radius: 6px;
          color: #606060;
        }

        #workspaces button.visible {
          color: #ffffff;
        }

        tooltip {
          border-radius: 6px;
          padding: 15px;
          background-color: #000000;
        }

        tooltip label {
          padding: 3px;
          background-color: #000000;
        }

        /* EDGE MARGINS */
        #clock {
        margin-left: 10px;
        margin-right: 4px;
        background-color: #fff;
        color: #000;
        }
        #battery {
        margin-right: 10px;
        }
      '';
    };
  };
}
