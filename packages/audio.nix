{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # pavucontrol  # PulseAudio GUI - Removed: use pwvucontrol (PipeWire-native)
    qpwgraph       # Best PipeWire patchbay: Qt-based, saves patches, supports audio+video
    # crosspipe   # Removed: less feature-rich than qpwgraph
    easyeffects    # Audio equalizer and effects for PipeWire
    pwvucontrol    # PipeWire-native volume control GUI (better than pavucontrol for PipeWire)
  ];
}
