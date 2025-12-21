# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      <home-manager/nixos>
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # =========================================================================
  # KERNEL SELECTION (CRITICAL FOR NVIDIA)
  # =========================================================================
  # We use the default LTS kernel to ensure NVIDIA drivers compile correctly.
  boot.kernelPackages = pkgs.linuxPackages; 
  # =========================================================================

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Kolkata";

  i18n.defaultLocale = "en_IN";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "en_IN/UTF-8"
  ];
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  services.xserver.enable = true;

  # =======================================================
  # NVIDIA DRIVER CONFIGURATION
  # =======================================================

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # =======================================================

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.spandan = {
    isNormalUser = true;
    description = "Spandan Roy";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      kdePackages.kate
      pnpm
    ];
  };

  users.defaultUserShell = pkgs.zsh;
  
  # =======================================================
  # HOME MANAGER CONFIGURATION
  # =======================================================
  home-manager.users.spandan = { pkgs, ... }: {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      
      # This is the CRITICAL part that fixes the "magick" error
      extraLuaPackages = ps: [ ps.magick ]; 
      
      # Tools needed by plugins (LSP, formatters, etc.)
      extraPackages = with pkgs; [ 
        imagemagick 
        xclip 
        wl-clipboard 
      ];
    };

    home.enableNixpkgsReleaseCheck = false;
    home.stateVersion = "24.05"; 
  };

  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;

  # =======================================================
  # Dev Env
  # =======================================================
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true; # Better caching for flakes
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  environment.systemPackages = with pkgs; [

    # ─────────────────────────────
    # Core Utilities
    # ─────────────────────────────
    tree
    wget
    unzip
    imagemagick
    wl-clipboard
    python3
    btrfs-progs

    # ─────────────────────────────
    # Terminal & CLI Enhancements
    # ─────────────────────────────
    fastfetch
    eza
    fzf
    zoxide
    starship
    btop
    gtop
    tmux

    # ─────────────────────────────
    # Editors & Shell Tools
    # ─────────────────────────────
    (neovim.override {
      extraLuaPackages = ps: [ ps.magick ];
    })
    tree-sitter
    luarocks
    pandoc
    texlive.combined.scheme-small
    wkhtmltopdf-bin

    # ─────────────────────────────
    # Version Control & Networking
    # ─────────────────────────────
    git
    github-cli

    # ─────────────────────────────
    # Build Systems & Toolchains
    # ─────────────────────────────
    gcc
    gnumake
    cmake
    pkg-config
    openssl
    llvm
    clang
    clang-tools    # clangd, clang-tidy, etc.
    gdb            # GNU Debugger
    lldb           # LLVM Debugger

    # ─────────────────────────────
    # Languages & Language Servers
    # ─────────────────────────────
    rustup         # rustc, cargo, rust-analyzer
    nodePackages.nodejs
    lua            # Lua interpreter

    # ─────────────────────────────
    # Search & Telescope Dependencies
    # ─────────────────────────────
    ripgrep
    fd

    # ─────────────────────────────
    # GPU / CUDA
    # ─────────────────────────────
    cudaPackages.cudatoolkit

    # ─────────────────────────────
    # Desktop / UI / Media
    # ─────────────────────────────
    kitty
    mpv
    obsidian
    blender
    gimp
    eww
    youtube-music
    yt-dlp
    qbittorrent
    google-chrome

    # ─────────────────────────────
    # KDE Applications & Libraries
    # ─────────────────────────────
    kdePackages.qtmultimedia
    kdePackages.kdenlive
    kdePackages.filelight
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    fira-code
    nerd-fonts.jetbrains-mono
  ];

  # =======================================================
  # SHELL CONFIGURATION (FIXED)
  # =======================================================

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    # DISABLE Autosuggestions to fix the "jumping cursor" conflict with zsh-autocomplete
    autosuggestions.enable = true; 

    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "eza --icons --group-directories-first";
      ll = "eza -l --icons --group-directories-first";
      l = "eza -la --icons --group-directories-first";
    };

    # Initialize tools here to ensure correct order and absolute paths
    interactiveShellInit = ''
      eval "$(${pkgs.zoxide}/bin/zoxide init zsh --cmd cd)"
    '';
  };

  # =======================================================
  # Bluetooth
  # =======================================================

  hardware.bluetooth.enable = true;

  # =======================================================
  # GRAPHICS & STEAM SUPPORT
  # =======================================================

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  # =======================================================
  # CUSTOM FILESYSTEM MOUNT
  # =======================================================
  fileSystems."/home" = { 
    device = "/dev/disk/by-uuid/31138b81-898c-4d7a-bea0-5b545770d9c1";
    fsType = "btrfs";
    options = [ "subvol=@home" "compress=zstd" "noatime" ];
  };

  system.stateVersion = "25.11"; 
}
