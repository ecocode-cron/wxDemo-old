#############################################################################
## Name:        lib/Wx/DemoModules/wxGauge.pm
## Purpose:     wxPerl demo helper for Wx::Gauge
## Author:      Mattia Barbon
## Modified by:
## Created:     13/08/2006
## RCS-ID:      $Id: wxGauge.pm,v 1.1 2006/08/14 20:00:51 mbarbon Exp $
## Copyright:   (c) 2000, 2003, 2005-2006 Mattia Barbon
## Licence:     This program is free software; you can redistribute it and/or
##              modify it under the same terms as Perl itself
#############################################################################

package Wx::DemoModules::wxGauge;

use strict;
use base qw(Wx::Panel Class::Accessor::Fast);

use Wx qw(:gauge :font wxNOT_FOUND);
use Wx::Event qw();

__PACKAGE__->mk_ro_accessors( qw(gauge) );

sub new {
    my( $class, $parent ) = @_;
    my $self = $class->SUPER::new( $parent );

    $self->{gauge} = Wx::Gauge->new( $self, -1, 200,
                                     [18, 90], [155, -1],
                                     wxGA_HORIZONTAL );

    $self->gauge->SetValue( 120 );

    return $self;
}

sub add_to_tags { qw(controls) }
sub title { 'wxGauge' }

1;
