{
  #base stuff
  lib,
  fetchgit,
  stdenv,
  makeWrapper,

  #time stuff
  perl,
  ...
}:
(import ./i3-blocks-contrib-base.nix {
  lib = lib;
  fetchgit = fetchgit;
  stdenv = stdenv;
  makeWrapper = makeWrapper;

  executableFiles = [ "time" ];
  folder = "time";
  runtimeDeps = [ perl ];
})
