{
  #base stuff
  lib,
  fetchgit,
  stdenv,
  makeWrapper,

  #wifi stuff
  bash,
  iw,
  ...
}:
(import ./i3-blocks-contrib-base.nix {
  lib = lib;
  fetchgit = fetchgit;
  stdenv = stdenv;
  makeWrapper = makeWrapper;

  executableFiles = [ "wifi" ];
  folder = "wifi";
  runtimeDeps = [ bash iw ];
})
