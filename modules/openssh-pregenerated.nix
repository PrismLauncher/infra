{
  services.openssh = {
    hostKeys = [ ];
    settings.HostKey = "/etc/ssh/ssh_host_ed25519_key";
  };
}
