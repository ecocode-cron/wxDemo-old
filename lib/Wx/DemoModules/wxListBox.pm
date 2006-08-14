#############################################################################
## Name:        lib/Wx/DemoModules/wxListBox.pm
## Purpose:     wxPerl demo helper for Wx::ListBox
## Author:      Mattia Barbon
## Modified by:
## Created:     13/08/2006
## RCS-ID:      $Id: wxListBox.pm,v 1.1 2006/08/14 20:00:50 mbarbon Exp $
## Copyright:   (c) 2000, 2003, 2005-2006 Mattia Barbon
## Licence:     This program is free software; you can redistribute it and/or
##              modify it under the same terms as Perl itself
#############################################################################

package Wx::DemoModules::wxListBox;

use strict;
use base qw(Wx::Panel Class::Accessor::Fast);

use Wx qw(:listbox :font wxNOT_FOUND);
use Wx::Event qw(EVT_LISTBOX EVT_LISTBOX_DCLICK EVT_BUTTON);

__PACKAGE__->mk_ro_accessors( qw(listbox sortedlistbox) );

sub new {
    my( $class, $parent ) = @_;
    my $self = $class->SUPER::new( $parent );

    my $choices = [ 'This', 'is one of my',
                    'really', 'wonderful', 'examples', ];

    $self->{listbox} = Wx::ListBox->new( $self, -1, [10, 10],
                                         [120, 70], [], wxLB_ALWAYS_SB );
    $self->{sortedlistbox} = Wx::ListBox->new( $self, -1,
                                               [10, 90], [120, 70],
                                               $choices, wxLB_SORT );
    $self->listbox->SetToolTip( "This is a list box" );

    $self->listbox->Set( $choices );

    SetControlClientData( 'listbox', $self->listbox );
    SetControlClientData( 'listbox', $self->sortedlistbox );

    my $select_2 = Wx::Button->new( $self, -1, 'Select #&2',
                                    [180, 30], [140, 30] );
    my $select_This = Wx::Button->new( $self, -1, '&Select \'This\'',
                                       [340, 30], [140, 30] );
    my $b1 = Wx::Button->new( $self, -1, '&Clear', [180, 80], [140, 30] );
    my $b2 = Wx::Button->new( $self, -1, '&Append \'Hi!\'', [340, 80 ], [140, 30] );
    my $b3 = Wx::Button->new( $self, -1, 'D&elete selected item',
                                 [180, 130], [140, 30] );
    my $button = Wx::Button->new( $self, -1, 'Set &Italic font',
                                   [340, 130], [140, 30] );
    $button->SetDefault();
    $button->SetToolTip( "Press here to set Italic font" );

    EVT_LISTBOX( $self, $self->listbox, \&OnListBox );
    EVT_LISTBOX( $self, $self->sortedlistbox, \&OnListBox );
    EVT_LISTBOX_DCLICK( $self, $self->listbox, \&OnListBoxDoubleClick );
    EVT_BUTTON( $self, $select_2, \&OnListBoxButtons_SelNum );
    EVT_BUTTON( $self, $select_This, \&OnListBoxButtons_SelStr );
    EVT_BUTTON( $self, $b1, \&OnListBoxButtons_Clear );
    EVT_BUTTON( $self, $b2, \&OnListBoxButtons_Append );
    EVT_BUTTON( $self, $b3, \&OnListBoxButtons_Delete );
    EVT_BUTTON( $self, $button, \&OnListBoxButtons_Font );

    return $self;
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

    my( $lb ) = $event->GetId() == $self->listbox->GetId ?
      $self->listbox : $self->sortedlistbox ;

    Wx::LogMessage( join '', "ListBox Event selection string is '",
                             $event->GetString(), "'" );
    Wx::LogMessage( join '', "ListBox Control selection string is '",
                             $lb->GetStringSelection(), "'" );

    my $cde = $event->GetClientData();
    my $cdl = $lb->GetClientData( $lb->GetSelection() );
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
    $self->sortedlistbox->SetSelection( 2 );
}

sub OnListBoxButtons_SelStr {
    my( $self, $event ) = @_;

    $self->listbox->SetStringSelection( "This" );
    $self->sortedlistbox->SetStringSelection( "This" );
}

sub OnListBoxButtons_Clear {
    my( $self ) = @_;

    $self->listbox->Clear();
    $self->sortedlistbox->Clear();
}

sub OnListBoxButtons_Append {
    my( $self ) = @_;

    $self->listbox->Append( 'Hi!' );
    $self->sortedlistbox->Append( 'Hi!' );
}

sub OnListBoxButtons_Delete {
    my( $self ) = @_;
    my( $idx );

    if( ( $idx = $self->listbox->GetSelection() ) != wxNOT_FOUND ) {
        $self->listbox->Delete( $idx );
    }
    if( ( $idx = $self->sortedlistbox->GetSelection() ) != wxNOT_FOUND ) {
        $self->sortedlistbox->Delete( $idx );
    }
}

sub OnListBoxButtons_Font {
    my( $self ) = @_;

    $self->listbox->SetFont( wxITALIC_FONT );
    $self->sortedlistbox->SetFont( wxITALIC_FONT );
}

sub add_to_tags { qw(controls) }
sub title { 'wxListBox' }

1;
