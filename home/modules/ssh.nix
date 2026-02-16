{ config, pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    '';
    matchBlocks = {
      "sshgate.u-aizu.ac.jp" = {
        hostname = "sshgate.u-aizu.ac.jp";
        user = "s1310141";
      };
      "cad" = {
        hostname = "cadsv214";
        user = "s1310141";
        proxyCommand = "ssh -W %h:%p sshgate.u-aizu.ac.jp";
      };
    };
  };
}
