#############################################################################
## Name:        lib/Wx/DemoModules/wxSpinCtrl.pm
## Purpose:     wxPerl demo helper for Wx::SpinCtrl
## Author:      Mattia Barbon
## Modified by:
## Created:     13/08/2006
## RCS-ID:      $Id: wxSpinCtrl.pm,v 1.1 2006/08/14 20:00:51 mbarbon Exp $
## Copyright:   (c) 2000, 2003, 2005-2006 Mattia Barbon
## Licence:     This program is free software; you can redistribute it and/or
##              modify it under the same terms as Perl itself
#############################################################################

package Wx::DemoModules::wxSpinCtrl;

use strict;
use base qw(Wx::Panel Class::Accessor::Fast);

use Wx qw(:spinctrl :font wxNOT_FOUND);
use Wx::Event qw(EVT_SPINCTRL);

__PACKAGE__->mk_ro_accessors( qw(spinctrl) );

sub new {
    my( $class, $parent ) = @_;
    my $self = $class->SUPER::new( $parent );

    $self->{spinctrl} = Wx::SpinCtrl->new( $self, -1, '', [200, 160],
                                           [80, -1] );
    $self->spinctrl->SetRange( 10, 30 );
    $self->spinctrl->SetValue( 15 );

    EVT_SPINCTRL( $self, $self->spinctrl, \&OnSpinCtrl );

    return $self;
}

sub OnSpinCtrl {
    my( $self, $event ) = @_;

    Wx::LogMessage( "Spin ctrl changed: now %d (from event %d)",
                    $self->spinctrl->GetValue,
                    $event->GetInt );
}

sub add_to_tags { qw(controls) }
sub title { 'wxSpinCtrl' }

1;
