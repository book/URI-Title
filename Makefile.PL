use ExtUtils::MakeMaker;
require 5.008001;

WriteMakefile(
    'NAME' => 'URI::Title',
    'VERSION_FROM' => 'lib/URI/Title.pm',
    'PREREQ_PM' => {
        'Test::More' => 0,
        'Module::Pluggable' => '1.2',
        'File::Type' => '0.22',
        'HTML::Parser' => '3.45',
        'MP3::Info' => 0,
        'Image::Size' => 0,
        'LWP::Simple' => 0
    }
);
