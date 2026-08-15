# FHS sandbox for the MPC Autofill desktop tool (autofill-linux.bin).
#
# Why this exists: the tool is a Nuitka onefile that drives a Chromium-family
# browser through Selenium. Its src/webdrivers.py:get_brave_driver hardcodes the
# Brave binary as "/usr/bin/brave-browser" on Linux. Verified against upstream
# master: the path is only overridable via a `binary_location` function
# parameter that the CLI never exposes — there is no env var and no flag.
#
# On NixOS that path cannot exist: /usr/bin holds only `env`, and nixpkgs ships
# Brave as `brave`, never `brave-browser`. The tool therefore dies with
#   {'code': 65, 'message': 'Browser path does not exist: /usr/bin/brave-browser'}
#   selenium.common.exceptions.NoSuchDriverException: Unable to obtain driver
# `steam-run` gets the binary running but does NOT fix this — its FHS has no
# Brave in it, so the hardcoded path is still absent.
#
# buildFHSEnv is the only thing that satisfies a hardcoded absolute path: it
# builds a root where /usr/bin/brave-browser genuinely resolves.
#
# Usage, replacing `steam-run ./autofill-linux.bin` — cd to the directory
# holding the .bin and its XML first:
#
#   mpc-autofill-env                    # interactive FHS shell, then ./autofill-linux.bin
#   mpc-autofill-env -c ./autofill-linux.bin
#
# NOT `mpc-autofill-env ./autofill-linux.bin`. runScript is bash, so a bare
# argument is read as a shell *script* rather than executed; the ELF would be
# fed to the parser as text. The -c form runs it as a command.

{ pkgs, ... }:

let
  # nixpkgs' brave provides bin/brave only. Mint the name upstream demands.
  brave-browser-alias = pkgs.runCommand "brave-browser-alias" { } ''
    mkdir -p $out/bin
    ln -s ${pkgs.brave}/bin/brave $out/bin/brave-browser
  '';

  mpc-autofill-env = pkgs.buildFHSEnv {
    name = "mpc-autofill-env";
    targetPkgs = p: (with p; [
      brave
      brave-browser-alias

      # Selenium Manager downloads a chromedriver matching Brave's Chromium
      # build at runtime and caches it in ~/.cache/selenium. Deliberately NOT
      # pinning pkgs.chromedriver here: a version skew against whatever Brave
      # ships is a harder failure than letting Selenium fetch its own match.
      # The download only runs because this FHS makes the result executable.
      cacert
      curl

      # Nuitka onefile unpacks to /tmp and dlopen()s against the FHS, so the
      # generic runtime has to be present rather than left to the binary's
      # (nonexistent) RPATH.
      glibc
      zlib
      openssl
      libxml2
      libxslt
      stdenv.cc.cc.lib
    ]);
    runScript = "bash";
  };
in
{
  home.packages = [ mpc-autofill-env ];
}
