class PdStatusWall < Formula
  desc "Status video wall for PagerDuty Business Services"
  homepage "https://github.com/nicolasb114/pd-status-wall"
  version "0.6.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nicolasb114/pd-status-wall/releases/download/v#{version}/pd-status-wall-macos-apple-silicon.tar.gz"
      sha256 "a4ce067deb9afd5ebdf94925a737e07578e9dd7a0c1642222d30e3492f805772"
    end
    on_intel do
      url "https://github.com/nicolasb114/pd-status-wall/releases/download/v#{version}/pd-status-wall-macos-intel.tar.gz"
      sha256 "f11df07da43e74d1bb9b70feb4e635b391107066e00086f50cb90e7bc79b8bda"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nicolasb114/pd-status-wall/releases/download/v#{version}/pd-status-wall-linux-arm64.tar.gz"
      sha256 "39d92c951092bad175620f69fe1d9f33f09a2c0ac2abd6be300bbed6a79e40d9"
    end
    on_intel do
      url "https://github.com/nicolasb114/pd-status-wall/releases/download/v#{version}/pd-status-wall-linux-x86-64.tar.gz"
      sha256 "fb5887ac7cb2466bc6bf6ab32bfe73f1920a7226ccb8dfd1dc5f872164e22422"
    end
  end

  def install
    bin.install "pd-status-wall"
  end

  def caveats
    <<~EOS
      Start the video wall with:
        pd-status-wall

      It listens on http://localhost:8080 by default; the admin panel is at
      /admin. On first run it prints a generated admin password once - copy
      it before it scrolls away.

      Config and uploads are written to ./data in the working directory.
      Set DATA_DIR to put them somewhere stable, e.g.
        DATA_DIR="$HOME/.pd-status-wall" pd-status-wall
    EOS
  end

  test do
    assert_match "pd-status-wall", shell_output("#{bin}/pd-status-wall --version")
  end
end
