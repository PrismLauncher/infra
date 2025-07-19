# How to onboard new members

1. Make sure new member has created accounts
   - on [HCP Terraform](https://app.terraform.io)
   - on [Hetzner Cloud](https://console.hetzner.cloud)
   - on [Cloudflare](https://dash.cloudflare.com)
1. Invite new member
   - to [our HCP Terraform organization](https://app.terraform.io/app/prismlauncher/settings/users/) into the `admins` team
   - to [our Hetzner Cloud project](https://console.hetzner.cloud/projects/3927126/security/members) as `Admin`
   - to our Cloudflare account (NOTE: Currently the domain resides in @Scrumplex' account)

# Setting up secrets

## HCP Terraform

Environment variable: `TF_TOKEN_app_terraform_io`

1. Visit https://app.terraform.io/app/settings/tokens
1. Click `Create an API token`
1. Enter a descriptive description
1. Set Expiration to `90 days`
1. Click `Generate token`

## Hetzner Cloud

Environment variable: `TF_VAR_hcloud_token`

1. Visit https://console.hetzner.cloud/projects/3927126/security/tokens
1. Click `Generate API token`
1. Enter a descriptive description
1. Set permissions to `Read & Write`
1. Click `Generate API token`

## Cloudflare

Environment variable: `TF_VAR_cloudflare_token`

1. Visit https://dash.cloudflare.com/profile/api-tokens
1. Click `Create Token`
1. Click `Use Template` next to `Edit zone DNS`
1. Under `Zone Resources` Select the zone `prismlauncher.org`
1. Click `Continue to summary`
