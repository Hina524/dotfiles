/*
  SSH 接続設定

  大学サーバーへのSSH接続を管理する：
  - sshgate.u-aizu.ac.jp: 踏み台サーバー
  - cad: sshgate経由のProxyCommand接続
*/
{ config, pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "sshgate.u-aizu.ac.jp" = {
        hostname = "sshgate.u-aizu.ac.jp";
        user = "s1310141";
        identityFile = "~/.ssh/id_ed25519";
      };
      "cad" = {
        hostname = "cadsv214";
        user = "s1310141";
        identityFile = "~/.ssh/id_ed25519";
        proxyCommand = "ssh -W %h:%p sshgate.u-aizu.ac.jp";
      };
    };
  };
}
