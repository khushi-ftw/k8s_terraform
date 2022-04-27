provider "aws" {
  profile = "default"
  region  = var.region
}

provider "kubernetes" {
  config_path = var.kube_config
}
