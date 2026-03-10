{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    polkit
    kdePackages.polkit-kde-agent-1
    kdePackages.polkit-qt-1
  ];

  security.polkit.enable = true;

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if ((action.id == "org.corectrl.helper.init" ||
           action.id == "org.corectrl.helperkiller.init" ||
           action.id == "org.corectrl.cpufreq.set") &&
          subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';
}
