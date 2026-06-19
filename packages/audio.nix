{ pkgs, ... }:

{
  home.packages = with pkgs; [
    pavucontrol # PulseAudio volume control GUI
    qpwgraph    # PipeWire/JACK patchbay (node graph)
    easyeffects # Audio equalizer and effects for PipeWire
    pwvucontrol # Modern PipeWire volume control GUI
  ];
}
