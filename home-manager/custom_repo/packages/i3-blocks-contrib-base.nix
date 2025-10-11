{
  #folder specific input
  executableFiles,
  folder,
  runtimeDeps,

  #utility input
  stdenv,
  lib,
  fetchgit,
  makeWrapper,
  ...
}:
stdenv.mkDerivation {
  pname = "i3-blocks-contrib-${folder}";
  #version = "9d66d81";
  version = "9d66d82";
  src = fetchgit {
    url = "https://github.com/vivien/i3blocks-contrib.git";
    rev = "9d66d81da8d521941a349da26457f4965fd6fcbd";
    hash = "sha256-iY9y3zLw5rUIHZkA9YLmyTDlgzZtIYAwWgHxaCS1+PI=";
  };

  nativeBuildInputs = [ makeWrapper ];
  propagatedBuildInputs = runtimeDeps;

  buildPhase = ''
    runHook preBuild
    cd ${folder}
    for executable_file in "${builtins.toString executableFiles}"; do
      chmod +x $executable_file
    done
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/scripts
    mkdir -p $out/share/i3blocks-${folder}
    # Installa gli script nella directory scripts
    for executable_file in "${builtins.toString executableFiles}"; do
      if [ -f "$executable_file" ]; then
        find . -name "$executable_file" -executable -type f -exec cp {} $out/scripts/ \;
      fi
    done
    # Wrappa ogni script per assicurare che le dipendenze siano nel PATH
    for script in $out/scripts/${builtins.toString executableFiles}; do
      if [ -f "$script" ]; then
        wrapProgram "$script" \
          --prefix PATH : "${lib.makeBinPath runtimeDeps}"
      fi
    done
    # Copia i file di configurazione/documentazione se esistono
    find ./${folder} -name "*.conf" -o -name "README*" -o -name "*.md" | while read file; do
      cp "$file" $out/share/i3blocks-${folder}/ 2>/dev/null || true
    done
    runHook postInstall
  '';

}
