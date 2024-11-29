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

resource "netlify_dns_zone" "prismlauncher" {
  name = "prismlauncher.org"
  lifecycle {
    prevent_destroy = true
  }
}

resource "netlify_dns_record" "andesite4" {
  type     = "A"
  zone_id  = netlify_dns_zone.prismlauncher.id
  hostname = "andesite.prismlauncher.org"
  value    = hcloud_server.andesite.ipv4_address
}

resource "netlify_dns_record" "andesite6" {
  type     = "AAAA"
  zone_id  = netlify_dns_zone.prismlauncher.id
  hostname = "andesite.prismlauncher.org"
  value    = hcloud_server.andesite.ipv6_address
}

resource "local_file" "andesite-facts" {
  content = jsonencode({
    "hostname"     = hcloud_server.andesite.name
    "domain"       = netlify_dns_zone.prismlauncher.name
    "ipv4_address" = hcloud_server.andesite.ipv4_address
    "ipv6_address" = hcloud_server.andesite.ipv6_address
  })
  filename = "${path.root}/machines/andesite/facts.json"
}
