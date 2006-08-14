#############################################################################
## Name:        lib/Wx/DemoModules/wxRadioBox.pm
## Purpose:     wxPerl demo helper for Wx::RadioBox
## Author:      Mattia Barbon
## Modified by:
## Created:     13/08/2006
## RCS-ID:      $Id: wxRadioBox.pm,v 1.1 2006/08/14 20:00:50 mbarbon Exp $
## Copyright:   (c) 2000, 2003, 2005-2006 Mattia Barbon
## Licence:     This program is free software; you can redistribute it and/or
##              modify it under the same terms as Perl itself
#############################################################################

package Wx::DemoModules::wxRadioBox;

use strict;
use base qw(Wx::Panel Class::Accessor::Fast);

use Wx qw(:radiobox :font wxNOT_FOUND wxDefaultPosition wxDefaultSize);
use Wx::Event qw(EVT_RADIOBOX EVT_BUTTON);

__PACKAGE__->mk_ro_accessors( qw(radiobox) );

sub new {
    my( $class, $parent ) = @_;
    my $self = $class->SUPER::new( $parent );

    my $choices = [ 'This', 'is one of my',
                    'really', 'wonderful', 'examples', ];
    my $choices2 = [ "First", 'second' ];
    my $choices10 = [ "First", "Second", "Third", "Fourth", "Fifth",
                      "Sixth", "Seventh", "Eighth", "Nineth", "Tenth" ];

    $self->{radiobox} = Wx::RadioBox->new( $self, -1, "T&his", [10, 10],
                                           wxDefaultSize, $choices, 1,
                                           wxRA_SPECIFY_COLS );
    my $rb1 = Wx::DemoModules::wxRadioBox::Custom->new
      ( $self, -1, "&That", [10, 160], wxDefaultSize,
        $choices2, 1, wxRA_SPECIFY_ROWS );
    my $rb2 = Wx::RadioBox->new( $self, -1, 
                                    "And another one wiyh very long title", 
                                    [165, 115], 
                                    wxDefaultSize, $choices10, 3, 
                                    wxRA_SPECIFY_COLS );
    $rb2->SetToolTip( "Ever seen a radiobox?" );

    my $b1 = Wx::Button->new( $self, -1, "Select #&2", [180, 30], [140, 30] );
    my $b2 = Wx::Button->new( $self, -1, "&Select 'This'",
                              [180, 80], [140, 30] );
    my $b3 = Wx::Button->new( $self, -1, "Set &Italic font",
                              [340, 80], [140, 30] );

    EVT_BUTTON( $self, $b1, \&OnRadioBox_SelNum );
    EVT_BUTTON( $self, $b2, \&OnRadioBox_SelStr );
    EVT_BUTTON( $self, $b3, \&OnRadioBox_Font );
    EVT_RADIOBOX( $self, $self->radiobox, \&OnRadio );

    return $self;
}

sub OnRadio {
    my( $self, $event ) = @_;

    Wx::LogMessage( join '', "RadioBox selection string is: ",
                              $event->GetString() );
}

sub OnRadioBox_SelNum {
    my( $self ) = @_;

    $self->radiobox->SetSelection( 2 );
}

sub OnRadioBox_SelStr {
    my( $self ) = @_;

    $self->radiobox->SetStringSelection( "This" );
}

sub OnRadioBox_Font {
    my( $self ) = @_;

    $self->radiobox->SetFont( wxITALIC_FONT );
}

sub add_to_tags { qw(controls) }
sub title { 'wxRadioBox' }

package Wx::DemoModules::wxRadioBox::Custom;

use strict;
use base qw(Wx::RadioBox);

use Wx::Event qw(EVT_SET_FOCUS EVT_KILL_FOCUS);

sub new {
    my( $class ) = shift;
    my( $self ) = $class->SUPER::new( @_ );

    EVT_SET_FOCUS( $self, \&OnFocusGot );
    EVT_KILL_FOCUS( $self, \&OnFocusLost );

    return $self;
}

sub OnFocusGot {
    my( $self, $event ) = @_;

    Wx::LogMessage( 'Wx::DemoModules::wxRadioBox::Custom::OnFocusGot' );
    $event->Skip();
}

sub OnFocusLost {
    my( $self, $event ) = @_;

    Wx::LogMessage( 'Wx::DemoModules::wxRadioBox::Custom::OnFocusLost' );
    $event->Skip();
}

1;
