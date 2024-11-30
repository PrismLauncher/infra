{ config, lib, ... }:

{
  resource = {
    hcloud_server = {
      andesite = {
        name = "andesite";
        image = "ubuntu-22.04";
        server_type = "cax11";
        datacenter = "fsn1-dc14";
        public_net = {
          ipv4_enabled = true;
          ipv6_enabled = true;
        };
      };
    };

    netlify_dns_zone = {
      "prismlauncher" = {
        name = "prismlauncher.org";
        lifecycle = {
          prevent_destroy = true;
        };
      };
    };

    netlify_dns_record = {
      "andesite4" = {
        type = "A";
        zone_id = lib.tfRef "netlify_dns_zone.prismlauncher.id";
        hostname = "andesite.prismlauncher.org";
        value = lib.tfRef "hcloud_server.andesite.ipv4_address";
      };

      "andesite6" = {
        type = "AAAA";
        zone_id = lib.tfRef "netlify_dns_zone.prismlauncher.id";
        hostname = "andesite.prismlauncher.org";
        value = lib.tfRef "hcloud_server.andesite.ipv6_address";
      };
    };

    local_file = {
      andesite-facts = {
        content = lib.generators.toJSON { } {
          hostname = config.resource.hcloud_server.andesite.name;
          domain = config.resource.netlify_dns_zone.prismlauncher.name;
          ipv4_address = lib.tfRef "resource.hcloud_server.andesite.ipv4_address";
          ipv6_address = lib.tfRef "hcloud_server.andesite.ipv6_address";
        };

        filename = toString ../machines/andesite/facts.json;
      };
    };
  };
}
