{ config, pkgs, ... }:
{
  system.defaults = {
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
    CustomUserPreferences = {
      "com.apple.inputmethod.Kotoeri" = {
        JIMPrefLiveConversionKey = false;
      };
    };
  };

  system.activationScripts.postActivation.text = ''
    # 充電中はディスプレイスリープしない
    pmset -c displaysleep 0
    # バッテリー時は10分でスリープ
    pmset -b displaysleep 10
  '';
}
