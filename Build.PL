#!/usr/bin/perl
use warnings;
use strict;

use Module::Build;

Module::Build->new(
    module_name => 'URI::Title',
    license => 'perl',
    requires => {
      'Test::More' => '0.01',
      'LWP'        => '0.01',
#      'MP3::Info'  => '0.01',
#      'File::Type' => '0.01',
    },
    create_makefile_pl => 'traditional',
)->create_build_script;

