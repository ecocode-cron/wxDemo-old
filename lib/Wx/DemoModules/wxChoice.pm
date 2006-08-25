#############################################################################
## Name:        lib/Wx/DemoModules/wxChoice.pm
## Purpose:     wxPerl demo helper for Wx::Choice
## Author:      Mattia Barbon
## Modified by:
## Created:     13/08/2006
## RCS-ID:      $Id: wxChoice.pm,v 1.2 2006/08/25 21:19:03 mbarbon Exp $
## Copyright:   (c) 2000, 2003, 2005-2006 Mattia Barbon
## Licence:     This program is free software; you can redistribute it and/or
##              modify it under the same terms as Perl itself
#############################################################################

package Wx::DemoModules::wxChoice;

use strict;
use base qw(Wx::DemoModules::lib::BaseModule Class::Accessor::Fast);

use Wx qw(:combobox wxNOT_FOUND);
use Wx::Event qw(EVT_CHOICE);

__PACKAGE__->mk_accessors( qw(choice) );

sub styles {
    my( $self ) = @_;

    return ( [ wxCB_SORT, 'Sorted' ],
             );
}

sub commands {
    my( $self ) = @_;

    return ( { label       => 'Select #2',
               action      => \&OnChoiceButtons_SelNum,
               },
             { label       => 'Select \'This\'',
               action      => \&OnChoiceButtons_SelStr,
               },
             { label       => 'Clear',
               action      => \&OnChoiceButtons_Clear,
               },
             { label       => 'Append \'Hi\'',
               action      => \&OnChoiceButtons_Append,
               },
             { label       => 'Delete selected item',
               action      => \&OnChoiceButtons_Delete,
               },
               );
}

sub create_control {
    my( $self ) = @_;

    my $choices = [ 'This', 'is one of my',
                    'really', 'wonderful', 'examples', ];

    my $choice =  Wx::Choice->new( $self, -1,
                                   [-1, -1], [120, -1], $choices,
                                   $self->style );
    EVT_CHOICE( $self, $choice, \&OnChoice );

    return $self->choice( $choice );
}

sub OnChoice {
    my( $self, $event ) = @_;

    Wx::LogMessage( join '', "Choice event selection string is: '",
                             $event->GetString(), "'" );
    Wx::LogMessage( "Choice control selection string is: '",
                    $self->choice->GetStringSelection(), "'" );
}

sub OnChoiceButtons_SelNum {
    my( $self, $event ) = @_;

    $self->choice->SetSelection( 2 );
}

sub OnChoiceButtons_SelStr {
    my( $self, $event ) = @_;

    $self->choice->SetStringSelection( "This" );
}

sub OnChoiceButtons_Clear {
    my( $self ) = @_;

    $self->choice->Clear();
}

sub OnChoiceButtons_Append {
    my( $self ) = @_;

    $self->choice->Append( 'Hi!' );
}

sub OnChoiceButtons_Delete {
    my( $self ) = @_;
    my( $idx );

    if( ( $idx = $self->choice->GetSelection() ) != wxNOT_FOUND ) {
        $self->choice->Delete( $idx );
    }
}

sub add_to_tags { qw(controls) }
sub title { 'wxChoice' }

1;
