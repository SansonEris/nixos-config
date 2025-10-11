{
  #base stuff
  lib,
  fetchgit,
  stdenv,
  makeWrapper,

  #cpu_usage stuff
  perl,
  sysstat,
  ...
}:
(import ./i3-blocks-contrib-base.nix {
  lib = lib;
  fetchgit = fetchgit;
  stdenv = stdenv;
  makeWrapper = makeWrapper;

  executableFiles = [ "cpu_usage" ];
  folder = "cpu_usage";
  runtimeDeps = [ perl sysstat ];
})
