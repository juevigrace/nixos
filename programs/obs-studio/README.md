# OBS Studio

This module installs OBS Studio with the plugins used for horizontal
multistreaming and a vertical layout:

- Aitum Multistream for additional horizontal destinations
- Aitum Vertical Canvas for the 1080x1920 canvas
- PipeWire screen/audio capture
- Vulkan/OpenGL game capture
- Source Record (for optional per-source recordings)

The Home Manager activation seeds a `Streaming` profile and scene collection
only when the corresponding files do not already exist. OBS keeps writing to
those files normally after the first activation, so later rebuilds do not
overwrite changes made in the OBS UI.

## First launch

1. Start OBS.
2. The starting scene is **Starting Soon**. Switch to **Main** and approve the
   PipeWire screen-capture dialog the first time. The **Display Capture**
   source will remember the selected monitor after that.
3. Check **Audio Mixer**: `Desktop Audio` and `Microphone` use the default
   PipeWire/PulseAudio devices. Change them in the source properties if needed.

## Horizontal stream keys

The main OBS output is configured for Twitch. This is the encoder that Aitum
reuses for the other horizontal outputs, so start the main OBS stream first.

1. Open **Settings -> Stream**, paste the Twitch stream key, and apply.
2. Open the **Aitum Multistream** dock and paste the keys for **Kick**,
   **YouTube**, and **TikTok**.
3. Start OBS streaming (Twitch), then start the Kick, YouTube, and TikTok
   buttons in the Aitum dock.

The Aitum entries are intentionally seeded with empty keys. Never commit a
stream key to this repository. OBS stores them in:

- `~/.config/obs-studio/basic/profiles/Streaming/service.json`
- `~/.config/obs-studio/plugin_config/aitum-multistream/config.json`

TikTok's horizontal ingest URL is account-specific, so its Aitum entry starts
with an empty server URL. Copy the URL and key from TikTok LIVE Center into the
Aitum entry.

## Vertical layout

The **Aitum Vertical** dock starts with a `1080x1920` canvas, a default
`Vertical Scene`, and a TikTok destination. Add the sources you want to the
vertical scene, then enter the TikTok server URL and key in the vertical
canvas settings. The vertical settings are stored in:

- `~/.config/obs-studio/plugin_config/vertical-canvas/config.json`

Vertical streaming is not started automatically; use the vertical dock's
stream button after the main stream is running.

## Bandwidth and encoding

The seeded horizontal output is 1920x1080 at 60 fps, 6000 kbps video and
160 kbps audio. Aitum sends one encoded video stream to three additional
destinations, so four horizontal destinations use roughly 24 Mbps upload.
The vertical canvas adds another roughly 6 Mbps when enabled. Lower the
bitrate in **Settings -> Output** if the connection cannot sustain that.
Recording uses the main horizontal output; the vertical canvas is not
recorded by default.

The simple output mode requests NVIDIA NVENC (H.264). If NVENC is unavailable
on a machine, change **Settings -> Output -> Video Encoder** to `x264`; the
scene/profile seed remains valid.

## Re-seeding

The activation never overwrites existing OBS files. To start over from these
seeds (this deletes all OBS settings and scenes), quit OBS and run:

```sh
rm -rf ~/.config/obs-studio
./scripts/rebuild
```

Back up anything you want to keep from `~/.config/obs-studio` first.
