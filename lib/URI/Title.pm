=head1 NAME

URI::Title - get the titles of things on the web in a sensible way

=cut

package URI::Title;

use base qw(Exporter);
our @EXPORT = qw( title );

our $VERSION = '0.1';

use LWP::UserAgent;
use HTTP::Request;
use HTTP::Response;

sub get {
    my $url = shift;

    my $ua = LWP::UserAgent->new;
    $ua->timeout(20);
    $ua->max_size(16384);

    my $req = HTTP::Request->new(GET => $url);
    $req->header( Range => 'bytes=0-16384' );
    my $res = $ua->request($req);

    return unless $res->is_success;

    return $res->content;
}

sub title {
    my $url = shift;

    my $data = get($url) or return; # Can't get;
    
    my $title;
    my $match;

    if ($url =~ /theregister\.co\.uk/i) {
        $match = '<div class="storyhead">';
    } elsif ($url =~ /timesonline\.co\.uk/i) {
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
        return if $mess->{who} eq 'pasty';
    } else {
        $match = '<title>';
    }

    $data =~ /$match([^<]+)/im or return; # "Can't find title";

    $title .= $1;
    $title =~ s/\s+$//;
    $title =~ s/^\s+//;
    return $title;

}

1;

