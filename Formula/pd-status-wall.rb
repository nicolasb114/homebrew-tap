class PdStatusWall < Formula
  desc "Status video wall for PagerDuty Business Services"
  homepage "https://github.com/nicolasb114/pd-status-wall"
  version "0.4.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nicolasb114/pd-status-wall/releases/download/v#{version}/pd-status-wall-macos-apple-silicon.tar.gz"
      sha256 "c1283bafd3cf6c1ec27f3c924546f3cd073cb928e8805f771164b06fbc0c0ffc"
    end
    on_intel do
      url "https://github.com/nicolasb114/pd-status-wall/releases/download/v#{version}/pd-status-wall-macos-intel.tar.gz"
      sha256 "b529f679fc416e492d269668a8c920e027cd1ebab5b965cc0102f1386bcbfc45"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nicolasb114/pd-status-wall/releases/download/v#{version}/pd-status-wall-linux-arm64.tar.gz"
      sha256 "41b53493c376768169c8abe2537d1160aab4915ea205341ccbb9d91bb4a9747d"
    end
    on_intel do
      url "https://github.com/nicolasb114/pd-status-wall/releases/download/v#{version}/pd-status-wall-linux-x86-64.tar.gz"
      sha256 "ba9de21673a1306c90372e47f01a789118356e35acbec563cb7ae27cf1252676"
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
