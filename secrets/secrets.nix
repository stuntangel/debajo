let
  ryan = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMQ8c2JVAzuS7GL3EbuT8SO9hJFPH4Z/WGLE1rCmrHE9";
  laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHWKG3kEKTv6M/lTPA8F6zHBMf07XJycRk5/5fzdndsz";
  allKeys = [ryan laptop];
in {
  "ryan.age".publicKeys = allKeys;
  "keepass.age".publicKeys = allKeys;
}
