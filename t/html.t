use warnings;
use strict;
use Test::More;
use URI::Title qw(title);

require IO::Socket;
my $s = IO::Socket::INET->new(
  PeerAddr => "www.yahoo.com:80",
  Timeout  => 10,
);

if ($s) {
  close($s);
  plan tests => 2;
} else {
  plan skip_all => "no net connection available";
  exit;
}

is(
  title('http://jerakeen.org'),
  "jerakeen.org",
  "got title for jerakeen.org");

is(
  title('http://theregister.co.uk/content/6/34549.html'),
  "Warning: lack of technology may harm your prospects",
  "got register title");


