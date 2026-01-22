final: prev:
let
  py311 = prev.python311Packages;
  idaProMcpRev = "c2472d1c1e676f0198070e0e27f708973c7a4254";
  idaProMcpHash = "0qbb11iq8hy72q1n8cz7i3pkkvr3dwab8v9dqrbrmck93xzrdrnx";
  idaproVersion = "0.0.7";
  idaproHash = "13wq8j8mby3ff7lhx50m2f9m9c11kgrif7wbli741n74355ihbhb";
  mathMcpVersion = "0.1.1";

  mathMcpPkg = prev.buildNpmPackage {
    pname = "math-mcp";
    version = mathMcpVersion;

    src = prev.fetchFromGitHub {
      owner = "EthanHenrickson";
      repo = "math-mcp";
      rev = "6cca48319cfceede5c75e350dda6f0e9994a7b13";
      hash = "sha256-VuEzFWm3oke10q0kx4Le8FtHqmujgFJ8QuLqOEYjyP4=";
    };

    npmBuildScript = "build:stdio";
    npmDepsHash = "sha256-o2qqrxD25dZ74G7mcVLhVjcTQAtP0mKFO9pWAhmJCP4=";

    nativeBuildInputs = [ prev.makeWrapper ];

    postInstall = ''
      makeWrapper ${prev.nodejs}/bin/node $out/bin/math-mcp \
        --add-flags $out/lib/node_modules/math-mcp/build/index.js
    '';

    meta = with prev.lib; {
      description = "MCP server for math operations";
      homepage = "https://github.com/EthanHenrickson/math-mcp";
      license = licenses.mit;
      platforms = platforms.linux;
      mainProgram = "math-mcp";
    };
  };

  idaproPkg = py311.buildPythonPackage {
    pname = "idapro";
    version = idaproVersion;

    src = prev.fetchPypi {
      pname = "idapro";
      version = idaproVersion;
      sha256 = idaproHash;
    };

    format = "pyproject";
    nativeBuildInputs = [ py311.setuptools ];

    meta = with prev.lib; {
      description = "Python helpers shared with IDA Pro MCP";
      homepage = "https://pypi.org/project/idapro/";
      license = licenses.mit;
      platforms = platforms.linux;
    };
  };

  idaProMcpPkg = py311.buildPythonApplication {
    pname = "ida-pro-mcp";
    version = "2.0.0";

    src = prev.fetchFromGitHub {
      owner = "mrexodia";
      repo = "ida-pro-mcp";
      rev = idaProMcpRev;
      sha256 = idaProMcpHash;
    };

    format = "pyproject";
    nativeBuildInputs = [ py311.setuptools ];
    propagatedBuildInputs = [
      idaproPkg
      py311.tomli-w
    ];

    meta = with prev.lib; {
      description = "AI-powered reverse engineering assistant for IDA Pro via MCP";
      homepage = "https://github.com/mrexodia/ida-pro-mcp";
      license = licenses.mit;
      platforms = platforms.linux;
    };
  };
in
{
  f3demo = final.callPackage ../pkgs/f3demo { };
  idapro = idaproPkg;
  ida-pro-mcp = idaProMcpPkg;
  math-mcp = mathMcpPkg;

  vrr-status = prev.writeShellScriptBin "vrr-status" ''
    state=$(
      swaymsg -r -t get_outputs |
      jq -r '.[] | select(.name=="DP-3") | .adaptive_sync_status'
    )

    if [ "$state" = "enabled" ]; then
      alt="on"
    else
      alt="off"
    fi

    printf '{"text":"%s","alt":"%s"}\n' "$alt" "$alt"
  '';

  uni-sync = prev.rustPlatform.buildRustPackage {
    pname = "uni-sync";
    version = "0.3.1";

    src = prev.fetchFromGitHub {
      owner = "EightB1ts";
      repo = "uni-sync";
      rev = "0.3.1";
      sha256 = "05afs06pgbskrs9k9l760kz2mv7smn2i54i8kkf12x3r7q72vzj1";
    };

    cargoHash = "sha256-ot2pbCddvw3njsz36WbFFJ9AAtmojUnRxlUbym1RcgU=";

    patches = [
      ./uni-sync-cli-config-path.patch
    ];

    nativeBuildInputs = [ prev.pkg-config ];
    buildInputs = [
      prev.hidapi
      prev.libusb1
    ];

    meta = with prev.lib; {
      description = "Synchronization tool for Lian Li Uni controllers";
      homepage = "https://github.com/EightB1ts/uni-sync";
      license = licenses.mit;
      mainProgram = "uni-sync";
      platforms = platforms.linux;
    };
  };
}
