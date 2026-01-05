{
  flake.modules.nixos."base".nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://infra-cache.prismlauncher.org"
    ];
    trusted-public-keys = [
      "infra-cache.prismlauncher.org-1:4U7OYwBrZnq4KfTVXRPArA+YwWbPlT83ZGVbP7HXkKk="
    ];
  };
}
