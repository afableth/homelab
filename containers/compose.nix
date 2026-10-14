{
  pkgs,
  ...
}:

{
  environment.etc."my-server/compose.yaml".source = ./compose.yaml;
  systemd.services.my-server = {
    description = "Auto start compose";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      WorkingDirectory = "/etc/my-server";
      ExecStart = "${pkgs.podman-compose}/bin/podman-compose -f compose.yaml up -d";
      ExecStop = "${pkgs.podman-compose}/bin/podman-compose -f compose.yaml down";
      RemainAfterExit = true;
    };
    path = [ pkgs.podman ]; # podman-compose needs podman in PATH
  };
}
