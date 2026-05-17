{ pkgs, ... }:

{
  home.packages = with pkgs; [
    pavucontrol # PulseAudio volume control GUI
    helvum      # PipeWire patchbay (node graph)
    qpwgraph    # PipeWire/JACK patchbay (alternative to helvum)
    easyeffects # Audio equalizer and effects for PipeWire
    pwvucontrol # Modern PipeWire volume control GUI
  ];
}
