#!/usr/bin/perl
use warnings;
use strict;

use Module::Build;

Module::Build->new(
    module_name => 'URI::Title',
    license => 'perl',
    requires => {
      'Test::More'        => 0, # testing
      'LWP::Simple'        => 0, # to get the file contents
      'File::Type'        => '0.22', # to detect file types
      'Module::Pluggable' => '1.2', # to find modules
      'MP3::Info'         => 0, # mp3 files get artist / title / etc
      'Image::Size'       => 0, # jpegs get sizes reported
      'HTML::Parser'      => '3.45', # utf-8 support doesn't suck
    },
    create_makefile_pl => 'traditional',
)->create_build_script;

