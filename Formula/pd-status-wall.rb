class PdStatusWall < Formula
  desc "Status video wall for PagerDuty Business Services"
  homepage "https://github.com/nicolasb114/pd-status-wall"
  version "0.7.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nicolasb114/pd-status-wall/releases/download/v#{version}/pd-status-wall-macos-apple-silicon.tar.gz"
      sha256 "1ab270ea2d981a8211c7c1eee6148eedcf6a86b6d3b6e2559b7d661a82453c04"
    end
    on_intel do
      url "https://github.com/nicolasb114/pd-status-wall/releases/download/v#{version}/pd-status-wall-macos-intel.tar.gz"
      sha256 "96f1bb5eb81a215f4fb7c1dc21862e1a04407e3f2c2c0ad62a7a4295459087e1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nicolasb114/pd-status-wall/releases/download/v#{version}/pd-status-wall-linux-arm64.tar.gz"
      sha256 "7af8b410532c29f917d7daa03df25ffe22754c1428250a29dbfb89e41246f579"
    end
    on_intel do
      url "https://github.com/nicolasb114/pd-status-wall/releases/download/v#{version}/pd-status-wall-linux-x86-64.tar.gz"
      sha256 "44dcff34d4e66a3e2250b5dc94d4a8f0edda6240ebb6b1615bce97cfd0faff0b"
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
