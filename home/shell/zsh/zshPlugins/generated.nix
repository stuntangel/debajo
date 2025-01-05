pkgs: {
  z = pkgs.fetchFromGitHub {
    owner = "rupa";
    repo = "z";
    rev = "125f4dc47e15891739dd8262d5b23077fe8fb9ab";
    sha256 = "oP7/fGqfh4Qsuzgrh+XS9xC9w6ASmZTLOF30z1AdGkY=";
    fetchSubmodules = true;
  };
  zsh-bd = pkgs.fetchFromGitHub {
    owner = "Tarrasch";
    repo = "zsh-bd";
    rev = "d4a55e661b4c9ef6ae4568c6abeff48bdf1b1af7";
    sha256 = "iznyTYDvFr1wuDZVwd1VTcB179SZQ2L0ZSY9g7BFDgg=";
    fetchSubmodules = true;
  };
  zsh-autosuggestions = pkgs.fetchFromGitHub {
    owner = "zsh-users";
    repo = "zsh-autosuggestions";
    rev = "ae315ded4dba10685dbbafbfa2ff3c1aefeb490d";
    sha256 = "xv4eleksJzomCtLsRUj71RngIJFw8+A31O6/p7i4okA=";
    fetchSubmodules = true;
  };
  zsh-history-substring-search = pkgs.fetchFromGitHub {
    owner = "zsh-users";
    repo = "zsh-history-substring-search";
    rev = "0f80b8eb3368b46e5e573c1d91ae69eb095db3fb";
    sha256 = "Ptxik1r6anlP7QTqsN1S2Tli5lyRibkgGlVlwWZRG3k=";
    fetchSubmodules = true;
  };
  zsh-completions = pkgs.fetchFromGitHub {
    owner = "zsh-users";
    repo = "zsh-completions";
    rev = "aa98bc593fee3fbdaf1acedc42a142f3c4134079";
    sha256 = "eBc25Smx8KEAnWC4EBA/6Znj7hZw5FIj7CMsUO1wA4c=";
    fetchSubmodules = true;
  };
  zsh-syntax-highlighting = pkgs.fetchFromGitHub {
    owner = "zsh-users";
    repo = "zsh-syntax-highlighting";
    rev = "e8517244f7d2ae4f9d979faf94608d6e4a74a73e";
    sha256 = "L2XvyckbI1a5zE/JnJibekFEkF8ZjKV1j4Fxh2QBrLc=";
    fetchSubmodules = true;
  };
}
