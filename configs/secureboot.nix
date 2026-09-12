# Secure Boot via lanzaboote (desktop only).
#
# lanzaboote replaces systemd-boot's installer with one that builds a signed
# Unified Kernel Image per generation. That means it also replaces the whole
# `boot.loader.systemd-boot` config block, so anything set under that prefix
# (extraEntries, extraFiles, the `windows` chainload helper) is silently
# dropped. See the Windows note in configuration-desktop.nix.
{ config, lib, pkgs, ... }:

{
  # lanzaboote installs its own bootloader; the stock one must stand down.
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  # sbctl is what generates and enrolls the keys, and `sbctl verify` is the
  # check to run before flipping Secure Boot on in the firmware.
  environment.systemPackages = [ pkgs.sbctl ];
}
