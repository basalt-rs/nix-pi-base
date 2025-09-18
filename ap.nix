{ lib, networking-config, ... }:
let
  netData = builtins.fromTOML (builtins.readFile networking-config);
  building = builtins.hasAttr "ap" netData;
in
{
  config = lib.mkIf (builtins.trace "usingAP=${builtins.toString building}" building) {
    # Enable forwarding packets
    boot.kernel.sysctl = {
      "net.ipv6.conf.all.forwarding" = 1;
      "net.ipv4.conf.all.forwarding" = 1;
    };
    systemd.services.create_ap = {
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "120";
      };
    };
    # Enable AP
    services.create_ap = {
      enable = netData.ap.enable or true;
      settings = {
        INTERNET_IFACE = netData.ap.internet_interface;
        WIFI_IFACE = netData.ap.wifi_interface;
        SSID = netData.ap.ssid;
        PASSPHRASE = netData.ap.psk;
      };
    };
  };
}
