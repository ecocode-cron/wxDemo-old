#############################################################################
## Name:        lib/Wx/DemoModules/wxSpinButton.pm
## Purpose:     wxPerl demo helper for Wx::SpinButton
## Author:      Mattia Barbon
## Modified by:
## Created:     13/08/2006
## RCS-ID:      $Id: wxSpinButton.pm,v 1.1 2006/08/14 20:00:51 mbarbon Exp $
## Copyright:   (c) 2000, 2003, 2005-2006 Mattia Barbon
## Licence:     This program is free software; you can redistribute it and/or
##              modify it under the same terms as Perl itself
#############################################################################

package Wx::DemoModules::wxSpinButton;

use strict;
use base qw(Wx::Panel Class::Accessor::Fast);

use Wx qw(:spinbutton :font wxNOT_FOUND);
use Wx::Event qw(EVT_SPIN EVT_SPIN_UP EVT_SPIN_DOWN);

__PACKAGE__->mk_ro_accessors( qw(spinbutton text) );

sub new {
    my( $class, $parent ) = @_;
    my $self = $class->SUPER::new( $parent );

    $self->{spinbutton} =
      Wx::SpinButton->new( $self, -1, [103, 160], [80, -1] );
    $self->{text} =
      Wx::TextCtrl->new( $self, -1, "-5", [20, 160 ], [80, -1] );


    $self->spinbutton->SetRange( -10, 30 );
    $self->spinbutton->SetValue( -5 );

    EVT_SPIN( $self, $self->spinbutton, \&OnSpinUpdate );
    EVT_SPIN_UP( $self, $self->spinbutton, \&OnSpinUp );
    EVT_SPIN_DOWN( $self, $self->spinbutton, \&OnSpinDown );

    return $self;
}

sub OnSpinUp {
    my( $self, $event ) = @_;

    Wx::LogMessage( "Spin control up: current = %d",
                    $self->spinbutton->GetValue );

    if( $self->spinbutton->GetValue > 17 ) {
        Wx::LogMessage( "Preventing the spin button from going above 17" );
        $event->Veto;
    }
}

sub OnSpinDown {
    my( $self, $event ) = @_;

    Wx::LogMessage( "Spin control down: current = %d",
                    $self->spinbutton->GetValue );

    if( $self->spinbutton->GetValue < -17 ) {
        Wx::LogMessage( "Preventing the spin button from going below -17" );
        $event->Veto;
    }
}

sub OnSpinUpdate {
    my( $self, $event ) = @_;

    $self->text->SetValue( $event->GetPosition );
    Wx::LogMessage( "Spin control range: ( %d, %d ) current = %d",
                    $self->spinbutton->GetMin,
                    $self->spinbutton->GetMax,
                    $self->spinbutton->GetValue );
}

sub add_to_tags { qw(controls) }
sub title { 'wxSpinButton' }

1;
