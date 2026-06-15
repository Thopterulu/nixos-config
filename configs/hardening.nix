# Gaming-safe ANSSI-inspired hardening.
# Pulls the subset of ANSSI R8–R14 sysctls that do not break Steam/Proton,
# Nvidia, controllers, hotplug, or Wine. CPU-side mitigations are intentionally
# omitted because configuration-desktop.nix sets `mitigations=off` for perf.
{ config, lib, pkgs, ... }:

{
  boot.kernel.sysctl = {
    # R9 — kernel info hiding & misc hardening
    "kernel.dmesg_restrict"            = 1;
    "kernel.kptr_restrict"             = 2;
    "kernel.randomize_va_space"        = 2;
    "kernel.unprivileged_bpf_disabled" = 1;
    "kernel.perf_event_paranoid"       = 1;   # ANSSI says 2; 1 keeps RenderDoc/MangoHud working
    "kernel.yama.ptrace_scope"         = 1;   # parent-only ptrace; Wine/Proton still work
    "kernel.sysrq"                     = 16;  # keep emergency sync/reboot; drop the rest

    # R12 — IPv4 hardening (no gaming impact)
    "net.ipv4.conf.all.accept_redirects"         = 0;
    "net.ipv4.conf.default.accept_redirects"     = 0;
    "net.ipv4.conf.all.secure_redirects"         = 0;
    "net.ipv4.conf.default.secure_redirects"     = 0;
    "net.ipv4.conf.all.send_redirects"           = 0;
    "net.ipv4.conf.default.send_redirects"       = 0;
    "net.ipv4.conf.all.rp_filter"                = 1;
    "net.ipv4.conf.default.rp_filter"            = 1;
    "net.ipv4.tcp_rfc1337"                       = 1;
    "net.ipv4.tcp_syncookies"                    = 1;
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
    "net.core.bpf_jit_harden"                    = 2;

    # R14 — filesystem protections
    "fs.suid_dumpable"       = 0;
    "fs.protected_fifos"     = 2;
    "fs.protected_regular"   = 2;
    "fs.protected_symlinks"  = 1;
    "fs.protected_hardlinks" = 1;
  };

  # Skipped on purpose for gaming:
  #   kernel.modules_disabled  -> breaks controller/VR hotplug
  #   kernel.panic_on_oops     -> Nvidia oops -> reboot mid-game
  #   net.ipv6.disable_ipv6    -> breaks modern multiplayer
  #   mds=nosmt, l1tf=force    -> kills hyperthreading
  #   linuxPackages_hardened   -> breaks Nvidia + Steam Runtime user namespaces

  boot.kernelParams = [
    "slab_nomerge"
    "page_alloc.shuffle=1"
    "iommu=pt"
    "intel_iommu=on"
  ];
}
