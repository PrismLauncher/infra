resource "cloudflare_r2_bucket" "nix_cache" {
  account_id    = var.account_id
  name          = "prismlauncher-nix-cache"
  jurisdiction  = "eu"
  storage_class = "Standard"
}

resource "cloudflare_r2_custom_domain" "nix_cache" {
  account_id   = var.account_id
  bucket_name  = cloudflare_r2_bucket.nix_cache.name
  jurisdiction = cloudflare_r2_bucket.nix_cache.jurisdiction
  domain       = "infra-cache.prismlauncher.org"
  enabled      = true
  zone_id      = var.zone_id
}
