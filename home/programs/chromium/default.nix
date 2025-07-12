{
  programs.chromium = {
    enable = true;
   
    commandLineArgs = [
        "--enable-features=WebRTCPipeWireCapturer"
        "--ozone-platform-hint=auto"
        "--enable-webrtc-pipewire-capturer"
   ];
  };
}
