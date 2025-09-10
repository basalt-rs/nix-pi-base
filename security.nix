{
  sudo = {
    enable = true;
    extraRules = [
      {
        # Configure your rules here!
        # In my setup, I give my user password-less access to shutdown and reboot
        users = ["jack"];
        commands = [
          { command = "/run/current-system/sw/bin/reboot"; options = [ "NOPASSWD" ]; }
          { command = "/run/current-system/sw/bin/poweroff"; options = [ "NOPASSWD" ]; }
        ];
      }
    ];
  };
}
