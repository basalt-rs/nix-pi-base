{ configFile }:
let
  userData = builtins.fromTOML (builtins.readFile configFile);

  mkUser = user: {
    name = user.name;
    value = {
      isNormalUser = user.isNormalUser or true;
      hashedPassword = user.hashedPassword or null;
      extraGroups = user.extraGroups or [];
      openssh.authorizedKeys.keys = user.sshKeys or [];
    };
  };

  userMap = builtins.listToAttrs (map mkUser userData.users);
in
{
  users.users = userMap;
}
