{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, libusb1
}:

buildGoModule {
  pname = "go-bsb-cams-fast";
  version = "unstable-2026-05-10";

  src = fetchFromGitHub {
    owner = "foxyote";
    repo = "go-bsb-cams-fast";
    rev = "main";
    hash = "sha256-YfVFH19B/EeSnyDL9vbEJCkZB+YTaddrdt9eViOpyCY=";
  };

  vendorHash = "sha256-U5B8QJRLSb4S1N0veMPodWfxRZuk/RkCjSd/RAzow78=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libusb1
  ];

  meta = with lib; {
    description = "Fast Bigscreen Beyond 2e camera webserver for eye-tracking software";
    homepage = "https://github.com/foxyote/go-bsb-cams-fast";
    license = licenses.mit;
    mainProgram = "go-bsb-cams-fast";
    platforms = platforms.linux;
  };
}
