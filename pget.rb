require 'formula'
HOMEBREW_PGET_VERSION='0.0.5'
class Pget < Formula
  homepage 'https://github.com/Code-Hex/pget'
  if OS.mac?
  	url "https://github.com/Code-Hex/pget/releases/download/#{HOMEBREW_PGET_VERSION}/pget_darwin_amd64.zip"
    sha256 "41885e80247ca33b89b2e871b5dd0c93d323e8439367ade5ef8a0293b0a60be5"
  elsif OS.linux?
  	url "https://github.com/Code-Hex/pget/releases/download/#{HOMEBREW_PGET_VERSION}/pget_linux_amd64.tar.gz"
    sha256 "964fd90ccfb1a718e3e6f34df52c718cb5ef308fdafd1b5ffd4004a436c6edfa"
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
