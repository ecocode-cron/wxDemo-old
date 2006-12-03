#!/usr/bin/perl -w

use strict;

use Wx::Demo;

our $VERSION = '0.06';

my $app = Wx::SimpleApp->new;
my $locale = Wx::Locale->new( Wx::Locale::GetSystemLanguage );
#my $locale = Wx::Locale->new( Wx::wxLANGUAGE_HEBREW() );
Wx::Demo->new;
$app->MainLoop;

exit 0;
