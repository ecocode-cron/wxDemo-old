#############################################################################
## Name:        lib/Wx/DemoModules/wxChoice.pm
## Purpose:     wxPerl demo helper for Wx::Choice
## Author:      Mattia Barbon
## Modified by:
## Created:     13/08/2006
## RCS-ID:      $Id: wxChoice.pm,v 1.1 2006/08/14 20:00:50 mbarbon Exp $
## Copyright:   (c) 2000, 2003, 2005-2006 Mattia Barbon
## Licence:     This program is free software; you can redistribute it and/or
##              modify it under the same terms as Perl itself
#############################################################################

package Wx::DemoModules::wxChoice;

use strict;
use base qw(Wx::Panel Class::Accessor::Fast);

use Wx qw(:combobox :font wxNOT_FOUND);
use Wx::Event qw(EVT_CHOICE EVT_BUTTON);

__PACKAGE__->mk_ro_accessors( qw(choice sortedchoice) );

sub new {
    my( $class, $parent ) = @_;
    my $self = $class->SUPER::new( $parent );

    my $choices = [ 'This', 'is one of my',
                    'really', 'wonderful', 'examples', ];

    $self->{choice} = Wx::Choice->new( $self, -1, [10, 10],
                                       [120, -1], $choices );
    $self->{sortedchoice} = Wx::Choice->new( $self, -1,
                                             [10, 70], [120, -1], $choices,
                                             wxCB_SORT );
    $self->choice->SetSelection( 2 );
    $self->choice->SetBackgroundColour( Wx::Colour->new( "red" ) );

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

    EVT_BUTTON( $self, $b1, \&OnChoiceButtons_SelNum );
    EVT_BUTTON( $self, $b2, \&OnChoiceButtons_SelStr );
    EVT_BUTTON( $self, $b3, \&OnChoiceButtons_Clear );
    EVT_BUTTON( $self, $b4, \&OnChoiceButtons_Append );
    EVT_BUTTON( $self, $b5, \&OnChoiceButtons_Delete );
    EVT_BUTTON( $self, $b6, \&OnChoiceButtons_Font );
    EVT_CHOICE( $self, $self->choice, \&OnChoice );
    EVT_CHOICE( $self, $self->sortedchoice, \&OnChoice );

    return $self;
}

sub OnChoice {
    my( $self, $event ) = @_;
    my( $choice ) = $event->GetId() == $self->choice->GetId ?
                        $self->choice : $self->sortedchoice;

    Wx::LogMessage( join '', "Choice event selection string is: '",
                               $event->GetString(), "'" );
    Wx::LogMessage( "Choice control selection string is: '",
                    $choice->GetStringSelection(), "'" );
}

sub OnChoiceButtons_SelNum {
    my( $self, $event ) = @_;

    $self->choice->SetSelection( 2 );
    $self->sortedchoice->SetSelection( 2 );
}

sub OnChoiceButtons_SelStr {
    my( $self, $event ) = @_;

    $self->choice->SetStringSelection( "This" );
    $self->sortedchoice->SetStringSelection( "This" );
}

sub OnChoiceButtons_Clear {
    my( $self ) = @_;

    $self->choice->Clear();
    $self->sortedchoice->Clear();
}

sub OnChoiceButtons_Append {
    my( $self ) = @_;

    $self->choice->Append( 'Hi!' );
    $self->sortedchoice->Append( 'Hi!' );
}

sub OnChoiceButtons_Delete {
    my( $self ) = @_;
    my( $idx );

    if( ( $idx = $self->choice->GetSelection() ) != wxNOT_FOUND ) {
        $self->choice->Delete( $idx );
    }
    if( ( $idx = $self->sortedchoice->GetSelection() ) != wxNOT_FOUND ) {
        $self->sortedchoice->Delete( $idx );
    }
}

sub OnChoiceButtons_Font {
    my( $self ) = @_;

    $self->choice->SetFont( wxITALIC_FONT );
    $self->sortedchoice->SetFont( wxITALIC_FONT );
}

sub add_to_tags { qw(controls) }
sub title { 'wxChoice' }

1;
