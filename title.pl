#!/usr/bin/perl
use warnings;
use strict;
use lib 'lib';
use URI::Title qw(title);
print title(shift)."\n";