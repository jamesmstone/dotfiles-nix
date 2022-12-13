{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.docker;
    configDir = config.dotfiles.configDir;
in {
  options.modules.services.yubico = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ pkgs.yubikey-personalization ];

    # Depending on the details of your configuration, this section might be necessary or not;
    # feel free to experiment
    environment.shellInit = ''
      export GPG_TTY="$(tty)"
      gpg-connect-agent /bye
      export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
    '';

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    user.packages = with pkgs; [
      yubioath-flutter
    ];
#
#    env.DOCKER_CONFIG = "$XDG_CONFIG_HOME/docker";
#    env.MACHINE_STORAGE_PATH = "$XDG_DATA_HOME/docker/machine";
#
#    user.extraGroups = [ "docker" ];
#
#    modules.shell.zsh.rcFiles = [ "${configDir}/docker/aliases.zsh" ];

#    virtualisation = {
#      docker = {
#        enable = true;
#        autoPrune.enable = true;
#        enableOnBoot = mkDefault false;
#        # listenOptions = [];
#      };
#    };
  };
}
