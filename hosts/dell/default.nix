{ pkgs, config, lib, ... }:
{
  imports = [
    ../home.nix
    ./hardware-configuration.nix
  ];


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Configure keymap in X11
  services.xserver = {
    libinput.enable = true;
    layout = "au";
    xkbVariant = "";
  };

  ## Modules
  modules = {
    hardware = {
      bluetooth.enable = true;
      audio.enable = true;
  #    ergodox.enable = true;
  #    fs = {
  #      enable = true;
  #      ssd.enable = true;
  #    };
#      nvidia.enable = true;
#      sensors.enable = true;
    };
    desktop = {
#      awesomewm.enable = true;
#      bspwm.enable = true;
      i3wm.enable = true;
      apps = {
        rofi.enable = true;
        # godot.enable = true;
      };
      browsers = {
        default = "brave";
        brave.enable = true;
        firefox.enable = true;
        qutebrowser.enable = true;
      };
      gaming = {
#        steam.enable = true;
        # emulators.enable = true;
        # emulators.psx.enable = true;
      };
      media = {
 #       daw.enable = true;
#        documents.enable = true;
#        graphics.enable = true;
#        mpv.enable = true;
        recording.enable = true;
        spotify.enable = true;
      };
      term = {
        default = "xst";
        st.enable = true;
      };
      vm = {
        qemu.enable = true;
      };
    };
    dev = {
      node.enable = true;
   #   rust.enable = true;
  #    python.enable = true;
        cc.enable = true;
    };
    work = {
      enable = true;
    };
    editors = {
      default = "nvim";
      idea.enable = true;
      emacs = {
       enable = true;
       doom.enable = true;
       doom.repoUrl = "https://:@github.com/doomemacs/doomemacs";
       doom.configRepoUrl = "https://:@github.com/jamesmstone/.doom";
      };
      vim.enable = true;
    };
    shell = {
      adl.enable = true;
#      vaultwarden.enable = true;
      direnv.enable = true;
      git.enable    = true;
      gnupg.enable  = true;
      tmux.enable   = true;
      zsh.enable    = true;
    };
    services = {
      yubico.enable = true;
#      ssh.enable = true;
      docker.enable = true;
      tailscale.enable = true;
      # Needed occasionally to help the parental units with PC problems
      # teamviewer.enable = true;
    };
    theme.active = "alucard";
  };


#  ## Local config
#  programs.ssh.startAgent = true;
#  services.openssh.startWhenNeeded = true;

  # Power management
  environment.systemPackages = [ pkgs.acpi ];
  powerManagement.powertop.enable = true;
  # Monitor backlight control
  programs.light.enable = true;
  user.extraGroups = [ "video" ];

  networking.networkmanager.enable = true;

  # Without this wpa_supplicant may fail to auto-discover wireless interfaces at
  # startup (and must be restarted).
#  networking.wireless.interfaces = [ "wlp2s0" ];



#  networking.wireless.enable = true;
    hardware.opengl.enable = true;

  user.packages = with pkgs; [
    mosh
    flameshot
  ];
  ## Personal backups
  # Syncthing is a bit heavy handed for my needs, so rsync to my NAS instead.
  /*systemd = {
    services.backups = {
      description = "Backup /usr/store to NAS";
      wants = [ "usr-drive.mount" ];
      path  = [ pkgs.rsync ];
      environment = {
        SRC_DIR  = "/usr/store";
        DEST_DIR = "/usr/drive";
      };
      script = ''
        rcp() {
          if [[ -d "$1" && -d "$2" ]]; then
            echo "---- BACKUPING UP $1 TO $2 ----"
            rsync -rlptPJ --chmod=go= --delete --delete-after \
                --exclude=lost+found/ \
                --exclude=@eaDir/ \
                --include=.git/ \
                --filter=':- .gitignore' \
                --filter=':- $XDG_CONFIG_HOME/git/ignore' \
                "$1" "$2"
          fi
        }
        rcp "$HOME/projects/" "$DEST_DIR/projects"
        rcp "$SRC_DIR/" "$DEST_DIR"
      '';
      serviceConfig = {
        Type = "oneshot";
        Nice = 19;
        IOSchedulingClass = "idle";
        User = config.user.name;
        Group = config.user.group;
      };
    };
    timers.backups = {
      wantedBy = [ "timers.target" ];
      partOf = [ "backups.service" ];
      timerConfig.OnCalendar = "*-*-* 00,12:00:00";
      timerConfig.Persistent = true;
    };
  };*/
}
