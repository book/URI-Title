package URI::Title::MP3;
use warnings;
use strict;

use MP3::Info;
use File::Temp qw(tempfile);

use LWP::Simple;
use LWP::UserAgent;
use HTTP::Request;
use HTTP::Response;

sub types {(
  'audio/mp3',
  'default',
)}

sub get_end {
  my $url = shift;
  my (undef, $length) = head($url);
  my $size = 1024 * 32;
  my $start = $length - $size;

  my $ua = LWP::UserAgent->new;
  $ua->timeout(20);
  $ua->max_size($size);
  my $req = HTTP::Request->new(GET => $url);
  $req->header( Range => "bytes=$start-$length" );
  my $res = $ua->request($req);
  return unless $res->is_success;
  return $res->content;
}

sub get_tag {
  my $data = shift;
  my (undef, $temp) = tempfile();
  open FILE, ">$temp" or die $!;
  print FILE $data;
  close FILE;
  my $tag = get_mp3tag($temp);
  unlink($temp);
  return $tag;
}

sub title {
  my ($class, $url, $data, $type) = @_;
  my $tag = get_tag($data) || get_tag( get_end($url) )
    or return;
  return "mp3: $tag->{ARTIST} - $tag->{TITLE}";
}

1;
