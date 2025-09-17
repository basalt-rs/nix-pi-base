{ configFile }:
let
  netData = builtins.fromTOML (builtins.readFile configFile);

  mkNet = name: cfg: {
    inherit name;
    value = {
      psk = cfg.psk;
      priority = cfg.priority or 0;
    };
  };

  networks = builtins.listToAttrs (map (name: mkNet name netData.networks.${name}) (builtins.attrNames netData.networks));
in
{
  networking = {
    hostName = netData.hostName or "basaltpi4";
    wireless = {
      enable = netData.wireless.enable or true;
      interfaces = builtins.trace netData.wireless.interfaces netData.wireless.interfaces;
      networks = networks;
    };
    useDHCP = true;
  };
}
