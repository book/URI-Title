use warnings;
use strict;
use Test::More;
use lib 'lib';
use URI::Title qw(title);

require IO::Socket;
my $s = IO::Socket::INET->new(
  PeerAddr => "www.yahoo.com:80",
  Timeout  => 10,
);

if ($s) {
  close($s);
  plan tests => 3;
} else {
  plan skip_all => "no net connection available";
  exit;
}

is( title('http://st.pimg.net/perlweb/images/camel_head.v25e738a.png'), "png (60 x 65)"  );

SKIP: {
  skip "Image::ExifTool or Image::PNG::Libpng not installed", 2 if !got_png_libs();
  is( title('t/images/has_title.png'), "png (32 x 32) : checker"  );
  is( title('t/images/no_title.png'), "png (32 x 32)"  );
}

sub got_png_libs {
  eval { require Image::ExifTool };
  return 1 if !$@;
  eval { require Image::PNG::Libpng };
  return $@ ? 0 : 1;
}
