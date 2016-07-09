#!/usr/bin/env perl

use strict;
use warnings;
use v5.10;
use Furl;
use JSON::XS qw/decode_json/;
use HTTP::Request::Common;
use Digest::MD5 qw/md5_hex/;

my $f = Furl->new;

my $release_latest = "https://api.github.com/repos/Code-Hex/pget/releases/latest";
my $res = $f->request(GET $release_latest);
my $content = $res->content;

my $data = decode_json($content);
my $version = $data->{tag_name};

my $mac = "https://github.com/Code-Hex/pget/releases/download/${version}/pget_darwin_amd64.zip";
my $linux = "https://github.com/Code-Hex/pget/releases/download/${version}/pget_linux_amd64.tar.gz";

$res = $f->request(GET $mac);
my $mac_hash = md5_hex $res->content;

$res = $f->request(GET $linux);
my $linux_hash = md5_hex $res->content;

my $rb = << "EOM";
require 'formula'
HOMEBREW_PGET_VERSION='%s'
class Pget < Formula
  homepage 'https://github.com/Code-Hex/pget'
  if OS.mac?
  	url "https://github.com/Code-Hex/pget/releases/download/#{HOMEBREW_PGET_VERSION}/pget_darwin_amd64.zip"
    sha1 "%s"
  elsif OS.linux?
  	url "https://github.com/Code-Hex/pget/releases/download/#{HOMEBREW_PGET_VERSION}/pget_linux_amd64.tar.gz"
    sha1 "%s"
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
EOM

open FH, ">", "pget.rb";
print FH sprintf $rb, $version, $mac_hash, $linux_hash;
close FH;