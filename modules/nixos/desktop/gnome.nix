{ pkgs, ... }:
{
  services = {
    xserver = {
      enable = true;

      xkb = {
        variant = "";
        layout = "us";
      };

      excludePackages = [ pkgs.xterm ];

      displayManager.gdm = {
        enable = true;
        autoSuspend = false;
      };

      desktopManager.gnome = {
        enable = true;

        extraGSettingsOverrides = ''
          [org.gnome.desktop.background]
          picture-uri='file://${pkgs.nixos-artwork.wallpapers.nineish.gnomeFilePath}'

          [org.gnome.desktop.background]
          picture-uri-dark='file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath}'

          [org.gnome.desktop.interface]
          color-scheme='prefer-dark'

          [org.gnome.shell]
          favorite-apps=['org.gnome.Nautilus.desktop', 'org.gnome.SystemMonitor.desktop', 'org.gnome.Console.desktop', 'org.gnome.gitg.desktop', 'org.gnome.Builder.desktop', 'org.gnome.Polari.desktop']

          [org.gnome.shell]
          disable-user-extensions=false

          [org.gnome.shell]
          enabled-extensions=['user-theme@gnome-shell-extensions.gcampax.github.com', 'dash-to-dock@micxgx.gmail.com', 'appindicatorsupport@rgcjonas.gmail.com', 'light-style@gnome-shell-extensions.gcampax.github.com', 'system-monitor@gnome-shell-extensions.gcampax.github.com']

          [org.gnome.mutter]
          dynamic-workspaces=true

          [org.gnome.mutter]
          edge-tiling=true

          [org.gnome.desktop.interface]
          icon-theme='Papirus-Dark'

          [org.gnome.desktop.datetime]
          automatic-timezone=true

          [org.gnome.tweaks]
          show-extensions-notice=false

          [org.gnome.desktop.wm.preferences]
          button-layout='appmenu:minimize,maximize,close'

          [org.gnome.desktop.interface]
          monospace-font-name='JetBrainsMono Nerd Font 10'

          [org.gnome.shell.extensions.dash-to-dock]
          multi-monitor=true

          [org.gnome.shell.extensions.dash-to-dock]
          apply-custom-theme=true

          [org.gnome.settings-daemon.plugins.power]
          sleep-inactive-ac-type='nothing'

          [org.gnome.desktop.session]
          idle-delay=0
        '';

        extraGSettingsOverridePackages = [
          pkgs.gsettings-desktop-schemas
          pkgs.gnome-shell
        ];
      };
    };

    udev.packages = [ pkgs.gnome-settings-daemon ];
  };

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    dconf.enable = true;
    seahorse.enable = true;
  };

  environment = {
    variables = {
      WEBKIT_DISABLE_COMPOSITING_MODE = 1;
    };

    gnome.excludePackages = with pkgs; [
      xterm
      firefox
      epiphany
      tali
      iagno
      hitori
      atomix
    ];

    systemPackages = with pkgs; [
      # GNOME apps
      gitg
      lorem
      emblem
      commit
      mousai
      polari
      amberol
      blanket
      curtail
      elastic
      errands
      dialect
      komikku
      decibels
      citations
      newsflash
      collision
      fragments
      apostrophe
      eyedropper
      impression
      textpieces
      letterpress
      forge-sparks
      gnome-graphs
      share-preview
      authenticator
      gnome-decoder
      gnome-secrets
      gnome-obfuscate
      resources

      # Developer
      gnome-boxes
      gnome-builder
      d-spy
      devhelp
      sysprof

      # Modding
      dconf-editor
      gnome-tweaks

      # Extensions
      gnomeExtensions.appindicator
      gnomeExtensions.dash-to-dock
      gnomeExtensions.gsconnect

      # Icons
      papirus-icon-theme

      # Office
      libreoffice-fresh

      # VPN
      mullvad-vpn
      mullvad
    ];
  };
}
