#!/usr/bin/perl
use warnings;
use strict;

use Module::Build;

Module::Build->new(
    module_name => 'URI::Title',
    license => 'perl',
    requires => {
      'Test::More'        => 0,
      'LWP::Simple'        => 0,
      'File::Type'        => '0.22',
      'Module::Pluggable' => '1.2',
      'MP3::Info'         => 0,
      'Image::Size'       => 0,
    },
    create_makefile_pl => 'traditional',
)->create_build_script;

