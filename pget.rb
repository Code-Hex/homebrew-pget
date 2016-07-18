require 'formula'
HOMEBREW_PGET_VERSION='0.0.4'
class Pget < Formula
  homepage 'https://github.com/Code-Hex/pget'
  if OS.mac?
  	url "https://github.com/Code-Hex/pget/releases/download/#{HOMEBREW_PGET_VERSION}/pget_darwin_amd64.zip"
    sha256 "6e83ac87d40e216160378e82f47c93cb92791e43977a44d27cfcc8f463101fb0"
  elsif OS.linux?
  	url "https://github.com/Code-Hex/pget/releases/download/#{HOMEBREW_PGET_VERSION}/pget_linux_amd64.tar.gz"
    sha256 "88cdf0a9095c1e693f2ecf3dcdcf349d7c62b9820012d8feaa826e6a9e6a98f7"
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
