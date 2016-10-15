require 'formula'
HOMEBREW_PGET_VERSION='0.0.6'
class Pget < Formula
  homepage 'https://github.com/Code-Hex/pget'
  if OS.mac?
  	url "https://github.com/Code-Hex/pget/releases/download/#{HOMEBREW_PGET_VERSION}/pget_darwin_amd64.zip"
    sha256 "69127d787d3f755286bdcfad95f37b1328704d920a2b6c15a441e9ededb8978b"
  elsif OS.linux?
  	url "https://github.com/Code-Hex/pget/releases/download/#{HOMEBREW_PGET_VERSION}/pget_linux_amd64.tar.gz"
    sha256 "efe48de32681e05a83cb59c3c97c6a91206bf49d3739ca9a7fd064b0a4f1b593"
  end
  version HOMEBREW_PGET_VERSION
  head 'https://github.com/Code-Hex/pget.git', :branch => 'master'
  if build.head?
    depends_on 'go' => :build
    depends_on 'hg' => :build
  end
  def install
    if build.head?
      ENV['GOPATH'] = buildpath
      mkdir_p buildpath/'src/github.com/Code-Hex'
      ln_s buildpath, buildpath/'src/github.com/Code-Hex/pget'
      system 'go', 'get', 'github.com/jessevdk/go-flags'
      system 'go', 'get', 'github.com/pkg/errors'
      system 'go', 'get', 'github.com/ricochet2200/go-disk-usage/du'
      system 'go', 'get', 'github.com/asaskevich/govalidator'
      system 'go', 'get', 'gopkg.in/cheggaaa/pb.v1'
      system 'go', 'get', 'github.com/Code-Hex/pget'
      system 'go', 'build', '-o', 'pget', 'cmd/pget/main.go'
    end
    bin.install 'pget'
  end
end
