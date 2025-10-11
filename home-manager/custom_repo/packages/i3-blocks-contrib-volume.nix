{
  #base stuff
  lib,
  fetchgit,
  stdenv,
  makeWrapper,

  #volume stuff
  bash,
  alsa-utils,
  ...
}:
(import ./i3-blocks-contrib-base.nix {
  lib = lib;
  fetchgit = fetchgit;
  stdenv = stdenv;
  makeWrapper = makeWrapper;

  executableFiles = [ "volume" ];
  folder = "volume";
  runtimeDeps = [ bash alsa-utils ];
})
