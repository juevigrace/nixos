{ config, pkgs, ... }: {
  # Use an Android phone as a USB webcam for OBS and other applications.
  #
  # Do not enable programs.droidcam here: it adds the stock v4l2loopback to
  # boot.extraModulePackages, and we need the patched package below instead.
  # This is otherwise equivalent to what the NixOS module does.
  environment.systemPackages = [ pkgs.droidcam ];
  boot.kernelModules = ["v4l2loopback" "snd-aloop"];

  # Keep DroidCam on a predictable loopback device instead of letting it take
  # whichever /dev/video* happens to be free. The OBS scene uses /dev/video10.
  # If OBS's own virtual camera is enabled later, give it a second device.
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=10 card_label="DroidCam" exclusive_caps=1
  '';

  # v4l2loopback 0.15.4 installs its own modules.alias/modules.dep database,
  # which conflicts with the kernel's database when NixOS merges
  # boot.extraModulePackages. Keep the module but drop the generated indexes;
  # the kernel's depmod database is the authoritative one.
  #
  # This must be a plain list assignment. Never use lib.mkForce here: this
  # option is shared with hardware.nvidia, and forcing it drops nvidia.ko from
  # the system, leaving niri with no usable DRM device and a frozen screen.
  boot.extraModulePackages = [
    (config.boot.kernelPackages.v4l2loopback.overrideAttrs (old: {
      postInstall = (old.postInstall or "") + ''
        rm -f $out/lib/modules/${config.boot.kernelPackages.kernel.modDirVersion}/modules.*
      '';
    }))
  ];
}
