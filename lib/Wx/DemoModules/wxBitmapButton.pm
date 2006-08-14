#############################################################################
## Name:        lib/Wx/DemoModules/wxBitmapButton.pm
## Purpose:     wxPerl demo helper for Wx::BitmapButton
## Author:      Mattia Barbon
## Modified by:
## Created:     13/08/2006
## RCS-ID:      $Id: wxBitmapButton.pm,v 1.1 2006/08/14 20:00:51 mbarbon Exp $
## Copyright:   (c) 2000, 2003, 2005-2006 Mattia Barbon
## Licence:     This program is free software; you can redistribute it and/or
##              modify it under the same terms as Perl itself
#############################################################################

package Wx::DemoModules::wxBitmapButton;

use strict;
use base qw(Wx::Panel Class::Accessor::Fast);

use Wx qw(:icon wxTheApp);
use Wx::Event qw(EVT_BUTTON);

__PACKAGE__->mk_ro_accessors( qw(button) );

sub new {
    my( $class, $parent ) = @_;
    my $self = $class->SUPER::new( $parent );

    my $bmp1 = Wx::Bitmap->new( wxTheApp->GetStdIcon( wxICON_INFORMATION ) );
    my $bmp2 = Wx::Bitmap->new( wxTheApp->GetStdIcon( wxICON_WARNING ) );
    my $bmp3 = Wx::Bitmap->new( wxTheApp->GetStdIcon( wxICON_QUESTION ) );

    $self->{button} = Wx::BitmapButton->new( $self, -1, $bmp1, [30, 50] );
    $self->button->SetBitmapSelected( $bmp2 );
    $self->button->SetBitmapFocus( $bmp3 );

    EVT_BUTTON( $self, $self->button, \&OnClick );

    return $self;
}

sub OnClick {
    my( $self, $event ) = @_;

    Wx::LogMessage( 'Button clicked' );
}

sub add_to_tags { qw(controls) }
sub title { 'wxBitmapButton' }

1;
