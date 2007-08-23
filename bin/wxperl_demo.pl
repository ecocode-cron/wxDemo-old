#!/usr/bin/perl -w
#############################################################################
## Name:        bin/wxperl_demo.pl
## Purpose:     main wxPerl demo driver script
## Author:      Mattia Barbon
## Modified by:
## Created:     14/08/2006
## RCS-ID:      $Id$
## Copyright:   (c) 2006-2007 Mattia Barbon
## Licence:     This program is free software; you can redistribute it and/or
##              modify it under the same terms as Perl itself
#############################################################################

use strict;

use Wx::Demo;
use Getopt::Long;

our $VERSION = '0.09';

GetOptions( 'show=s'   => \( my $module ),
            );

my $app = Wx::SimpleApp->new;
my $locale = Wx::Locale->new( Wx::Locale::GetSystemLanguage );
my $demo = Wx::Demo->new;

$demo->activate_module( $module ) if $module;

$app->MainLoop;

exit 0;
