#!/usr/bin/perl
use warnings;
use strict;
use lib 'lib';
use URI::Title qw(title);
use Encode;

my $title = title(shift);
#use Devel::Peek;
#Dump($title);
binmode STDOUT, ":utf8";
print $title;


