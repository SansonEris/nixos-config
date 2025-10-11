{
  #base stuff
  lib,
  fetchgit,
  stdenv,
  makeWrapper,

  #battery stuff
  perl,
  acpi,
  ...
}:
(import ./i3-blocks-contrib-base.nix {
  lib = lib;
  fetchgit = fetchgit;
  stdenv = stdenv;
  makeWrapper = makeWrapper;

  executableFiles = [ "battery" ];
  folder = "battery";
  runtimeDeps = [ perl acpi ];
})
