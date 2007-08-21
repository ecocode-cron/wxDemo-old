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

our $VERSION = '0.07';

my $app = Wx::SimpleApp->new;
my $locale = Wx::Locale->new( Wx::Locale::GetSystemLanguage );
#my $locale = Wx::Locale->new( Wx::wxLANGUAGE_HEBREW() );
Wx::Demo->new;
$app->MainLoop;

exit 0;
