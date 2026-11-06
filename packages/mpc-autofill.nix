# FHS sandbox for the MPC Autofill desktop tool (autofill-linux.bin).
#
# Why this exists: the tool is a Nuitka onefile that drives a Chromium-family
# browser through Selenium. It needs a browser it can discover at an FHS path,
# plus a loader for the chromedriver it downloads at runtime; `steam-run` has
# neither. buildFHSEnv builds a root where both genuinely resolve.
#
# Brave is NOT an option, for two independent reasons:
#
#   1. It was removed from nixpkgs ("no committers among its maintainers to
#      unblock security issues"), so there is nothing left to put in the FHS.
#   2. Even when it was available it crashed: src/webdrivers.py:get_brave_driver
#      hardcodes the binary as "/usr/bin/brave-browser" (overridable only via a
#      `binary_location` parameter the CLI never exposes), and ChromeDriver
#      passes --test-type=webdriver on every launch, which made Brave 1.93 die
#      with SIGTRAP (a Chromium CHECK failure) before the DevTools port opened
#      — the "window opens and immediately closes" symptom. Bisected against
#      the exact ChromeDriver command line: every other automation flag
#      (--remote-debugging-port, --enable-logging, --enable-automation,
#      --password-store=basic) ran fine alone; adding --test-type=webdriver
#      crashed it every time, with or without this FHS.
#
# So PICK "chrome" AT THE TOOL'S BROWSER PROMPT. Choosing "brave" now fails
# with {'code': 65, 'message': 'Browser path does not exist:
# /usr/bin/brave-browser'} rather than the crash above.
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
  mpc-autofill-env = pkgs.buildFHSEnv {
    name = "mpc-autofill-env";
    targetPkgs = p: (with p; [
      # Chrome is the easy target: src/webdrivers.py hardcodes a binary path
      # ONLY for Brave. get_chrome_driver leaves binary_location unset and lets
      # Selenium Manager discover the browser, which it does at
      # /usr/bin/google-chrome-stable inside this FHS.
      google-chrome

      # Selenium Manager downloads a chromedriver matching the browser's
      # Chromium build at runtime and caches it in ~/.cache/selenium.
      # Deliberately NOT pinning pkgs.chromedriver here: a version skew against
      # whatever Chrome ships is a harder failure than letting Selenium fetch
      # its own match. The download only becomes runnable because of this FHS.
      cacert
      curl

      # Shared libraries for that DOWNLOADED chromedriver specifically. It is a
      # foreign binary with no RPATH, so unlike the nix-wrapped browsers (which
      # resolve their own deps) it can only link against what this FHS provides.
      # Without these it dies with exit status 127 — which Selenium reports as
      # the useless "Service ... unexpectedly exited. Status code was: 127".
      # This exact list is `ldd`-derived, not guesswork:
      glib   # libglib-2.0.so.0
      nspr   # libnspr4.so
      nss    # libnss3.so, libnssutil3.so
      libxcb # libxcb.so.1 (top-level; xorg.libxcb is deprecated in 26.05)
      dbus   # libdbus-1.so.3

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
