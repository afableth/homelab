{ ... }:

{
  # K3s: lightweight Kubernetes
  services.k3s = {
    enable = true;
    role = "server";
    manifests = {
      llm.source = manifests/llm.yaml;
    };
  };
}
