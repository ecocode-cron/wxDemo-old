#!/usr/bin/perl -w

use strict;

use Wx::Demo;

our $VERSION = '0.01';

my $app = Wx::SimpleApp->new;
Wx::Demo->new;
$app->MainLoop;

exit 0;
