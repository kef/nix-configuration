{ system, homebrew-core, homebrew-cask, user, ... }:

{
  # Install Homebrew under the default prefix
  enable = true;

  # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
  enableRosetta = system == "aarch64-darwin";

  # User owning the Homebrew prefix
  inherit user;

  # Optional: Declarative tap management
  taps = {
    "homebrew/homebrew-core" = homebrew-core;
    "homebrew/homebrew-cask" = homebrew-cask;
  };

  # Optional: Enable fully-declarative tap management
  #
  # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
  mutableTaps = false;
}
