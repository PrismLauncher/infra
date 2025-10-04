terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.53.1"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.11.0"
    }
  }

  cloud {
    hostname     = "app.terraform.io"
    organization = "prismlauncher"

    workspaces {
      name = "infrastructure"
    }
  }
}

variable "hcloud_token" {
  sensitive = true
}

provider "hcloud" {
  token = var.hcloud_token
}

variable "cloudflare_token" {
  sensitive = true
}

provider "cloudflare" {
  api_token = var.cloudflare_token
}

variable "zone_id" {
  default = "9f629aeccf940f7a195e15f82af8845c"
}

variable "domain" {
  default = "prismlauncher.org"
}
