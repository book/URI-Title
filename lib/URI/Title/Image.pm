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

sub got_exif_tool {
  eval {
    require Image::ExifTool;
  };
  return $@ ? 0 : 1;
}

sub got_lib_png {
  eval {
    require Image::PNG::Libpng;
  };
  return $@ ? 0 : 1;
}

sub pnginfo {
  if (got_exif_tool()) {
    return pnginfo_exif_tool( @_ );
  }
  else {
    return pnginfo_lib_png( @_ );
  }
}

sub pnginfo_exif_tool {
  my ($data_ref) = @_;
  my $title = "";
  my $x = 0;
  my $y = 0;
  my $info = Image::ExifTool::ImageInfo($data_ref);
  return ($info->{ImageWidth}, $info->{ImageHeight}, gen_title_str($info->{Title}));
}

sub gen_title_str {
  return $_[0] ? " : " . $_[0] : "";
}

sub pnginfo_lib_png {
  my ($data_ref) = @_;
  my $title = "";
  my $x = 0;
  my $y = 0;
  my $png = Image::PNG::Libpng::read_from_scalar($$data_ref);
  $x = $png->get_image_width();
  $y = $png->get_image_height();
  my $text_chunks = $png->get_text();
  for (@$text_chunks) {
    if ($_->{key} eq "Title") {
      $title = gen_title_str($_->{text});
      last;
    }
  }
  return ($x, $y, $title);
}

sub can_extract_png_title {
  return got_lib_png() || got_exif_tool();
}

sub title {
  my ($class, $url, $data, $type) = @_;

  $type =~ s!^[^/]*/!!;
  $type =~ s!^x-!!;
  my $title = "";
  my $x = 0;
  my $y = 0;
  if ( can_extract_png_title() && $type =~ /png/ ) {
    ($x, $y, $title) = pnginfo(\$data);
  }
  else {
    ($x, $y) = imgsize(\$data);
  }
  return $type unless $x && $y;
  return "$type ($x x $y)$title";
}

1;

__END__

=for Pod::Coverage::TrustPod types title

=head1 NAME

URI::Title::Image - get titles of images

=cut
