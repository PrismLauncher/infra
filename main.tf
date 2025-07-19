locals {
  user_keys_path = "${path.root}/keys/users"
  user_keys      = { for f in fileset(local.user_keys_path, "*.pub") : trimsuffix(f, ".pub") => file("${local.user_keys_path}/${f}") }
}

resource "hcloud_ssh_key" "user_keys" {
  for_each   = local.user_keys
  name       = each.key
  public_key = each.value
}

resource "hcloud_server" "andesite" {
  name        = "andesite"
  image       = "ubuntu-22.04"
  server_type = "cax11"
  datacenter  = "fsn1-dc14"
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  ssh_keys = [for k in hcloud_ssh_key.user_keys : k.id]

  lifecycle {
    ignore_changes = [ssh_keys]
  }
}

resource "cloudflare_record" "andesite4" {
  zone_id = var.zone_id
  name    = "andesite.prismlauncher.org"
  content = hcloud_server.andesite.ipv4_address
  type    = "A"
  ttl     = 1
}

resource "cloudflare_record" "andesite6" {
  zone_id = var.zone_id
  name    = "andesite.prismlauncher.org"
  content = hcloud_server.andesite.ipv6_address
  type    = "AAAA"
  ttl     = 1
}

resource "local_file" "andesite-facts" {
  content = jsonencode({
    "hostname"     = hcloud_server.andesite.name
    "domain"       = var.domain
    "ipv4_address" = hcloud_server.andesite.ipv4_address
    "ipv6_address" = hcloud_server.andesite.ipv6_address
  })
  filename = "${path.root}/machines/andesite/facts.json"
}
