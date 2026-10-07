{ ... }:

{
  # K3s: lightweight Kubernetes
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = [
      "--disable=traefik"
      "--disable=servicelb"
    ];
    manifests = {
      nginx-deployment = {
        content = {
          apiVersion = "apps/v1";
          kind = "Deployment";
          metadata = {
            name = "nginx";
            labels.app = "nginx";
          };
          spec = {
            replicas = 1;
            selector.matchLabels.app = "nginx";
            template = {
              metadata.labels.app = "nginx";
              spec.containers = [
                {
                  name = "nginx";
                  image = "nginx:latest";
                  ports = [ { containerPort = 80; } ];
                }
              ];
            };
          };
        };
      };
      nginx-service = {
        content = {
          apiVersion = "v1";
          kind = "Service";
          metadata = {
            name = "nginx";
            labels.app = "nginx";
          };
          spec = {
            selector.app = "nginx";
            ports = [
              {
                protocol = "TCP";
                port = 80;
                targetPort = 80;
                nodePort = 30080;
              }
            ];
            type = "NodePort";
          };
        };
      };
    };
  };

  # Open firewall ports for k3s API and nginx
  networking.firewall.allowedTCPPorts = [
    6443 # k3s API server
    30080 # nginx NodePort
  ];
}
