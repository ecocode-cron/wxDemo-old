#############################################################################
## Name:        lib/Wx/DemoModules/wxListBox.pm
## Purpose:     wxPerl demo helper for Wx::ListBox
## Author:      Mattia Barbon
## Modified by:
## Created:     13/08/2006
## RCS-ID:      $Id: wxListBox.pm,v 1.2 2006/08/25 21:19:03 mbarbon Exp $
## Copyright:   (c) 2000, 2003, 2005-2006 Mattia Barbon
## Licence:     This program is free software; you can redistribute it and/or
##              modify it under the same terms as Perl itself
#############################################################################

package Wx::DemoModules::wxListBox;

use strict;
use base qw(Wx::DemoModules::lib::BaseModule Class::Accessor::Fast);

use Wx qw(:listbox wxNOT_FOUND);
use Wx::Event qw(EVT_LISTBOX EVT_LISTBOX_DCLICK);

__PACKAGE__->mk_accessors( qw(listbox) );

sub styles {
    my( $self ) = @_;

    return ( [ wxLB_SORT, 'Sorted' ],
             [ wxLB_ALWAYS_SB, 'Always show scrollbars' ],
             [ wxLB_HSCROLL, 'Horizontal scrollbar' ],
             [ wxLB_SINGLE, 'Single selection' ],
             [ wxLB_MULTIPLE, 'Multiple selection' ],
             [ wxLB_EXTENDED, 'Extended selection' ],
             );
}

sub commands {
    my( $self ) = @_;

    return ( { label       => 'Select #2',
               action      => \&OnListBoxButtons_SelNum,
               },
             { label       => 'Select \'This\'',
               action      => \&OnListBoxButtons_SelStr,
               },
             { label       => 'Clear',
               action      => \&OnListBoxButtons_Clear,
               },
             { label       => 'Append \'Hi!\'',
               action      => \&OnListBoxButtons_Append,
               },
             { label       => 'Delete selected item',
               action      => \&OnListBoxButtons_Delete,
               },
               );
}

sub create_control {
    my( $self ) = @_;

    my $choices = [ 'This', 'is one of my',
                    'really', 'wonderful', 'examples', ];

    my $listbox = Wx::ListBox->new( $self, -1, [-1, -1],
                                    [-1, -1], $choices, $self->style );
    SetControlClientData( 'listbox', $listbox );

    EVT_LISTBOX( $self, $listbox, \&OnListBox );
    EVT_LISTBOX_DCLICK( $self, $listbox, \&OnListBoxDoubleClick );

    return $self->listbox( $listbox );
}

sub SetControlClientData {
    my( $name, $ctrl ) = @_;

    foreach my $i ( 1 .. $ctrl->GetCount() ) {
        my $text = $ctrl->GetString( $i - 1 );

        $ctrl->SetClientData( $i - 1, "$name client data for $text" );
    }
}

sub OnListBox {
    my( $self, $event ) = @_;

    if( $event->GetInt() == -1 ) {
        Wx::LogMessage( "List box has no selections any more" );
        return;
    }

    Wx::LogMessage( join '', "ListBox Event selection string is '",
                             $event->GetString(), "'" );
    Wx::LogMessage( join '', "ListBox Control selection string is '",
                             $self->listbox->GetStringSelection(), "'" );

    my $cde = $event->GetClientData();
    my $cdl = $self->listbox->GetClientData( $self->listbox->GetSelection() );
    Wx::LogMessage( join '', "ListBox Event client data is '",
                             ( $cde ? $cde : 'none' ) , "'" );
    Wx::LogMessage( join '', "ListBox Control client data is '",
                             ( $cdl ? $cdl : 'none' ) );
}

sub OnListBoxDoubleClick {
    my( $self, $event ) = @_;

    Wx::LogMessage( join '', "ListBox double click string is '",
                             $event->GetString(), "'" ) ;
}

sub OnListBoxButtons_SelNum {
    my( $self, $event ) = @_;

    $self->listbox->SetSelection( 2 );
}

sub OnListBoxButtons_SelStr {
    my( $self, $event ) = @_;

    $self->listbox->SetStringSelection( "This" );
}

sub OnListBoxButtons_Clear {
    my( $self ) = @_;

    $self->listbox->Clear();
}

sub OnListBoxButtons_Append {
    my( $self ) = @_;

    $self->listbox->Append( 'Hi!' );
}

sub OnListBoxButtons_Delete {
    my( $self ) = @_;
    my( $idx );

    if( ( $idx = $self->listbox->GetSelection() ) != wxNOT_FOUND ) {
        $self->listbox->Delete( $idx );
    }
}

sub add_to_tags { qw(controls) }
sub title { 'wxListBox' }

1;
