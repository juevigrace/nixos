{
  lib,
  pkgs,
  ...
}: let
  seed = ./seed;
in {
  # OBS Studio plus the plugins used for multistreaming and vertical output.
  # The actual stream keys are never stored in this repository; see README.md
  # in this directory for the one-time setup steps.
  programs.obs-studio = {
    enable = true;

    # OBS probes NVENC by running obs-nvenc-test in a child process. The OBS
    # wrapper in nixpkgs does not add the NVIDIA driver library directory to
    # LD_LIBRARY_PATH, so the probe cannot find libnvidia-encode.so.1 and NVENC
    # silently falls back to x264. Add the NixOS driver path to the wrapper;
    # OBS appends its own paths after this and the child process inherits it.
    package = pkgs.symlinkJoin {
      name = "obs-studio-with-nvenc";
      paths = [pkgs.obs-studio];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        mv "$out/bin/obs" "$out/bin/.obs-nvenc-unwrapped"

        # Discord detects OBS for its automatic Streamer Mode by scanning
        # /proc/<pid>/cmdline. Without --argv0 the wrapper would expose the
        # renamed ".obs-nvenc-unwrapped" binary instead of "obs".
        makeWrapper "$out/bin/.obs-nvenc-unwrapped" "$out/bin/obs" \
          --argv0 obs \
          --suffix LD_LIBRARY_PATH : /run/opengl-driver/lib
      '';
    };

    plugins = with pkgs.obs-studio-plugins; [
      obs-aitum-multistream
      obs-vertical-canvas
      obs-pipewire-audio-capture
      obs-vkcapture
      obs-source-record
    ];
  };

  # OBS normally creates its configuration on first launch. Seed a useful
  # profile, scene collection, and Aitum configuration for fresh installs,
  # while never overwriting files that OBS (or the user) already owns.
  home.activation.obsStudioSeed = lib.hm.dag.entryAfter ["writeBoundary"] ''
    cfg="$HOME/.config/obs-studio"
    profile="$cfg/basic/profiles/Streaming"
    scenes="$cfg/basic/scenes"

    mkdir -p \
      "$profile" \
      "$scenes" \
      "$cfg/plugin_config/aitum-multistream" \
      "$cfg/plugin_config/vertical-canvas" \
      "$HOME/Videos"

    if [ ! -e "$cfg/user.ini" ]; then
      install -m 0644 ${seed}/user.ini "$cfg/user.ini"
    fi

    if [ ! -e "$profile/basic.ini" ]; then
      ${pkgs.gnused}/bin/sed "s|@HOME@|$HOME|g" ${seed}/basic.ini > "$profile/basic.ini"
      chmod 0644 "$profile/basic.ini"
    fi

    if [ ! -e "$profile/service.json" ]; then
      install -m 0644 ${seed}/service.json "$profile/service.json"
    fi

    if [ ! -e "$scenes/Streaming.json" ]; then
      install -m 0644 ${seed}/scene.json "$scenes/Streaming.json"
    fi

    if [ ! -e "$cfg/plugin_config/aitum-multistream/config.json" ]; then
      install -m 0644 ${seed}/aitum-multistream.json "$cfg/plugin_config/aitum-multistream/config.json"
    fi

    if [ ! -e "$cfg/plugin_config/vertical-canvas/config.json" ]; then
      install -m 0644 ${seed}/vertical-canvas.json "$cfg/plugin_config/vertical-canvas/config.json"
    fi
  '';
}
