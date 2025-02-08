{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  pkg-config,
  glib,
  cairo,
  pango,
  gdk-pixbuf,
  atk,
  gtk3,
  openssl,
  libsoup_3,
}:
rustPlatform.buildRustPackage rec {
  pname = "arnis";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "louis-e";
    repo = "arnis";
    tag = "v${version}";
    hash = "sha256-3Gdrgo6j50ieR0E6q0DeKShHbng9sBjBC0hBAPLsnt0=";
  };

  cargoHash = "sha256-w5XFeyZ+1on7ZkCwROZhbKZCVbSxkVzqIe0/yvJzUgQ=";

  nativeBuildInputs = [ pkg-config versionCheckHook ];
  buildInputs = [ glib cairo pango gdk-pixbuf atk gtk3 openssl libsoup_3 ];

  # Required for OpenSSL to find Nix-provided dependencies
  PKG_CONFIG_PATH = "${lib.makeSearchPathOutput "dev" "lib/pkgconfig" buildInputs}";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Real world location generator for Minecraft Java Edition";
    longDescription = ''
      Open source project written in Rust generates any chosen location from
      the real world in Minecraft Java Edition with a high level of detail.
    '';
    homepage = "https://github.com/louis-e/arnis";
    changelog = "https://github.com/louis-e/arnis/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "arnis";
  };
}