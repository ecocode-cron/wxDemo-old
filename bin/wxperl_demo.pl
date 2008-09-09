#!/usr/bin/perl -w
#############################################################################
## Name:        bin/wxperl_demo.pl
## Purpose:     main wxPerl demo driver script
## Author:      Mattia Barbon
## Modified by:
## Created:     14/08/2006
## RCS-ID:      $Id$
## Copyright:   (c) 2006-2008 Mattia Barbon
## Licence:     This program is free software; you can redistribute it and/or
##              modify it under the same terms as Perl itself
#############################################################################

use strict;

if( $^O eq 'darwin' && $^X !~ m{/wxPerl\.app/} ) {
    print "On Mac OS X please run the demo with 'wxPerl wxperl_demo.pl'\n";
    exit 0;
}

use Wx::Demo;
use Getopt::Long;

our $VERSION = '0.11';

GetOptions( 'show=s'   => \( my $module ),
            'help'     => \( my $help ),
            'list'     => \( my $list ),
            ) or usage();
usage() if $help;

my $app    = Wx::SimpleApp->new;
my $locale = Wx::Locale->new( Wx::Locale::GetSystemLanguage );
my $demo   = Wx::Demo->new;

$demo->activate_module( $module ) if $module;
if ($list) {
    print join "\n",
          sort
          map $_->title, 
          grep $_->can( 'title' ),
          $demo->plugins;

   exit 0;
}

$app->MainLoop;

exit 0;

sub usage {
    die <<"END_USAGE";
Usage: $0
           --help        this help
           --show ???    showing the particular Demo
           --list        list all available modules
END_USAGE

}