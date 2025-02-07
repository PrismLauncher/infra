locals {
  user_keys_path = "${path.root}/keys/users"
  user_keys      = { for f in fileset(local.user_keys_path, "*.pub") : trimsuffix(f, ".pub") => file("${local.user_keys_path}/${f}") }

  tutanota_records = {
    txt-verify = {
      type     = "TXT"
      hostname = "prismlauncher.org"
      value    = "t-verify=cff46644b119bfd52f571d31f48751d5"
    }
    spf = {
      type     = "TXT"
      hostname = "prismlauncher.org"
      value    = "v=spf1 include:spf.tutanota.de -all"
    }
    dkim1 = {
      type     = "CNAME"
      hostname = "s1._domainkey.prismlauncher.org"
      value    = "s1.domainkey.tutanota.de"
    }
    dkim2 = {
      type     = "CNAME"
      hostname = "s2._domainkey.prismlauncher.org"
      value    = "s2.domainkey.tutanota.de"
    }
    mta-sts1 = {
      type     = "CNAME"
      hostname = "_mta-sts.prismlauncher.org"
      value    = "mta-sts.tutanota.de"
    }
    mta-sts2 = {
      type     = "CNAME"
      hostname = "mta-sts.prismlauncher.org"
      value    = "mta-sts.tutanota.de"
    }
    dmarc = {
      type     = "TXT"
      hostname = "_dmarc.prismlauncher.org"
      value    = "v=DMARC1; p=quarantine; adkim=s"
    }
  }
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

resource "netlify_dns_record" "tuta_mx" {
  type     = "MX"
  zone_id  = netlify_dns_zone.prismlauncher.id
  hostname = "prismlauncher.org"
  value    = "mail.tutanota.de"
  priority = 10
}

resource "netlify_dns_record" "tuta_verifications" {
  for_each = local.tutanota_records

  type     = each.value.type
  zone_id  = netlify_dns_zone.prismlauncher.id
  hostname = each.value.hostname
  value    = each.value.value
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
