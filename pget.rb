require 'formula'
HOMEBREW_PGET_VERSION='0.0.2'
class Pget < Formula
  homepage 'https://github.com/Code-Hex/pget'
  if OS.mac?
  	url "https://github.com/Code-Hex/pget/releases/download/#{HOMEBREW_PGET_VERSION}/pget_darwin_amd64.zip"
    sha256 "d9c808ec77ac7be68644cb199d34f35a3f0472aa4ee786e1bbdb55a1e02cc384"
  elsif OS.linux?
  	url "https://github.com/Code-Hex/pget/releases/download/#{HOMEBREW_PGET_VERSION}/pget_linux_amd64.tar.gz"
    sha256 "6d66e2fba514df000fdd9f168b315b66a50dfc7ecab056fcc617ab28c08ce201"
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
