class PdStatusWall < Formula
  desc "Status video wall for PagerDuty Business Services"
  homepage "https://github.com/nicolasb114/pd-status-wall"
  version "0.5.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/nicolasb114/pd-status-wall/releases/download/v#{version}/pd-status-wall-macos-apple-silicon.tar.gz"
      sha256 "8be8964e9c56641f48f7502bca94c12adad5e8a408a88dac51751240f95cc96c"
    end
    on_intel do
      url "https://github.com/nicolasb114/pd-status-wall/releases/download/v#{version}/pd-status-wall-macos-intel.tar.gz"
      sha256 "02fc5ab26f65d1709c3c9ef22081005b5d271f69ac571b63e1195d5e2c8d2523"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nicolasb114/pd-status-wall/releases/download/v#{version}/pd-status-wall-linux-arm64.tar.gz"
      sha256 "fa74e42ca254dc115a9e76afc2889497821f381471dc3b3a889bfc2e042df1c1"
    end
    on_intel do
      url "https://github.com/nicolasb114/pd-status-wall/releases/download/v#{version}/pd-status-wall-linux-x86-64.tar.gz"
      sha256 "679ba250d957aca7f4930d57172ebb9a239f38dfc0a21db4268663918b37fe80"
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
