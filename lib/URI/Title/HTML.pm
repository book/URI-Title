=head NAME

URI::Title::HTML - get titles of html files

=cut

package URI::Title::HTML;

use warnings;
use strict;
use HTML::Entities;

sub types {(
  'text/html',
#  'default',
)}

sub title {
  my ($class, $url, $data, $type) = @_;

  my $title;
  my $match;

  if ($url =~ /timesonline\.co\.uk/i) {
    $match = '<span class="headline">';

  } elsif ($url =~ /use\.perl\.org\/~([^\/]+).*journal\/\d/i) {
    $match = '<FONT FACE="geneva,verdana,sans-serif" SIZE="1"><B>';
    $title = "use.perl journal of $1 - ";

  } elsif ($url =~ /pants\.heddley\.com.*#(.*)$/i) {
    my $id = $1;
    $match = 'id="a'.$id.'"\/>[^<]*<a[^>]*>';
    $title = "pants daily chump - ";

  } elsif ($url =~ /paste\.husk\.org/i) {
    $match = 'Summary: ';
    $title = "paste - ";

  } elsif ($url =~ /independent\.co\.uk/i) {
    $match = '<h1 class=head1>';

  } else {
    $match = '<title>';
  }

  $data =~ /$match([^<]+)/im or return; # "Can't find title";

  $title .= $1;
  $title =~ s/\s+$//;
  $title =~ s/^\s+//;
  $title =~ s/\n+//g;
  $title =~ s/\s+/ /g;
  $title = decode_entities($title);

  return $title;
}

1;
