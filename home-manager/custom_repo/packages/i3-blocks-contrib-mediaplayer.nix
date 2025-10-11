{
  #base stuff
  lib,
  fetchgit,
  stdenv,
  makeWrapper,

  #mediaplayer stuff
  perl,
  playerctl,
  ...
}:
(import ./i3-blocks-contrib-base.nix {
  lib = lib;
  fetchgit = fetchgit;
  stdenv = stdenv;
  makeWrapper = makeWrapper;

  executableFiles = [ "mediaplayer" ];
  folder = "mediaplayer";
  runtimeDeps = [ perl playerctl ];
})
