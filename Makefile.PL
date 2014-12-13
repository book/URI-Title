require 5.006;
use ExtUtils::MakeMaker;

my $mm_ver = $ExtUtils::MakeMaker::VERSION;
if ($mm_ver =~ /_/) { # dev version
    $mm_ver = eval $mm_ver;
    die $@ if $@;
}

WriteMakefile(
    'NAME' => 'URI::Title',
    'VERSION_FROM' => 'lib/URI/Title.pm',
    'PREREQ_PM' => {
        'Test::More'        => 0,
        'Module::Pluggable' => '1.2',
        'File::Type'        => '0.22',
        'HTML::Parser'      => '3.45',
        'MP3::Info'         => 0,
        'Image::Size'       => 0,
        'LWP::Simple'       => 0,
        'strict'            => 0,
        'warnings'          => 0,
    },

    ($mm_ver >= 6.31
        ? (LICENSE => 'perl')
        : ()
    ),

    META_MERGE => {
        resources => {
            repository => 'http://github.com/book/URI-Title',
        },
    },

    ($mm_ver >= 6.48
        ? (MIN_PERL_VERSION => 5.006)
        : ()
    ),

    ($mm_ver >= 6.52
        ? (CONFIGURE_REQUIRES => {
                'ExtUtils::MakeMaker' => 6.30,
          })
        : ()
    ),

);
