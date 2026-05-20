let
  ryan = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHeQqAigtqKxnDdBNpM8GZZRcETv6b/yot0V74SzfTdv";
  laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHWKG3kEKTv6M/lTPA8F6zHBMf07XJycRk5/5fzdndsz";
  allKeys = [ryan laptop];
in {
  "ryan.age".publicKeys = allKeys;
}
