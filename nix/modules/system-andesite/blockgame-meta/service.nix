{ inputs, ... }:
{
  flake.modules.nixos."system-andesite" =
    { config, ... }:
    {
      imports = [
        inputs.blockgame-meta.nixosModules.default
      ];

      age.secrets."prismautomata.key".file = ./prismautomata.key.age;

      systemd.services.blockgame-meta.serviceConfig.LoadCredential = [
        "ssh_key:${config.age.secrets."prismautomata.key".path}"
      ];

      services.blockgame-meta = {
        enable = true;
        settings = {
          DEPLOY_TO_GIT = "true";
          GIT_AUTHOR_NAME = "PrismAutomata";
          GIT_AUTHOR_EMAIL = "gitbot@scrumplex.net";
          GIT_COMMITTER_NAME = "PrismAutomata";
          GIT_COMMITTER_EMAIL = "gitbot@scrumplex.net";
          GIT_SSH_COMMAND = "ssh -i $CREDENTIALS_DIRECTORY/ssh_key";
          META_UPSTREAM_URL = "git@github.com:PrismLauncher/meta-upstream.git";
          META_LAUNCHER_URL = "git@github.com:PrismLauncher/meta-launcher.git";
        };
      };

      environment.persistence."/nix/persistence".directories = [
        "/var/lib/blockgame-meta"
        "/var/cache/blockgame-meta"
      ];
    };
}
