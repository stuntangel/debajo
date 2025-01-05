[![MIT License](https://img.shields.io/github/license/divnix/devos)][mit]
[![NixOS](https://img.shields.io/badge/NixOS-unstable-blue.svg?style=flat&logo=NixOS&logoColor=white)](https://nixos.org)

# Lower Coffetables Nix Configuration
I'm Parthiv, pacman99, or pachumicchu. This repository/flake covers practically everything thats setup in my computer.

I try to configure as much as I can through nix and this is possible due to projects like [digga][digga], [dconf2nix][dconf2nix], and [nix-doom-emacs][nix-doom-emacs] along with all the amazing work done in nixpkgs.

## Setup
 - [Gnome][gnome] with [home-manager][home-manager] and [dconf2nix][dconf2nix]
 - [Wireguard][wireguard] connecting through [myrdd][myrdd]
 - [Emacs][emacs] with [doom][doom] and [nix-doom-emacs][nix-doom-emacs]
 - [Vim][vim] with [spacevim][spacevim]
 - [Zsh][zsh] with [home-manager][home-manager] module and code to auto-generate plugin definitions

I change my setup a lot, because I like to experiment with new projects, not due to procrastination or indecision.

## Naming
An inside joke with my brother: all our hosts are named relative to the coffee table. Which coffee table? The magical one.


[gnome]: ./home/profiles/desktop/gnome.nix
[wireguard]: ./system/profiles/networking/wireguard.nix
[emacs]: ./home/profiles/apps/emacs
[vim]: ./home/profiles/shell/spacevim
[zsh]: ./home/profiles/shell/zsh
[digga]: https://github.com/divnix/digga
[home-manager]: https://github.com/nix-community/home-manager
[dconf2nix]: https://github.com/gvolpe/dconf2nix
[doom]: https://github.com/hlissner/doom-emacs
[nix-doom-emacs]: https://github.com/nix-community/nix-doom-emacs
[myrdd]: https://gitlab.com/coffeetables/myrdd
