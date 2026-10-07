{ config, ... }:

{
  environment.etc."ssh/ca.pub".source = ./ssh-ca.pub;

  services.openssh.settings = {
    TrustedUserCAKeys = "/etc/ssh/ca.pub";
#    PasswordAuthentication = false;
#    KbdInteractiveAuthentication = false;
  };
}