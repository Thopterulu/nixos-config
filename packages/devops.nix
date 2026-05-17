{ pkgs, ... }:

{
  home.packages = with pkgs; [
    k9s              # TUI for Kubernetes cluster management
    terraform        # Infrastructure as Code provisioning
    ansible          # Configuration management and automation
    google-cloud-sdk # GCP CLI (gcloud, gsutil, bq)
    helmfile         # Declarative Helm chart deployments
    kubectl          # Kubernetes CLI
    kubernetes-helm  # Kubernetes package manager
    kubie            # Kubernetes context/namespace switcher
    lazydocker       # TUI for Docker containers and images
    trivy            # Container and filesystem security scanner
  ];
}
