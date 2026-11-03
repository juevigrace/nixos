{pkgs, ...}: {
  hardware.graphics = {
    enable = true;

    # Vulkan loader for native Vulkan applications. The NVIDIA/Mesa ICDs are
    # already added by the graphics and NVIDIA modules; only the loader was
    # missing from /run/opengl-driver/lib.
    extraPackages = with pkgs; [
      vulkan-loader
    ];

    # 32-bit loader for Steam/Proton; programs.steam sets enable32Bit.
    extraPackages32 = with pkgs.pkgsi686Linux; [
      vulkan-loader
    ];
  };
}
