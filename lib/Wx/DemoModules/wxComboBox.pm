#############################################################################
## Name:        lib/Wx/DemoModules/wxComboBox.pm
## Purpose:     wxPerl demo helper for Wx::ComboBox
## Author:      Mattia Barbon
## Modified by:
## Created:     13/08/2006
## RCS-ID:      $Id: wxComboBox.pm,v 1.1 2006/08/14 20:00:50 mbarbon Exp $
## Copyright:   (c) 2000, 2003, 2005-2006 Mattia Barbon
## Licence:     This program is free software; you can redistribute it and/or
##              modify it under the same terms as Perl itself
#############################################################################

package Wx::DemoModules::wxComboBox;

use strict;
use base qw(Wx::Panel Class::Accessor::Fast);

use Wx qw(:combobox :font :textctrl wxNOT_FOUND);
use Wx::Event qw(EVT_COMBOBOX EVT_BUTTON EVT_TEXT EVT_TEXT_ENTER);

__PACKAGE__->mk_ro_accessors( qw(combobox) );

sub new {
    my( $class, $parent ) = @_;
    my $self = $class->SUPER::new( $parent );

    my $choices = [ 'This', 'is one of my',
                    'really', 'wonderful', 'examples', ];

    $self->{combobox} = Wx::DemoModules::wxComboBox::Custom->new
        ( $self, -1, "This", [20, 25], [120, -1],
          $choices, wxTE_PROCESS_ENTER );
    $self->combobox->SetToolTip( <<EOT );
This is a natural combobox
can you believe me?
EOT

    my $b1 = Wx::Button->new( $self, -1, 'Select #&2', [180, 30], [140, 30] );
    my $b2 = Wx::Button->new( $self, -1, '&Select \'This\'',
                              [340, 30], [140, 30] );
    my $b3 = Wx::Button->new( $self, -1, '&Clear', [180, 80], [140, 30] );
    my $b4 = Wx::Button->new( $self, -1, '&Append \'Hi!\'', 
                              [340, 80], [140, 30] );
    my $b5 = Wx::Button->new( $self, -1, 'D&elete selected item',
                              [180, 130], [140, 30] );
    my $b6 = Wx::Button->new( $self, -1, 'Set &Italic font',
                              [340, 130], [140, 30] );

    EVT_BUTTON( $self, $b1, \&OnComboButtons_SelNum );
    EVT_BUTTON( $self, $b2, \&OnComboButtons_SelStr );
    EVT_BUTTON( $self, $b3, \&OnComboButtons_Clear );
    EVT_BUTTON( $self, $b4, \&OnComboButtons_Append );
    EVT_BUTTON( $self, $b5, \&OnComboButtons_Delete );
    EVT_BUTTON( $self, $b6, \&OnComboButtons_Font );
    EVT_COMBOBOX( $self, $self->combobox, \&OnCombo );
    EVT_TEXT( $self, $self->combobox, \&OnComboTextChanged );
    EVT_TEXT_ENTER( $self, $self->combobox, \&OnComboTextEnter );

    return $self;
}

sub OnCombo {
    my( $self, $event ) = @_;

    Wx::LogMessage( join '', "ComboBox event selection string is: '",
                    $event->GetString(), "'" );
    Wx::LogMessage( "ComboBox control selection string is: '",
                    $self->combobox->GetStringSelection(), "'" );
}

sub OnComboTextChanged {
    my( $self ) = @_;

    Wx::LogMessage( "Text in the combobox changed: now is '%s'.",
                    $self->combobox->GetValue() );
}

sub OnComboTextEnter {
    my( $self ) = @_;

    Wx::LogMessage( "Enter pressed in the combobox changed: now is '%s'.",
                    $self->combobox->GetValue() );
}

sub OnComboButtons_Enable {
    my( $self, $event ) = @_;

    my( $e ) = $event->GetInt() == 0;
    $self->combobox->Enable( $e );
}

sub OnComboButtons_SelNum {
    my( $self, $event ) = @_;

    $self->combobox->SetSelection( 2 );
}

sub OnComboButtons_SelStr {
    my( $self, $event ) = @_;

    $self->combobox->SetStringSelection( "This" );
}

sub OnComboButtons_Clear {
    my( $self ) = @_;

    $self->combobox->Clear();
}

sub OnComboButtons_Append {
    my( $self ) = @_;

    $self->combobox->Append( 'Hi!' );
}

sub OnComboButtons_Delete {
    my( $self ) = @_;
    my( $idx );

    if( ( $idx = $self->combobox->GetSelection() ) != wxNOT_FOUND ) {
        $self->combobox->Delete( $idx );
    }
}

sub OnComboButtons_Font {
    my( $self ) = @_;

    $self->combobox->SetFont( wxITALIC_FONT );
}

sub add_to_tags { qw(controls) }
sub title { 'wxComboBox' }

package Wx::DemoModules::wxComboBox::Custom;

use strict;
use base qw(Wx::ComboBox);
use Wx::Event qw(EVT_SET_FOCUS EVT_CHAR EVT_KEY_DOWN EVT_KEY_UP);

sub new {
    my( $class ) = shift;
    my( $self ) = $class->SUPER::new( @_ );

    EVT_SET_FOCUS( $self, \&OnFocusGot );
    EVT_CHAR( $self, \&OnChar );
    EVT_KEY_DOWN( $self, \&OnKeyDown );
    EVT_KEY_UP( $self, \&OnKeyUp );

    return $self;
}

sub OnChar {
    my( $self, $event ) = @_;

    Wx::LogMessage( 'Wx::DemoModules::wxComboBox::Custom::OnChar' );

    if( $event->GetKeyCode() == ord( 'w' ) ) {
        Wx::LogMessage( "Wx::DemoModules::wxComboBox::Custom: 'w' ignored" );
    } else {
        $event->Skip();
    }
}

sub OnKeyDown {
    my( $self, $event ) = @_;

    Wx::LogMessage( 'Wx::DemoModules::wxComboBox::Custom::OnKeyDown' );

    if( $event->GetKeyCode() == ord( 'w' ) ) {
        Wx::LogMessage( "Wx::DemoModules::wxComboBox::Custom: 'w' ignored" );
    } else {
        $event->Skip();
    }
}

sub OnKeyUp {
    my( $self, $event ) = @_;

    Wx::LogMessage( 'Wx::DemoModules::wxComboBox::Custom::OnKeyUp' );
    $event->Skip();
}

sub OnFocusGot {
    my( $self, $event ) = @_;

    Wx::LogMessage( 'Wx::DemoModules::wxComboBox::Custom::FocusGot' );
    $event->Skip();
}

1;
