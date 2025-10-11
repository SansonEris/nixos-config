{
  #base stuff
  lib,
  fetchgit,
  stdenv,
  makeWrapper,

  #ssid stuff
  bash,
  iw,
  ...
}:
(import ./i3-blocks-contrib-base.nix {
  lib = lib;
  fetchgit = fetchgit;
  stdenv = stdenv;
  makeWrapper = makeWrapper;

  executableFiles = [ "ssid" ];
  folder = "ssid";
  runtimeDeps = [ bash iw ];
})
