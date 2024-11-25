{
  lib,
  config,
  ...
}: {
  options.modules.server.samba.enable = lib.mkEnableOption "";

  config = lib.mkIf config.modules.server.samba.enable {
    systemd.tmpfiles.rules = [
      "d /home/alex/Samba 0777 alex - - -"
    ];

    services.samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "opal";
          "netbios name" = "opal";
          "security" = "user";
          "encrypt passwords" = "yes";
          # Allow local network and tailnet.
          "hosts allow" = "192.168.0. localhost 100.64.0.0/10";
          "hosts deny" = "0.0.0.0/0";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
        "Samba" = {
          "path" = "/home/alex/Samba";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0777";
          "directory mask" = "0777";
          "force user" = "alex";
          "force group" = "alex";
        };
      };
    };

    # Allow network discovery.
    services.samba-wsdd = {
      enable = true;
      openFirewall = true;
      interface = "tailscale0";
    };

    networking.firewall.enable = true;
    networking.firewall.allowPing = true;
  };
}
