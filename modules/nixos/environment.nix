{ ... }: {
  environment.sessionVariables = {
    EDITOR = "nvim";

    # Keep compiled shaders between game launches. This removes a large part
    # of the first-run stutter, especially with Proton/DXVK.
    __GL_SHADER_DISK_CACHE = "1";
    __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";
    MESA_SHADER_CACHE_MAX_SIZE = "12G";
  };
}
