#############################################################################
## Name:        lib/Wx/DemoModules/wxListCtrl.pm
## Purpose:     wxPerl demo helper for Wx::ListCtrl
## Author:      Mattia Barbon
## Modified by:
## Created:     12/09/2001
## RCS-ID:      $Id: wxListCtrl.pm,v 1.1 2006/08/14 20:00:44 mbarbon Exp $
## Copyright:   (c) 2001, 2003-2004, 2006 Mattia Barbon
## Licence:     This program is free software; you can redistribute it and/or
##              modify it under the same terms as Perl itself
#############################################################################

package Wx::DemoModules::wxListCtrl;

use strict;
use Wx qw(:icon wxTheApp);

sub create_image_lists {
    my $images_sm = Wx::ImageList->new( 16, 16, 1 );
    my $images_no = Wx::ImageList->new( 32, 32, 1 );

    $images_sm->Add( Wx::GetWxPerlIcon( 1 ) );

    $images_no->Add( Wx::GetWxPerlIcon() );
    $images_no->Add( wxTheApp->GetStdIcon( wxICON_HAND ) );
    $images_no->Add( wxTheApp->GetStdIcon( wxICON_EXCLAMATION ) );
    $images_no->Add( wxTheApp->GetStdIcon( wxICON_ERROR ) );
    $images_no->Add( wxTheApp->GetStdIcon( wxICON_QUESTION ) );

    return ( $images_sm, $images_no );
}

sub tags { [ 'controls/listctrl', 'wxListCtrl' ] }

package Wx::DemoModules::wxListCtrl::Report;

use strict;
use base qw(Wx::ListView);

use Wx qw(:listctrl wxDefaultPosition wxDefaultSize);

sub new {
    my( $class, $parent ) = @_;
    my $self = $class->SUPER::new( $parent, -1, wxDefaultPosition,
                                   wxDefaultSize, wxLC_REPORT );

    my @names = ( "Cheese", "Apples", "Oranges" );

    my( $small, $normal ) = Wx::DemoModules::wxListCtrl::create_image_lists;
    $self->AssignImageList( $small, wxIMAGE_LIST_SMALL );
    $self->AssignImageList( $normal, wxIMAGE_LIST_NORMAL );

    $self->InsertColumn( 1, "Type" );
    $self->InsertColumn( 2, "Amount" );
    $self->InsertColumn( 3, "Price" );

    foreach my $i ( 0 .. 50 ) {
        my $t = ( rand() * 100 ) % 3;
        my $q = int( rand() * 100 );
        my $idx = $self->InsertImageStringItem( $i, $names[$t], 0 );
        $self->SetItem( $idx, 1, $q );
        $self->SetItem( $idx, 2, $q * ( $t + 1 ) );
    }

    return $self;
}

sub add_to_tags { qw(controls/listctrl) }
sub title { 'Report' }
sub file { __FILE__ }

package Wx::DemoModules::wxListCtrl::Icon;

use strict;
use base qw(Wx::ListView);

use Wx qw(:listctrl wxDefaultPosition wxDefaultSize);

sub new {
    my( $class, $parent ) = @_;
    my $self = $class->SUPER::new( $parent, -1, wxDefaultPosition,
                                   wxDefaultSize, wxLC_ICON );

    my( $small, $normal ) = Wx::DemoModules::wxListCtrl::create_image_lists;
    $self->AssignImageList( $small, wxIMAGE_LIST_SMALL );
    $self->AssignImageList( $normal, wxIMAGE_LIST_NORMAL );

    foreach my $i ( 0 .. 7 ) {
        my $idx = $self->InsertStringImageItem( $i, "Item $i", $i % 5 );
    }

    return $self;
}

sub add_to_tags { qw(controls/listctrl) }
sub title { 'Icon' }
sub file { __FILE__ }

package Wx::DemoModules::wxListCtrl::Virtual;

use strict;
use base qw(Wx::ListCtrl);
use Wx qw(:listctrl wxRED wxBLUE wxITALIC_FONT
          wxDefaultPosition wxDefaultSize);

sub new {
    my( $class, $parent ) = @_;
    my $self = $class->SUPER::new
      ( $parent, -1, wxDefaultPosition, wxDefaultSize,
        wxLC_REPORT | wxLC_VIRTUAL );

    $self->InsertColumn( 1, "Column 1" );
    $self->InsertColumn( 2, "Column 2" );
    $self->InsertColumn( 3, "Column 3" );
    $self->InsertColumn( 4, "Column 4" );
    $self->InsertColumn( 5, "Column 5" );
    $self->SetItemCount( 100000 );

    return $self;
}

sub OnGetItemText {
    my( $self, $item, $column ) = @_;

    return "( $item, $column )";
}

sub OnGetItemAttr {
    my( $self, $item ) = @_;

    my $attr = Wx::ListItemAttr->new;

    if( $item % 2 == 0 ) { $attr->SetTextColour( wxRED ) }
    if( $item % 3 == 0 ) { $attr->SetBackgroundColour( wxBLUE ) }
    if( $item % 5 == 0 ) { $attr->SetFont( wxITALIC_FONT ) }

    return $attr;
}

sub OnGetItemImage {
    return 0;
}

sub add_to_tags { qw(controls/listctrl) }
sub title { 'Virtual' }
sub file { __FILE__ }

1;
