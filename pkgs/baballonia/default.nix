{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  stdenv,
  python3,
  dotnetCorePackages,
  udev,
  libGL,
  fontconfig,
  xorg,
  alsa-lib,
  libpulseaudio,
  libxkbcommon,
  wayland,
  zlib,
  openssl,
  icu,
  curl,
  krb5,
  lttng-ust,
  gst_all_1,
}:
let
  runtimeLibs = [
    udev
    libGL
    fontconfig
    xorg.libX11
    xorg.libXcursor
    xorg.libXext
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libSM
    xorg.libICE
    alsa-lib
    libpulseaudio
    libxkbcommon
    wayland
    stdenv.cc.cc.lib
    zlib
    openssl
    icu
    curl
    krb5
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
  ];
in
stdenvNoCC.mkDerivation {
  pname = "baballonia";
  version = "1.1.1.0rc6";
  sourceRoot = ".";
  dontStrip = true;

  src = fetchurl {
    url = "https://github.com/Project-Babble/Baballonia/releases/download/v1.1.1.0rc6/Baballonia.x64.v1.1.1.0rc6.tar.xz";
    hash = "sha256-BsnOfsyhmg/uPq1A7wxwXKFzkW4RozFbmd9j00jqkGo=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = runtimeLibs ++ [
    lttng-ust
  ];

  autoPatchelfIgnoreMissingDeps = [
    "liblttng-ust.so.0"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/baballonia
    cp -r ./* $out/lib/baballonia/
    chmod +x $out/lib/baballonia/Baballonia.Desktop

    if [ -d "$out/lib/baballonia/Modules" ]; then
      mv "$out/lib/baballonia/Modules" "$out/lib/baballonia/Modules.orig"
      mkdir -p "$out/lib/baballonia/Modules"

      if [ -f "$out/lib/baballonia/Modules.orig/Baballonia.VFTCapture.dll" ]; then
        cp "$out/lib/baballonia/Modules.orig/Baballonia.VFTCapture.dll" \
          "$out/lib/baballonia/Baballonia.VFTCapture.Orig.dll"
      fi

      mkdir -p ./vft-factory
      cat > ./vft-factory/VftFactory.csproj <<XML
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <TargetFramework>net10.0</TargetFramework>
    <ImplicitUsings>disable</ImplicitUsings>
    <Nullable>disable</Nullable>
    <AssemblyName>Baballonia.VFTCapture</AssemblyName>
    <Version>1.0.0</Version>
  </PropertyGroup>
  <ItemGroup>
    <Reference Include="Baballonia.SDK">
      <HintPath>$out/lib/baballonia/Baballonia.SDK.dll</HintPath>
    </Reference>
    <Reference Include="Microsoft.Extensions.Logging.Abstractions">
      <HintPath>$out/lib/baballonia/Microsoft.Extensions.Logging.Abstractions.dll</HintPath>
    </Reference>
  </ItemGroup>
</Project>
XML

      cat > ./vft-factory/VFTCaptureFactory.cs <<'CS'
using System;
using System.IO;
using System.Runtime.Loader;
using Baballonia.SDK;
using Microsoft.Extensions.Logging;

namespace Baballonia.VFTCapture;

public class VFTCaptureFactory(ILoggerFactory loggerFactory) : ICaptureFactory
{
    public Capture Create(string address)
    {
        var baseDir = AppContext.BaseDirectory;
        var originalDll = Path.Combine(baseDir, "Baballonia.VFTCapture.Orig.dll");
        var asm = AssemblyLoadContext.Default.LoadFromAssemblyPath(originalDll);

        if (OperatingSystem.IsWindows())
        {
            var type = asm.GetType("Baballonia.VFTCapture.Windows.WindowsVftCapture")
                ?? throw new InvalidOperationException("WindowsVftCapture type not found.");
            return (Capture)Activator.CreateInstance(type, address, loggerFactory.CreateLogger(type))!;
        }

        if (OperatingSystem.IsLinux())
        {
            var type = asm.GetType("Baballonia.VFTCapture.Linux.LinuxVftCapture")
                ?? throw new InvalidOperationException("LinuxVftCapture type not found.");
            return (Capture)Activator.CreateInstance(type, address, loggerFactory.CreateLogger(type))!;
        }

        throw new InvalidOperationException("Unsupported operating system for VFTCapture.");
    }

    public bool CanConnect(string address)
    {
        var lowered = address.ToLowerInvariant();

        if (OperatingSystem.IsWindows())
            return !lowered.StartsWith("com");

        if (!OperatingSystem.IsLinux() || !lowered.StartsWith("/dev/video"))
            return false;

        var node = Path.GetFileName(address);
        var sysNamePath = Path.Combine("/sys/class/video4linux", node, "name");
        if (!File.Exists(sysNamePath))
            return false;

        var deviceName = File.ReadAllText(sysNamePath).Trim().ToLowerInvariant();
        return deviceName.Contains("htc") || deviceName.Contains("vive") || deviceName.Contains("facial");
    }

    public string GetProviderName() => nameof(VFTCapture);
}
CS

      export DOTNET_CLI_TELEMETRY_OPTOUT=1
      export DOTNET_CLI_HOME="$TMPDIR"
      ${dotnetCorePackages.sdk_10_0}/bin/dotnet restore ./vft-factory/VftFactory.csproj --nologo
      ${dotnetCorePackages.sdk_10_0}/bin/dotnet build ./vft-factory/VftFactory.csproj -c Release --nologo --no-restore
      cp ./vft-factory/bin/Release/net10.0/Baballonia.VFTCapture.dll "$out/lib/baballonia/Modules/Baballonia.VFTCapture.dll"

      for module in \
        Baballonia.LibV4L2Capture.dll \
        Baballonia.IPCameraCapture.dll \
        Baballonia.SerialCameraCapture.dll \
        Baballonia.VFTCapture.dll
      do
        if [ -f "$out/lib/baballonia/Modules.orig/$module" ]; then
          if [ "$module" = "Baballonia.VFTCapture.dll" ]; then
            continue
          fi
          cp "$out/lib/baballonia/Modules.orig/$module" "$out/lib/baballonia/Modules/$module"
        fi
      done

      rm -rf "$out/lib/baballonia/Modules.orig"
    fi

    makeWrapper $out/lib/baballonia/Baballonia.Desktop $out/bin/baballonia-real \
      --chdir $out/lib/baballonia \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}"

    cat > $out/bin/baballonia <<'EOF'
#!@shell@
set -euo pipefail

settings_file="''${XDG_CONFIG_HOME:-"$HOME/.config"}/ProjectBabble/ApplicationData/LocalSettings.json"
if [ -f "$settings_file" ]; then
  tmp_file="$(mktemp)"
  @python3@/bin/python3 - "$settings_file" "$tmp_file" <<'PY'
import json
import os
import sys

settings_path = sys.argv[1]
tmp_path = sys.argv[2]

with open(settings_path, "r", encoding="utf-8") as f:
    data = json.load(f)

changed = False

left_pref_key = "LastOpenedPreferredCaptureLeftCamera"
right_pref_key = "LastOpenedPreferredCaptureRightCamera"
face_pref_key = "LastOpenedPreferredCaptureFaceCamera"

left_camera_name = (data.get("LastOpenedLeftCamera") or "").lower()
right_camera_name = (data.get("LastOpenedRightCamera") or "").lower()
face_camera_name = (data.get("LastOpenedFaceCamera") or "").lower()

def normalize_pref(value):
    if value in (None, "", "Default", "OpenCvCapture"):
        return ""
    return value

left_pref = normalize_pref(data.get(left_pref_key))
right_pref = normalize_pref(data.get(right_pref_key))
face_pref = normalize_pref(data.get(face_pref_key))

# Bigscreen Bigeye should use Video4Linux2.
if not left_pref or "bigeye" in left_camera_name:
    if data.get(left_pref_key) != "Video4Linux2":
        data[left_pref_key] = "Video4Linux2"
        changed = True

if not right_pref or "bigeye" in right_camera_name:
    if data.get(right_pref_key) != "Video4Linux2":
        data[right_pref_key] = "Video4Linux2"
        changed = True

# Face camera defaults to VFTCapture, unless Bigeye is explicitly selected there.
desired_face_backend = "VFTCapture"
if "bigeye" in face_camera_name:
    desired_face_backend = "Video4Linux2"

if data.get(face_pref_key) != desired_face_backend:
    data[face_pref_key] = desired_face_backend
    changed = True

if changed:
    os.makedirs(os.path.dirname(settings_path), exist_ok=True)
    with open(tmp_path, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2)
        f.write("\n")
else:
    open(tmp_path, "w", encoding="utf-8").close()
PY
  if [ -s "$tmp_file" ]; then
    mv "$tmp_file" "$settings_file"
  else
    rm -f "$tmp_file"
  fi
fi

exec @out@/bin/baballonia-real "$@"
EOF
    substituteInPlace $out/bin/baballonia \
      --replace-fail '@shell@' '${stdenv.shell}' \
      --replace-fail '@python3@' '${python3}' \
      --replace-fail '@out@' "$out"
    chmod +x $out/bin/baballonia

    runHook postInstall
  '';

  postFixup = ''
    find "$out/lib/baballonia" -type f | while IFS= read -r file; do
      if patchelf --print-rpath "$file" >/dev/null 2>&1; then
        currentRpath="$(patchelf --print-rpath "$file")"
        if [ -n "$currentRpath" ]; then
          patchelf --set-rpath "\$ORIGIN:$currentRpath" "$file"
        else
          patchelf --set-rpath "\$ORIGIN" "$file"
        fi
      fi
    done
  '';

  meta = {
    mainProgram = "baballonia";
    platforms = lib.platforms.linux;
    homepage = "https://github.com/Project-Babble/Baballonia";
    description = "Free and open source eye and face tracking for social VR";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      zenisbestwolf
      ShyAssassin
    ];
  };
}
