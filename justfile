[private]
anywhere machine *args:
    nix run github:nix-community/nixos-anywhere -- --flake .#{{ machine }} {{ args }}

# Generate SSH host keys
prepare-bootstrap machine:
    mkdir -p bootstrap/{{ machine }}/etc/ssh
    ssh-keygen -t ed25519 -a 100 -N "" -C "{{ machine }}" -f bootstrap/{{ machine }}/etc/ssh/ssh_host_ed25519_key
    mv bootstrap/{{ machine }}/etc/ssh/ssh_host_ed25519_key.pub keys/{{ machine }}.pub
    agenix --rekey

bootstrap machine host *args:
    @just anywhere \
      {{ machine }} \
      --extra-files \
      {{ "./bootstrap/" + machine }} \
      --generate-hardware-config \
      nixos-facter \
      {{ ("./machines/" + machine + "/facter.json") }} \
      {{ args }} \
      {{ host }}

bootstrap-vm machine *args:
    @just anywhere --vm-test {{ args }}
