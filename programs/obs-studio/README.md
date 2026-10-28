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
   source feeds both the horizontal and vertical Main scenes and will remember
   the selected monitor after that.
3. In the **Aitum Vertical** dock, confirm the scene list contains
   **Starting Soon (Vertical)**, **Main (Vertical)**, **BRB (Vertical)**, and
   **Ending (Vertical)**. Switching the main scene should switch the vertical
   scene through the linked-scene button.
4. Check **Audio Mixer**: `Desktop Audio` and `Microphone` use the default
   PipeWire/PulseAudio devices. Change them in the source properties if needed.

## Voice filters

The **Microphone** source has an OBS-only filter chain:

1. **Gain** at `-6 dB`
2. **Noise Suppression** using RNNoise
3. **Expander** for gentle gating between phrases
4. **Compressor** for consistent loudness
5. **Limiter** for peak protection

The OBS mic fader stays at `0 dB`; adjust the **Gain** filter first if speech
is too quiet or too loud. If breathing is still audible in the pauses, raise
the **Expander** threshold from `-40 dB` toward `-35` or `-30 dB`. If speech
starts sounding choppy, lower it again. These filters affect only OBS, not
Discord, Steam, or other applications.

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

The **Aitum Vertical** dock runs a separate `1080x1920` canvas with four
seeded scenes: **Starting Soon (Vertical)**, **Main (Vertical)**,
**BRB (Vertical)**, and **Ending (Vertical)**. Each horizontal scene is
linked to its vertical counterpart, so switching the main scene also switches
the vertical scene. The links can be changed with the chain button in the
vertical dock.

**Main (Vertical)** reuses the horizontal **Display Capture** source and
scales it to cover the vertical canvas, cropping the sides. Approve the
PipeWire dialog once; the same capture feeds both layouts.

The vertical canvas is seeded with **Kick**, **YouTube**, and **TikTok**
destinations. Enter the stream keys in the vertical canvas settings; TikTok's
server URL is account-specific, and the Kick and YouTube URLs are pre-filled.
The vertical settings are stored in:

- `~/.config/obs-studio/plugin_config/vertical-canvas/config.json`

The vertical encoder uses the main OBS encoder settings and follows the main
profile's video/audio bitrate. Vertical streaming is not started automatically;
use the vertical dock's stream button after the main stream is running.

The seeded profile also enables Twitch Enhanced Broadcasting with the Aitum
Vertical canvas as its additional canvas. That sends the vertical canvas to
Twitch as an extra track on the main Twitch stream, separately from the Aitum
Vertical Kick/YouTube/TikTok outputs. Disable it in **Settings -> Stream** if
you do not want OBS to send the vertical canvas to Twitch.

Do not send the horizontal and vertical feeds to the same platform/account at
the same time. Most platforms allow only one live ingest per channel; use the
vertical destinations for platforms that are not receiving the horizontal
stream.

## Phone camera

Android phones can be used as a USB webcam through DroidCam. The
`programs/droidcam.nix` module installs the client and loads `v4l2loopback`.
The loopback device is pinned to `/dev/video10` so the OBS source has a stable
path.

1. Rebuild and reboot once so the v4l2loopback module options take effect.
2. On the phone, enable **Developer options -> USB debugging**.
3. Connect USB, authorize the computer, and confirm `adb devices` lists it.
4. Start the client with `droidcam`, or use:
   ```sh
   droidcam-cli -v -size=1920x1080 -dev=/dev/video10 adb 4747
   ```
5. In OBS, the **Phone Camera** source uses **Video Capture Device (V4L2)** at
   `/dev/video10`. Select 1080p30 and leave its audio disabled.

The live scene collection places the camera in the bottom-right corner of
**Main** and at the top-center of **Main (Vertical)**, over the shared screen.
The source is not part of the seed because it depends on the phone; on a fresh
install, add a **Video Capture Device (V4L2)** and select `/dev/video10`.

If OBS's virtual camera is enabled later, configure two v4l2loopback devices
so OBS and DroidCam do not compete for `/dev/video10`.

## Bandwidth and encoding

The seeded horizontal output is 1920x1080 at 60 fps, 6000 kbps video and
160 kbps audio. Aitum sends one encoded video stream to three additional
destinations, so four horizontal destinations use roughly 24 Mbps upload.
The vertical canvas uses its own 6000 kbps encode and sends one copy to each
enabled vertical destination, so three destinations add roughly 18 Mbps.
Twitch Enhanced Broadcasting may add another track to the Twitch upload; OBS
negotiates that track with Twitch. Lower the bitrate in
**Settings -> Output** if the connection cannot sustain that.
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
