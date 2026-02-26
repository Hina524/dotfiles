/*
  macOS システム設定

  system.defaultsとactivationScriptsでmacOSの設定を管理する：
  - ダークモードの有効化
  - ライブ変換の無効化
  - 電源管理（充電中：スリープなし、バッテリー時：10分でスリープ）
*/
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
