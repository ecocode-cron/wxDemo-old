#############################################################################
## Name:        lib/Wx/DemoModules/wxSlider.pm
## Purpose:     wxPerl demo helper for Wx::Slider
## Author:      Mattia Barbon
## Modified by:
## Created:     13/08/2006
## RCS-ID:      $Id: wxSlider.pm,v 1.1 2006/08/14 20:00:51 mbarbon Exp $
## Copyright:   (c) 2000, 2003, 2005-2006 Mattia Barbon
## Licence:     This program is free software; you can redistribute it and/or
##              modify it under the same terms as Perl itself
#############################################################################

package Wx::DemoModules::wxSlider;

use strict;
use base qw(Wx::Panel Class::Accessor::Fast);

use Wx qw(:slider :font wxNOT_FOUND);
use Wx::Event qw(EVT_SLIDER);

__PACKAGE__->mk_ro_accessors( qw(slider) );

sub new {
    my( $class, $parent ) = @_;
    my $self = $class->SUPER::new( $parent );

    $self->{slider} = Wx::Slider->new( $self, -1, 0, 0, 200,
                                       [18, 90], [155, -1],
                                       wxSL_LABELS );

    EVT_SLIDER( $self, $self->slider, \&OnSlider );

    return $self;
}

sub OnSlider {
    my( $self, $event ) = @_;
    my( $slider ) = $self->slider;

    Wx::LogMessage( join '', 'Event position: ', $event->GetInt );
    Wx::LogMessage( join '', 'Slider position: ', $slider->GetValue );
}

sub add_to_tags { qw(controls) }
sub title { 'wxSlider' }

1;
