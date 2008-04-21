=head NAME

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
)}

sub title {
  my ($class, $url, $data, $type) = @_;

  my ($x, $y) = imgsize(\$data);
  $type =~ s!^[^/]*/!!;
  return $type unless $x && $y;
  return "$type ($x x $y)";
}

1;
