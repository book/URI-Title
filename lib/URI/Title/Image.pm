package URI::Title::Image;
use warnings;
use strict;

use Image::Size;

sub types {(
  'image/gif',
  'image/jpg',
  'image/jpeg',
)}

sub title {
  my ($class, $url, $data, $type) = @_;

  my ($x, $y) = imgsize(\$data);
  return "image: ($type) $x x $y";
}

1;
