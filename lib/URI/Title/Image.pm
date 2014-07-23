=head1 NAME

URI::Title::Image - get titles of images

=cut

package URI::Title::Image;
use warnings;
use strict;

use Image::Size;

sub types {(
  'image/gif',
  'image/jpg',
  'image/jpeg',
  'image/png',
  'image/x-png',
)}

sub title {
  my ($class, $url, $data, $type) = @_;

  my ($x, $y) = imgsize(\$data);
  $type =~ s!^[^/]*/!!;
  $type =~ s!^x-!!;
  return $type unless $x && $y;
  return "$type ($x x $y)";
}

1;
