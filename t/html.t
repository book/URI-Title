use warnings;
use strict;
use Test::More no_plan => 1;
use URI::Title qw(title);

print STDERR "This test may fail if there is no net access\n";

is(
  title('http://jerakeen.org'),
  "jerakeen.org",
  "got title for jerakeen.org");

is(
  title('http://theregister.co.uk/content/6/34549.html'),
  "Warning: lack of technology may harm your prospects",
  "got register title");
