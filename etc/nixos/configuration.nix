# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    <home-manager/nixos>
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # =========================================================================
  # KERNEL SELECTION (CRITICAL FOR NVIDIA & V4L2)
  # =========================================================================
  # We use the default LTS kernel to ensure NVIDIA drivers compile correctly.
  boot.kernelPackages = pkgs.linuxPackages;

  # For bluetooth gamepads and Nothing Phone v4l2loopback
  boot.extraModulePackages = [
    config.boot.kernelPackages.xpadneo
    config.boot.kernelPackages.v4l2loopback
  ];

  # Load V4L2 loopback at boot for NovaMicro SLAM
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModprobeConfig = ''
    options v4l2loopback exclusive_caps=1 video_nr=2 card_label="Nothing_Phone_Telephoto"
  '';

  # For persistent bluetooth
  boot.kernelParams = [ "btusb.enable_autosuspend=n" ];
  # =========================================================================

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 3000 8000 8080 8006 3389 11204 8765 ];
    allowedUDPPorts = [ 3389 8765 11204 ];
    checkReversePath = false;
  };
  networking.nameservers = [ "9.9.9.9" "149.112.112.112" ];
  networking.networkmanager.dns = "none";

  time.timeZone = "Asia/Kolkata";

  i18n.defaultLocale = "en_IN";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "en_IN/UTF-8" ];
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
  services.openssh.enable = true;
  services.udev.extraRules = ''
    KERNEL=="uinput", GROUP="video", MODE="0660", OPTIONS+="static_node=uinput"
  '';

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

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      # Bus ID from lspci: 00:02.0
      intelBusId = "PCI:0:2:0";
      # Bus ID from lspci: 02:00.0
      nvidiaBusId = "PCI:2:0:0";
    };
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

    # NEW: Wireplumber configuration to prevent sink loss
    wireplumber.extraConfig."10-bluez" = {
      "monitor.bluez.properties" = {
        "bluez5.roles" = [ "a2dp_sink" "a2dp_source" ];
        "bluez5.autoswitch-profile" =
          false; # STOP switching to low-quality mono/loopback
      };
      "monitor.bluez.rules" = [{
        matches = [{ "device.name" = "~bluez_card.*"; }];
        actions = {
          update-props = {
            "bluez5.reconnect-intervals" =
              [ 1 2 4 8 16 ]; # Aggressive reconnect
          };
        };
      }];
    };
  };
  users.users.spandan = {
    isNormalUser = true;
    description = "Spandan Roy";
    extraGroups =
      [ "networkmanager" "wheel" "kvm" "adbusers" "video" "audio" "render" ];
    shell = pkgs.zsh;
    packages = with pkgs; [ kdePackages.kate pnpm ];
  };

  users.defaultUserShell = pkgs.zsh;

  # =======================================================
  # WINDOWS : ALL HAIL BILLY G
  # =======================================================
  # Enable Podman (lighter than Docker, recommended for this)
  # virtualisation.podman = {
  #   enable = true;
  #   dockerCompat = true;
  # };
  #
  # # The Reverse-WSL Windows Backend
  # virtualisation.oci-containers.containers.winapps-backend = {
  #   image = "dockurr/windows";
  #   environment = {
  #     VERSION = "11l"; # Or "10" for slightly less overhead
  #     RAM_SIZE = "8G";
  #     CPU_CORES = "4";
  #     DISABLE_DEFENDER = "Y";
  #   };
  #   ports = [ 
  #     "8006:8006"      # Web UI for initial Office installation
  #     "3389:3389/tcp"  # RDP port for WinApps integration
  #     "3389:3389/udp"  
  #   ];
  #   volumes = [ 
  #     "/home/spandan/winapps-storage:/storage"  # CRITICAL: Saves the VM disk and ISO permanently
  #     "/home/spandan/winapps-data:/oem"  # Your zero-touch installer files
  #     "/home/spandan/WinShare:/shared"  # Native filesystem access for Office
  #   ];
  #   extraOptions = [ 
  #     "--device=/dev/kvm"   # Crucial for near-native CPU speeds
  #     "--device=/dev/net/tun"   # Crucial for network stability
  #     "--cap-add=NET_ADMIN" 
  #     "--cap-add=NET_RAW" 
  #   ];
  # };

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
      extraPackages = with pkgs; [ imagemagick xclip wl-clipboard ];
    };

    home.enableNixpkgsReleaseCheck = false;
    home.stateVersion = "24.05";
  };

  programs.firefox.enable = true;
  programs.kdeconnect.enable = true;
  nixpkgs.config.allowUnfree = true;

  # =======================================================
  # Dev Env
  # =======================================================
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Enable nix-ld
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    libGL
    libGLU
    stdenv.cc.cc
    zlib
    fuse3
    icu
    nss
    openssl
    curl
    expat
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true; # Better caching for flakes
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # =======================================================
  # Man pages
  # =======================================================

  # Add this anywhere top-level in configuration.nix
  documentation.enable = true;
  documentation.man.enable = true;
  documentation.dev.enable = true;
  documentation.man.generateCaches =
    true; # Highly recommended for apropos/searching

  # =======================================================
  # ANDROID SDK AND STUDIO SETUP
  # =======================================================
  programs.adb = { enable = true; };

  environment.systemPackages = with pkgs; [
    # ------------------------------
    # Experimental Packages
    # ------------------------------

    # ─────────────────────────────
    # Core Utilities
    # ─────────────────────────────
    tree
    wget
    zip
    unzip
    imagemagick
    wl-clipboard
    (python3.withPackages (ps: with ps; [ websockets ]))
    btrfs-progs

    # ─────────────────────────────
    # New text editor for new world
    # ─────────────────────────────
    helix
    lazygit

    # -----------------------------
    # Man Pages
    # -----------------------------
    man-pages
    man-pages-posix

    # ─────────────────────────────
    # Audio Tools
    # ─────────────────────────────
    alsa-utils

    # ─────────────────────────────
    # Terminal & CLI Enhancements
    # ─────────────────────────────
    watchexec
    fastfetch
    eza
    fzf
    zoxide
    starship
    btop
    gtop
    tmux
    jq

    # ─────────────────────────────
    # Pacakges to support virtualisation
    # ─────────────────────────────
    freerdp3
    iproute2
    libnotify

    # ─────────────────────────────
    # Editors & Shell Tools
    # ─────────────────────────────
    yazi
    (neovim.override { extraLuaPackages = ps: [ ps.magick ]; })
    tree-sitter
    luarocks
    pandoc
    texlive.combined.scheme-small
    wkhtmltopdf-bin
    flatpak

    # ─────────────────────────────
    # Version Control & Networking
    # ─────────────────────────────
    git
    github-cli

    # ─────────────────────────────
    # Build Systems & Toolchains
    # ─────────────────────────────
    nasm
    gcc
    gnumake
    appimage-run
    cmake
    pkg-config
    openssl
    llvm
    clang
    gdb # GNU Debugger
    gf # GNU Debugger Frontend
    lldb # LLVM Debugger

    # ─────────────────────────────
    # Languages & Language Servers
    # ─────────────────────────────
    rustup # rustc, cargo, rust-analyzer
    go
    nodePackages.nodejs
    lua # Lua interpreter
    lsp-ai
    ollama-cuda

    # ─────────────────────────────
    # Search & Telescope Dependencies
    # ─────────────────────────────
    ripgrep
    fd
    bat

    # ─────────────────────────────
    # GPU / CUDA
    # ─────────────────────────────
    cudaPackages.cudatoolkit

    # ------------------------------
    # Wine & Windows
    # ------------------------------
    wine
    winetricks
    samba # Gives winbindd
    dialog

    # ─────────────────────────────
    # Desktop / UI / Media
    # ─────────────────────────────
    blender
    darktable
    discord-ptb
    eww
    ffmpeg
    gimp
    google-chrome
    inkscape
    kitty
    mpv
    obs-studio
    obsidian
    protonvpn-gui
    qbittorrent
    telegram-desktop
    v4l-utils
    youtube-music
    yt-dlp

    # ─────────────────────────────
    # Terminal fun
    # ─────────────────────────────
    hollywood
    cmatrix
    cava

    # ─────────────────────────────
    # KDE Applications & Libraries
    # ─────────────────────────────
    kdePackages.qtmultimedia
    kdePackages.kdenlive
    kdePackages.filelight
    kdePackages.kamera
    kdePackages.kio-gdrive
    kdePackages.kaccounts-integration
    kdePackages.kaccounts-providers
    kdePackages.qtwebsockets

    #    # ─────────────────────────────
    #    # Hyprland
    #    # ─────────────────────────────
    hyprland
    eww

    # ─────────────────────────────
    # Android and Google Development
    # ─────────────────────────────
    android-studio
    scrcpy
    google-cloud-sdk

    # ─────────────────────────────
    # LSP Servers
    # ─────────────────────────────
    # Language Servers
    lua-language-server
    clang-tools # Contains clangd
    rust-analyzer
    gopls
    typescript-language-server
    vscode-langservers-extracted # HTML/CSS/JSON

    # Formatters
    stylua
    black
    shfmt
    prettierd
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    fira-code
    nerd-fonts.jetbrains-mono
  ];

  # =======================================================
  # SHELL CONFIGURATION
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
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        Enable = "Source,Sink,Media,Socket";
        # Prevents the controller from suspending prematurely
        FastConnectable = true;
      };
    };
  };
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

  # 1. Enable the Sunshine service and the setcap wrapper
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true; # This fixes the CAP_SYS_ADMIN error in your logs
    openFirewall = true;
    settings = { capture_method = "wayland"; };
  };

  # 2. Enable flatpak
  services.flatpak.enable = true;

  # =======================================================
  # VIDEO
  # =======================================================
  programs.droidcam = { enable = true; };

  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;

    # optional Nvidia hardware acceleration
    package = (pkgs.obs-studio.override { cudaSupport = true; });

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi # optional AMD hardware acceleration
      obs-gstreamer
      obs-vkcapture
      droidcam-obs
    ];
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
  system.autoUpgrade = {
    enable = true;
    allowReboot =
      false; # Set to true if you want it to reboot for kernel updates
  };

  nix.settings.auto-optimise-store = true; # Deduplicates files automatically
}
