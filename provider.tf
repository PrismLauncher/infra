terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
    netlify = {
      source = "netlify/netlify"
      version = "~> 0.2"
    }
  }

  cloud {
    hostname = "app.terraform.io"
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

variable "netlify_token" {
  type = string
}

provider "netlify" {
  token = var.netlify_token
  default_team_slug = "prismlauncher"
}
