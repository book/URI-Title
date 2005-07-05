=head NAME

URI::Title::HTML - get titles of html files

=cut

package URI::Title::HTML;

use warnings;
use strict;
use HTML::Entities;
our $CAN_USE_ENCODE;
BEGIN {
  eval { require Encode };
  $CAN_USE_ENCODE = !$@;
}

sub types {(
  'text/html',
  'default',
)}

sub title {
  my ($class, $url, $data, $type, $cset) = @_;

  my $title;
  my $match;

  # special case for the iTMS.
  if ( $INC{'URI/Title/iTMS.pm'} and $url =~ m!phobos.apple.com! and $data =~ m!(itms://[^']*)! ) {
    return URI::Title::iTMS->title($1);
  }

  if ($url =~ /timesonline\.co\.uk/i) {
    $match = '<span class="headline">';

  } elsif ($url =~ /use\.perl\.org\/~([^\/]+).*journal\/\d/i) {
    $match = '<FONT FACE="geneva,verdana,sans-serif" SIZE="1"><B>';
    $title = "use.perl journal of $1 - ";

  } elsif ($url =~ /(pants\.heddley\.com|dailychump\.org).*#(.*)$/i) {
    my $id = $2;
    $match = 'id="a'.$id.'.*?>.*?>.*?>';
    $title = "pants daily chump - ";

  } elsif ($url =~ /paste\.husk\.org/i) {
    $match = 'Summary: ';
    $title = "paste - ";

  } elsif ($url =~ /independent\.co\.uk/i) {
    $match = '<h1 class=head1>';

  } else {
    $match = '<title.*?>';
  }


  # TODO - work this out from the headers of the HTML
  if ($data =~ /charset=\"?([\w-]+)/i) {
    $cset = lc($1);
  }

  $data =~ /$match([^<]+)/im or return; # "Can't find title";
  $title .= $1;

  if ( $CAN_USE_ENCODE ) {
    $title = eval { decode($cset, $title) } || $title;
  }

  $title =~ s/\s+$//;
  $title =~ s/^\s+//;
  $title =~ s/\n+//g;
  $title =~ s/\s+/ /g;

  #use Devel::Peek;
  #Dump( $title );

  $title = decode_entities($title);

  #Dump( $title );

  # decode nasty number-encoded entities. Mostly works
  $title =~ s/(&\#(\d+);?)/chr($2)/eg;

  return $title;
}

1;
