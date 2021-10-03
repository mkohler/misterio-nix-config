{ pkgs, hostname, impermanence, nix-colors, nur, ... }:

{
  imports = [
    impermanence.nixosModules.home-manager.impermanence
    nix-colors.homeManagerModule

    ./scheme.nix

    ./direnv.nix
    ./fish.nix
    ./git.nix
    ./neofetch.nix
    ./nix-index.nix
    ./nvim.nix
    ./starship.nix
  ] ++ (if hostname == "atlas" then [
    ./discord.nix
    ./element.nix
    ./ethminer.nix
    ./fira.nix
    ./gpg.nix
    ./gtk.nix
    ./kdeconnect.nix
    ./kitty.nix
    ./lutris.nix
    ./mail.nix
    ./mako.nix
    ./multimc.nix
    ./neomutt.nix
    ./osu.nix
    ./pass.nix
    ./qt.nix
    ./qutebrowser.nix
    ./rgbdaemon.nix
    # ./runescape.nix
    ./slack.nix
    ./steam.nix
    ./sway.nix
    ./swayidle.nix
    ./swaylock.nix
    ./waybar.nix
    ./zathura.nix
  ] else
    [ ]);

  programs.home-manager.enable = true;

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ nur.overlay ];
  };

  systemd.user.startServices = "sd-switch";

  home.file.bin.source = ./scripts;

  home.packages = with pkgs;
    [
      # Cli
      bottom
      cachix
      exa
      ncdu
      ranger
      comma
    ] ++ (if hostname == "atlas" then [
      # Gui apps
      dragon-drop
      ydotool
      xdg-utils
      setscheme
      imv
      pavucontrol
      spotify
      wofi
    ] else
      [ ]);

  home.persistence = {
    "/data/home/misterio" = {
      directories = [ "Documents" "Downloads" "Pictures" ];
      allowOther = true;
    };
  };
}
