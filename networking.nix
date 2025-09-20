{ networking-config, ... }:
let
  netData = builtins.fromTOML (builtins.readFile networking-config);

  mkNet = name: cfg: {
    inherit name;
    value = {
      # Handle both PSK-based and enterprise networks
      psk = cfg.psk or null;
      priority = cfg.priority or 0;
      hidden = cfg.hidden or false;
      # Enterprise authentication (e.g., WPA2-Enterprise)
      auth = cfg.auth or null;
    };
  };

  networks = builtins.listToAttrs (map (name: mkNet name netData.networks.${name}) (builtins.attrNames netData.networks));
in
{
  networking = {
    hostName = netData.hostName or "basaltpi4";
    wireless = {
      enable = netData.wireless.enable or true;
      interfaces = netData.wireless.interfaces;
      networks = networks;
      # Optional: Allow user control via wpa_cli/wpa_gui
      userControlled.enable = netData.wireless.userControlled.enable or false;
      # Optional: Extra configuration for wpa_supplicant
      extraConfig = netData.wireless.extraConfig or "";
    };
    useDHCP = true;
  };
}
