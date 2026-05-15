{ pkgs, inputs, ... }:

let
  lib = pkgs.lib;
  system = pkgs.stdenv.hostPlatform.system;

  dotnetSdk = pkgs.dotnetCorePackages.combinePackages [
    pkgs.dotnetCorePackages.sdk_10_0-bin
    pkgs.dotnetCorePackages.sdk_8_0-bin
  ];

  dotnetRuntime = pkgs.dotnetCorePackages.combinePackages [
    pkgs.dotnetCorePackages.runtime_10_0-bin
    pkgs.dotnetCorePackages.runtime_8_0-bin
  ];

  aspnetRuntime = pkgs.dotnetCorePackages.combinePackages [
    pkgs.dotnetCorePackages.aspnetcore_10_0-bin
    pkgs.dotnetCorePackages.aspnetcore_8_0-bin
  ];

  baseVrcfacetracking =
    inputs.vrcfacetracking.packages.${system}.default;

  vrcSrc = pkgs.fetchFromGitHub {
    owner = "dfgHiatus";
    repo = "VRCFaceTracking.Avalonia";
    rev = "v1.1.0.0";
    fetchSubmodules = true;
    hash = "sha256-8wuOeBMR7bHgq+rsjAaGlmddaQh06flEEW7h+YsnwVQ=";
  };

  generatedNugetPackages = pkgs.stdenvNoCC.mkDerivation {
    pname = "vrchatfacetracking-nuget-packages";
    version = "1.1.0.0";

    src = vrcSrc;

    nativeBuildInputs = [
      dotnetSdk
    ];

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-/7/sYUiUSXDsCWzo/R+rX4VZJwcPuLBOQ2AtdGDZqhk=";

    buildPhase = ''
      runHook preBuild

      export HOME="$TMPDIR/home"
      export DOTNET_CLI_HOME="$TMPDIR/dotnet"
      export NUGET_PACKAGES="$TMPDIR/nuget-packages"

      mkdir -p "$HOME" "$DOTNET_CLI_HOME" "$NUGET_PACKAGES"

      dotnet restore \
        ./src/VRCFaceTracking.Avalonia.Desktop/VRCFaceTracking.Avalonia.Desktop.csproj \
        --packages "$NUGET_PACKAGES"

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p "$out"
      cp -r "$NUGET_PACKAGES"/* "$out"/

      runHook postInstall
    '';
  };

  vrcfacetracking =
    baseVrcfacetracking.overrideAttrs (old: {
      src = vrcSrc;

      postPatch = ''
        python3 - <<'PY'
from pathlib import Path

path = Path("src/VRCFaceTracking/VRCFaceTracking.Core/OSC/DataTypes/BinaryBaseParameter.cs")
text = path.read_text()

if "var suffixChars = tempName.Replace(_paramName, \"\").ToCharArray();" in text:
    print("BinaryBaseParameter patch already present")
    raise SystemExit(0)

lines = text.splitlines()
replacement_done = False

for start in range(len(lines)):
    if "int.TryParse" not in lines[start]:
        continue

    end = start
    while end < len(lines) and "continue;" not in lines[end]:
        end += 1

    if end >= len(lines):
        continue

    chunk = "\n".join(lines[start:end + 1])

    if (
        "tempName" not in chunk
        or "_paramName" not in chunk
        or "TakeWhile" not in chunk
        or "Reverse" not in chunk
    ):
        continue

    indent = lines[start][:len(lines[start]) - len(lines[start].lstrip())]

    replacement = [
        indent + 'var suffixChars = tempName.Replace(_paramName, "").ToCharArray();',
        indent + 'System.Array.Reverse(suffixChars);',
        indent + 'var reversedDigits = suffixChars.TakeWhile(char.IsNumber).ToArray();',
        indent + 'System.Array.Reverse(reversedDigits);',
        indent + 'var suffix = new string(reversedDigits);',
        "",
        indent + 'if (!int.TryParse(suffix, out var index)) continue;',
    ]

    lines[start:end + 1] = replacement
    replacement_done = True
    break

if not replacement_done:
    print("Could not find TryParse/tempName/TakeWhile/Reverse block to patch.")
    print("Relevant lines:")
    for i, line in enumerate(lines, start=1):
        if any(token in line for token in ["TryParse", "tempName", "TakeWhile", "Reverse", "suffix"]):
            print(f"{i}: {line}")
    raise SystemExit(1)

path.write_text("\n".join(lines) + "\n")
PY
      '';

      nativeBuildInputs =
        let
          isDotnetSdk = p:
            lib.hasPrefix "dotnet-sdk" ((p.pname or p.name or ""));
        in
          builtins.filter (p: ! isDotnetSdk p) (old.nativeBuildInputs or [])
          ++ [
            dotnetSdk
            pkgs.makeWrapper
            pkgs.python3
          ];

      buildInputs =
        (old.buildInputs or [])
        ++ [
          dotnetRuntime
          aspnetRuntime
        ];

      dotnet-sdk = dotnetSdk;
      dotnet-runtime = dotnetRuntime;
      configurePhase = ''
        runHook preConfigure

        export HOME="$TMPDIR/home"
        export DOTNET_CLI_HOME="$TMPDIR/dotnet"
        export NUGET_PACKAGES="$TMPDIR/nuget-packages"

        mkdir -p "$HOME" "$DOTNET_CLI_HOME" "$NUGET_PACKAGES"

        cat > NuGet.Config <<EOF
<configuration>
  <packageSources>
    <clear />
    <add key="local" value="${generatedNugetPackages}" />
  </packageSources>
</configuration>
EOF

        dotnet restore \
          ./src/VRCFaceTracking.Avalonia.Desktop/VRCFaceTracking.Avalonia.Desktop.csproj \
          --packages "$NUGET_PACKAGES" \
          --configfile NuGet.Config \
          --ignore-failed-sources

        runHook postConfigure
      '';

      buildPhase = ''
        runHook preBuild

        dotnet build \
          ./src/VRCFaceTracking.Avalonia.Desktop/VRCFaceTracking.Avalonia.Desktop.csproj \
          --configuration Release \
          --no-restore

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p "$out/lib/vrchatfacetracking" "$out/bin"

        cp -r \
          ./src/VRCFaceTracking.Avalonia.Desktop/bin/Release/net10.0/* \
          "$out/lib/vrchatfacetracking/"

        makeWrapper ${dotnetRuntime}/bin/dotnet "$out/bin/vrchatfacetracking" \
          --add-flags "$out/lib/vrchatfacetracking/VRCFaceTracking.Avalonia.Desktop.dll"

        runHook postInstall
      '';

      dontFixup = true;
    });
in
{
  home.packages = [
    vrcfacetracking
  ] ++ (with pkgs; [
    v4l-utils
    psmisc
  ]);

  xdg.userDirs = {
    enable = true;
    documents = "$HOME/Documents";
  };

  xdg.desktopEntries.vrcfacetracking = {
    name = "VRCFaceTracking";
    genericName = "VRChat Face Tracking";
    comment = "VRCFaceTracking Avalonia";
    exec = "${vrcfacetracking}/bin/vrchatfacetracking";
    icon = "applications-games";
    terminal = false;
    categories = [ "Utility" "Game" ];
  };
}
