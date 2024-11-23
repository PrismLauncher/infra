# How to onboard new members

1. Make sure new member has created accounts
   - on [HCP Terraform](https://app.terraform.io)
   - on [Hetzner Cloud](https://console.hetzner.cloud)
   - on [Netlify](https://app.netlify.com)
1. Invite new member
   - to [our HCP Terraform organization](https://app.terraform.io/app/prismlauncher/settings/users/) into the `admins` team
   - to [our Hetzner Cloud project](https://console.hetzner.cloud/projects/3927126/security/members) as `Admin`
   - to [our Netlify team](https://app.netlify.com/teams/prismlauncher/members/new/access) as `Developer`

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

## Netlify

Environment variable: `TF_VAR_netlify_token`

1. Visit https://app.netlify.com/user/applications/personal
1. Enter a descriptive description
1. Set Expiration to `90 days`
1. Click `Generate API token`
