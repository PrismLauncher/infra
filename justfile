_anywhere machine *args:
    nix run github:nix-community/nixos-anywhere -- --flake .#{{ machine }} {{ args }}

# Generate SSH host keys
# TODO integrate with agenix
prepare-bootstrap machine:
    mkdir -p bootstrap/{{ machine }}/etc/ssh
    ssh-keygen -t ed25519 -a 100 -N "" -f bootstrap/{{ machine }}/etc/ssh/ssh_host_ed25519_key

bootstrap machine host *args: (_anywhere machine "--extra-files" ("./bootstrap/" + machine) "--generate-hardware-config" "nixos-facter" ("./machines/" + machine + "/facter.json") args host)

bootstrap-vm machine *args: (_anywhere machine "--vm-test")
