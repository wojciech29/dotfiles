{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "vojtech";
  home.homeDirectory = "/home/vojtech";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    git
    fzf
    ripgrep
    fd
    tmux
    neovim
    htop

    pyright
    ruff
    nodejs_22
    yarn
    lua-language-server
    stylua

    flameshot
    inkscape
    gimp
    spotify
    signal-desktop
  ];

  programs.git = {
    enable = true;
    userEmail = "vojtech.remes@gmail.com";
    userName = "wojciech29";
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      # Add additional package names here
      "spotify"
    ];
}
