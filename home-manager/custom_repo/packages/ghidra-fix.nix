{ pkgs, ...}:
let
  z3_lib = (pkgs.z3.override { javaBindings=true; jdk = pkgs.gradle.jdk;});
  fixedKaiju = pkgs.ghidra-extensions.kaiju.overrideAttrs (old: {
    buildInputs = (old.buildInputs or []) ++ [ z3_lib ];
  });
  ghidra-custom = 
    (pkgs.ghidra.withExtensions (exts: [
      exts.ret-sync
      fixedKaiju
    ]));
in
pkgs.stdenv.mkDerivation {
  src = null;
  dontUnpack = true;
  pname = "ghidra-fix";
  version = "1.0";
  buildInputs = [ ghidra-custom ];
  installPhase = ''
    mkdir -p $out/bin
    cat > $out/bin/ghidra-fix <<EOF
    #!/bin/sh
    _JAVA_AWT_WM_NONREPARENTING=1 ${ghidra-custom}/bin/ghidra "\$@"
    EOF
    chmod +x $out/bin/ghidra-fix
  '';
}
