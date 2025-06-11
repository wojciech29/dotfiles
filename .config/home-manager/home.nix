{ config, pkgs, lib, ... }:

let
  # Import the unstable channel
  unstable-pkgs = import <nixpkgs-unstable> {
    # Inherit configuration like allowUnfree from your main pkgs
    # This is important if unstable neovim depends on unfree plugins/deps
    config = config.nixpkgs.config;
  };
in {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "vojtech";
  home.homeDirectory = "/home/vojtech";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # System
    git
    fzf
    ripgrep
    fd
    tmux
    htop
    fswatch
    lf
    nmap
    direnv

    # Development
    unstable-pkgs.neovim
    helix
    jq
    ## Python
    pyright
    unstable-pkgs.ruff
    # JS
    yarn
    ## Lua
    lua-language-server
    stylua
    ## Nix
    nixd
    nixfmt-classic
    ## Rust
    rust-analyzer

    # Meteo
    xygrib

    # GUI apps
    unstable-pkgs.inkscape
    unstable-pkgs.clementine
    unstable-pkgs.gimp3
    unstable-pkgs.spotify
    unstable-pkgs.signal-desktop
    unstable-pkgs.librecad
    unstable-pkgs.audacity
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
      # Add allowed unfree packages here
      "spotify"
    ];
}
