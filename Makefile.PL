#!/usr/bin/perl -w
#############################################################################
## Name:        Makefile.PL
## Purpose:     Makefile.PL for wxPerl demo
## Author:      Mattia Barbon
## Modified by:
## Created:     14/08/2006
## RCS-ID:      $Id$
## Copyright:   (c) 2006-2007 Mattia Barbon
## Licence:     This program is free software; you can redistribute it and/or
##              modify it under the same terms as Perl itself
#############################################################################

use strict;

use ExtUtils::MakeMaker;
eval {
    require ExtUtils::MY_Metafile;
    ExtUtils::MY_Metafile->import;

    my_metafile( {
        license  => 'perl',
        abstract => 'the wxPerl demo',
    } );
};

WriteMakefile
  ( NAME            => 'Wx::Demo',
    VERSION_FROM    => 'bin/wxperl_demo.pl',
    PREREQ_PM       => { 'File::Spec'              => 0.8,
                         'Wx'                      => 0.64,
                         'Module::Pluggable'       => 3.1,
                         'UNIVERSAL::require'      => 0.10,
                         'Class::Accessor::Fast'   => 0.20,
                         'File::Slurp'             => 0.01,
                         'File::chdir'             => 0.06,
                         'IO::String'              => 1.08,
                         },
    EXE_FILES       => [ qw(bin/wxperl_demo.pl) ],
    ( $] >= 5.005 ?
      ( AUTHOR          => 'Mattia Barbon <mbarbon@cpan.org>' ) :
      () ),
);
