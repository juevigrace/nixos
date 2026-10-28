# Home Manager side of Niri: link the user's config and the host's output
# layout from the repository.
{
  config,
  helpers,
  osConfig,
  ...
}: let
  user = config.home.username;
  host = osConfig.networking.hostName;
in {
  # User-scoped Niri configuration.
  xdg.configFile."niri/config.kdl".source =
    helpers.liveConfig "users/${user}/programs/niri/config.kdl";

  # Host-scoped monitor layout. config.kdl includes it as "outputs.kdl".
  xdg.configFile."niri/outputs.kdl".source =
    helpers.liveConfig "hosts/${host}/programs/niri/outputs.kdl";
}
