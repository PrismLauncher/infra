locals {
  github_pages = [
    "files",
    "i18n",
    "meta"
  ]
  netlify_projects = [
    "@",
    "www",
    "dev.wiki",
    "next",
    "community"
  ]
  tuta_records = {
    txt-verify = {
      type    = "TXT"
      name    = "prismlauncher.org"
      content = "\"t-verify=cff46644b119bfd52f571d31f48751d5\""
    }
    spf = {
      type    = "TXT"
      name    = "prismlauncher.org"
      content = "\"v=spf1 include:spf.tutanota.de -all\""
    }
    dkim1 = {
      type    = "CNAME"
      name    = "s1._domainkey.prismlauncher.org"
      content = "s1.domainkey.tutanota.de"
    }
    dkim2 = {
      type    = "CNAME"
      name    = "s2._domainkey.prismlauncher.org"
      content = "s2.domainkey.tutanota.de"
    }
    mta-sts1 = {
      type    = "CNAME"
      name    = "_mta-sts.prismlauncher.org"
      content = "mta-sts.tutanota.de"
    }
    mta-sts2 = {
      type    = "CNAME"
      name    = "mta-sts.prismlauncher.org"
      content = "mta-sts.tutanota.de"
    }
    dmarc = {
      type    = "TXT"
      name    = "_dmarc.prismlauncher.org"
      content = "\"v=DMARC1; p=quarantine; adkim=s\""
    }
  }
}

# Netlify

resource "cloudflare_record" "netlify_cnames" {
  for_each = toset(local.netlify_projects)
  zone_id  = var.zone_id
  name     = each.value
  content  = "apex-loadbalancer.netlify.com"
  type     = "CNAME"
  proxied  = true
  ttl      = 1
}

# Tuta

resource "cloudflare_record" "tuta_mx" {
  zone_id  = var.zone_id
  type     = "MX"
  name     = "@"
  content  = "mail.tutanota.de"
  priority = 10
  ttl      = 1
}

resource "cloudflare_record" "tuta_verifications" {
  for_each = local.tuta_records

  type    = each.value.type
  zone_id = var.zone_id
  name    = each.value.name
  content = each.value.content
  proxied = false
  ttl     = 1
}

# GH Pages

resource "cloudflare_record" "github_pages_verification" {
  type    = "TXT"
  zone_id = var.zone_id
  name    = "_github-pages-challenge-PrismLauncher"
  content = "\"23da4bf9f190fdedacf4b54db77a12\""
  ttl     = 1
}

resource "cloudflare_record" "cnames_github_pages" {
  for_each = toset(local.github_pages)

  type    = "CNAME"
  zone_id = var.zone_id
  name    = each.value
  content = "prismlauncher.github.io"
  proxied = false
  ttl     = 1
}

# ATProto verification

resource "cloudflare_record" "atproto_verification" {
  type    = "TXT"
  zone_id = var.zone_id
  name    = "_atproto"
  content = "\"did=did:plc:g54dywwc44gjwn3axkjuuklj\""
  ttl     = 1
}

# Discord verification

# Attached to scrumplex's Discord account
resource "cloudflare_record" "discord_verification" {
  type    = "TXT"
  zone_id = var.zone_id
  name    = "_discord"
  content = "\"dh=1b08bb39456651c326f6c58d9c9f540ff12c984e\""
  ttl     = 1
}
