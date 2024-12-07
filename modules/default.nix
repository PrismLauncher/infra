{
  nixosModules = {
    from-facts = ./from-facts.nix;
    openssh-pregenerated = ./openssh-pregenerated.nix;
  };
}
