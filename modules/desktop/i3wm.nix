{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.i3wm;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.i3wm = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
#    modules.theme.onReload.bspwm = ''
#      ${pkgs.bspwm}/bin/bspc wm -r
#      source $XDG_CONFIG_HOME/bspwm/bspwmrc
#    '';

    environment.systemPackages = with pkgs; [
      lightdm
      dunst
      libnotify
      (polybar.override {
        pulseSupport = true;
        nlSupport = true;
      })
    ];

    services = {
      picom.enable = true;
      redshift.enable = true;
      xrdp.enable = true;

      xserver = {
        enable = true;
        displayManager = {
          defaultSession = "none+i3";
          lightdm.enable = true;
          lightdm.greeters.mini.enable = true;
        };
        windowManager.i3.enable = true;
      };
    };

    systemd.user.services."dunst" = {
      enable = true;
      description = "";
      wantedBy = [ "default.target" ];
      serviceConfig.Restart = "always";
      serviceConfig.RestartSec = 2;
      serviceConfig.ExecStart = "${pkgs.dunst}/bin/dunst";
    };

    # link recursively so other modules can link files in their folders
    home.configFile = {
      "sxhkd".source = "${configDir}/sxhkd";
#      "bspwm" = {
#        source = "${configDir}/bspwm";
#        recursive = true;
#      };
    };
  };
}
