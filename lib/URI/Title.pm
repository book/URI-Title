=head1 NAME

URI::Title - get the titles of things on the web in a sensible way

=head1 SYNOPSIS

  use URI::Title qw( title );
  my $title = title('http://microsoft.com');
  print "Title is $title\n";

=head1 DESCRIPTION

I keep having to find the title of things on the web. This seems like a really
simple request, just get() the object, parse for a title tag, you're done. Ha,
I wish. There are several problems with this approach:

=over 4

=item What if the resource is on a very slow server? Do we wait for ever or what?

=item What if the resource is a 900 gig file? You don't want to download that.

=item What if the page title isn't in a title tag, but is buried in the HTML somewhere?

=item What if the resource is an MP3 file, or a word document or something?

=item ...

=back

So, let's solve these issues once.

=head1 METHODS

only one, the title(url) method. Call it with an url, get the title if possible,
undef if it wasn't. Very simple.

=head1 TODO

Many, many, many things. Still unimplemented:

=over 4

=item Get titles of MP3 files, Word Docs, PDFs, etc.

=item Configurable.. well, anything, in fact. Timeout would be a good start.

=item Better error reporting.

=head1 CREDITS

Invented because of a conversation with rjp, who contributed some eyeball-melting and
as-yet-unused code to get titles from MP3s and PDFs, and hex, who has also solved the
problem, and got bits done in a nicer way than I did.

=cut

package URI::Title;

use base qw(Exporter);
our @EXPORT_OK = qw( title );

our $VERSION = '0.3';

use LWP::UserAgent;
use HTTP::Request;
use HTTP::Response;
#use File::Type;
use HTML::Entities;

sub get_limited {
    my $url = shift;
    my $size = shift || 8*1024;
    my $ua = LWP::UserAgent->new;
    $ua->timeout(20);
    $ua->max_size($size);
    my $req = HTTP::Request->new(GET => $url);
    $req->header( Range => "bytes=0-$size" );
    my $res = $ua->request($req);
    return unless $res->is_success;
    return $res->content;
}

sub get_all {
    my $url = shift;
    my $ua = LWP::UserAgent->new;
    $ua->timeout(20);
    my $req = HTTP::Request->new(GET => $url);
    my $res = $ua->request($req);
    return unless $res->is_success;
    return $res->content;
}

sub title {
    my $url = shift;

#    my $type = File::Type->new->checktype_contents($data);

    my $title;
    my $match;
    my $size = 16 * 1024;
    
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

    } elsif ($url =~ /independent\.co\.uk/i) {
        $match = '<h1 class=head1>';
        $size = 32 * 1024;

    } else {
        $match = '<title>';
    }

    my $data = get_limited($url, $size) or return; # Can't get;

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

