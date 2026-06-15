# Gaming-safe ANSSI-inspired hardening.
# Pulls the subset of ANSSI R8–R14 sysctls that do not break Steam/Proton,
# Nvidia, controllers, hotplug, or Wine. CPU-side mitigations are intentionally
# omitted because configuration-desktop.nix sets `mitigations=off` for perf.
{ config, lib, pkgs, ... }:

{
  boot.kernel.sysctl = {
    # R9 — kernel info hiding & misc hardening
    # Restrict `dmesg` to CAP_SYSLOG/root so non-root users can't read the kernel log
    # (kernel log lines can leak addresses, stack traces, and other ASLR-defeating info).
    "kernel.dmesg_restrict"            = 1;
    # Hide kernel pointers in /proc/* from everyone (including root) — defeats trivial
    # KASLR bypass techniques (kallsyms, /proc/kallsyms, /proc/modules, etc.).
    "kernel.kptr_restrict"             = 2;
    # Full ASLR: randomize stack, heap (brk), mmap base, and shared library load addresses
    # on every exec. Default on most distros but pinned explicitly here.
    "kernel.randomize_va_space"        = 2;
    # Forbid unprivileged users from calling bpf() — kills a huge attack surface
    # (Spectre v1/v2/v4 gadgets, kernel JIT exploits, container escapes).
    "kernel.unprivileged_bpf_disabled" = 1;
    # perf_event_open restriction level. 0=unrestricted, 1=no kernel tracepoints,
    # 2=no CPU events, 3=no perf at all. We pick 1: blocks ring-0 introspection
    # but still allows userspace CPU profiling.
    "kernel.perf_event_paranoid"       = 1;   # ANSSI says 2; 1 keeps RenderDoc/MangoHud working
    # Yama ptrace scope. 0=any process can ptrace any other (dangerous),
    # 1=only direct ancestors, 2=only with CAP_SYS_PTRACE, 3=disabled entirely.
    # Level 1 lets a debugger attach to a process it spawned (Wine/Proton/gdb work).
    "kernel.yama.ptrace_scope"         = 1;   # parent-only ptrace; Wine/Proton still work
    # Magic SysRq bitmask: 1=loglevel, 2=keyboard, 4=console, 8=debug-dumps,
    # 16=sync, 32=remount-RO, 64=signal-processes, 128=reboot, 256=nice-RT.
    # 16 alone enables only Alt+SysRq+S (sync) — not reboot. Set to 240 if you also
    # want the classic R-E-I-S-U-B emergency reboot sequence.
    "kernel.sysrq"                     = 16;  # keep emergency sync/reboot; drop the rest

    # R12 — IPv4 hardening (no gaming impact)
    # Ignore ICMP redirects on all interfaces — prevents an attacker on the LAN
    # from rerouting your traffic through their host (classic MITM).
    "net.ipv4.conf.all.accept_redirects"         = 0;
    # Same as above, applied to interfaces brought up after boot.
    "net.ipv4.conf.default.accept_redirects"     = 0;
    # Ignore "secure" ICMP redirects too (those claiming to come from your default
    # gateway) — they're trivially spoofable on a switched LAN.
    "net.ipv4.conf.all.secure_redirects"         = 0;
    "net.ipv4.conf.default.secure_redirects"     = 0;
    # Don't emit ICMP redirects ourselves — only meaningful on routers, but harmless
    # to disable on an endpoint and removes a small info-leak.
    "net.ipv4.conf.all.send_redirects"           = 0;
    "net.ipv4.conf.default.send_redirects"       = 0;
    # Strict reverse-path filtering: drop incoming packets whose source IP couldn't
    # legitimately route back through the receiving interface. Blocks most IP spoofing.
    "net.ipv4.conf.all.rp_filter"                = 1;
    "net.ipv4.conf.default.rp_filter"            = 1;
    # RFC 1337: drop TIME_WAIT assassination RSTs — defeats a stale-connection
    # tear-down attack against long-lived TCP sessions.
    "net.ipv4.tcp_rfc1337"                       = 1;
    # SYN cookies: under SYN-flood pressure, the kernel synthesizes a cookie instead
    # of allocating a half-open socket — protects against SYN-flood DoS.
    "net.ipv4.tcp_syncookies"                    = 1;
    # Don't reply to broadcast/multicast ICMP that elicits "bogus error" responses —
    # cuts down on Smurf-style amplification participation.
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
    # Harden the eBPF JIT against Spectre-style speculation gadgets (constant
    # blinding, randomized JIT addresses). 0=off, 1=privileged users, 2=everyone.
    "net.core.bpf_jit_harden"                    = 2;

    # R14 — filesystem protections
    # Disable core dumps for setuid/setgid binaries (and after a uid change) — those
    # dumps would otherwise contain privileged memory readable by the unprivileged owner.
    "fs.suid_dumpable"       = 0;
    # Prevent opening FIFOs and regular files in world-/group-writable sticky dirs
    # (e.g. /tmp) if they're owned by someone else — blocks classic /tmp symlink/race
    # attacks on FIFOs and regular files.
    "fs.protected_fifos"     = 2;
    "fs.protected_regular"   = 2;
    # Followers of symlinks in world-writable sticky dirs must be the symlink owner
    # (or the dir owner) — blocks the canonical /tmp symlink-race privilege escalation.
    "fs.protected_symlinks"  = 1;
    # Don't let users hard-link to files they can't read/write — closes a class of
    # bugs where a hardlink would grant later access to a file you no longer should see.
    "fs.protected_hardlinks" = 1;
  };

  # Skipped on purpose for gaming:
  #   kernel.modules_disabled  -> breaks controller/VR hotplug
  #   kernel.panic_on_oops     -> Nvidia oops -> reboot mid-game
  #   net.ipv6.disable_ipv6    -> breaks modern multiplayer
  #   mds=nosmt, l1tf=force    -> kills hyperthreading
  #   linuxPackages_hardened   -> breaks Nvidia + Steam Runtime user namespaces

  boot.kernelParams = [
    # Don't merge slab caches of the same size into one — keeps allocations of
    # different kernel object types in separate caches, which makes heap-spray
    # and use-after-free exploits much harder to land.
    "slab_nomerge"
    # Shuffle the free page list at boot — randomizes the order in which physical
    # pages are handed out, denying attackers a predictable physical layout to
    # target with Rowhammer / heap-massaging primitives.
    "page_alloc.shuffle=1"
    # IOMMU passthrough for trusted devices: the IOMMU stays available (so VFIO /
    # PCI passthrough still works) but skips DMA translation overhead for the host's
    # own devices. Practical tradeoff — keeps the IOMMU available without the perf hit.
    "iommu=pt"
    # Turn on Intel VT-d at boot so the IOMMU actually exists. Needed for `iommu=pt`
    # to do anything, and required for any future DMA-attack mitigation or VFIO use.
    "intel_iommu=on"
  ];
}
