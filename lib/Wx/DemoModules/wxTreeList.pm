#############################################################################
## Name:        lib/Wx/DemoModules/wxTreeList.pm
## Purpose:     wxPerl demo helper for Wx::TreeListCtrl
## Author:      Mattia Barbon
## Modified by:
## Created:     13/08/2006
## RCS-ID:      $Id: wxTreeList.pm,v 1.1 2006/08/17 18:20:57 netcon Exp $
## Copyright:   (c) 2000, 2003, 2005-2006 Mattia Barbon
## Licence:     This program is free software; you can redistribute it and/or
##              modify it under the same terms as Perl itself
#############################################################################

package Wx::DemoModules::wxTreeList;

use strict;
use base qw(Wx::Panel Class::Accessor::Fast);

use Wx::TreeListCtrl;
use Wx qw( :treelist :listctrl wxDefaultPosition wxDefaultSize );

#use Wx::Event qw(EVT_SLIDER);

__PACKAGE__->mk_ro_accessors( qw(treelist) );

sub new {
    my( $class, $parent ) = @_;
    my $self = $class->SUPER::new( $parent );

    my $tree = $self->{treelist} = Wx::TreeListCtrl->new( $self, -1,
		wxDefaultPosition, [400,200],
		wxTR_HIDE_ROOT | wxTR_ROW_LINES | wxTR_HAS_VARIABLE_ROW_HEIGHT | wxTR_HAS_BUTTONS
		| wxTR_FULL_ROW_HIGHLIGHT | wxTR_NO_LINES | wxTR_SHOW_ROOT_LABEL_ONLY
	);

    #EVT_SLIDER( $self, $self->slider, \&OnSlider );

	# now add the columns
	$tree->AddColumn( "Column Three",	120, wxLIST_FORMAT_LEFT );
	$tree->InsertColumn( 0, "Column Two",		120, wxLIST_FORMAT_LEFT );
	$tree->InsertColumn( 0, "Column One",		120, wxLIST_FORMAT_LEFT );

	my $root = $tree->AddRoot( 'Root Item' );
	my $item1 = $tree->AppendItem( $root, 'First Top Level Tree Item Is Very Long' );
	$tree->SetItemHeight( $item1, 120 );
	$tree->SetItemBold( $item1, 1 );
	$tree->SetItemTextColour( $item1, Wx::Colour->new( 22, 14, 135 ));
	$tree->SetItemBackgroundColour( $item1, Wx::Colour->new( 160, 184, 255 ));
	my $child1 = $tree->AppendItem( $item1, 'Child #1' );
	my $child2 = $tree->AppendItem( $item1, 'Child #2' );
	my $child3 = $tree->AppendItem( $item1, 'Child #3' );
	$tree->SetItemText( $child1, 1, "Child #1 - Column 2" );
	$tree->SetItemText( $child1, 2, "Child #1 - Column 3" );
	$tree->SetItemText( $child2, 1, "Child #2 - Column 2" );
	$tree->SetItemText( $child2, 2, "Child #2 - Column 3" );
	$tree->SetItemText( $child3, 1, "Child #3 - Column 2" );
	$tree->SetItemText( $child3, 2, "Child #3 - Column 3" );

	my $item2 = $tree->AppendItem( $root, 'Second Tree Item Is Also Long' );
	$tree->SetItemBold( $item2, 1 );
	$tree->SetItemTextColour( $item2, Wx::Colour->new( 178, 12, 48 ));
	$tree->SetItemBackgroundColour( $item2, Wx::Colour->new( 255, 211, 135 ));
	my $childA = $tree->AppendItem( $item2, 'Child A' );
	my $childB = $tree->AppendItem( $item2, 'Child B' );
	my $childC = $tree->AppendItem( $item2, 'Child C' );
	$tree->SetItemText( $childA, 1, "Child A - Column 2" );
	$tree->SetItemText( $childA, 2, "Child A - Column 3" );
	$tree->SetItemText( $childB, 1, "Child B - Column 2" );
	$tree->SetItemText( $childB, 2, "Child B - Column 3" );
	$tree->SetItemText( $childC, 1, "Child C - Column 2" );
	$tree->SetItemText( $childC, 2, "Child C - Column 3" );

	$tree->ExpandAll( $tree->GetRootItem );

	return $self;
}

sub OnSlider {
    my( $self, $event ) = @_;
    my( $slider ) = $self->slider;

    Wx::LogMessage( join '', 'Event position: ', $event->GetInt );
    Wx::LogMessage( join '', 'Slider position: ', $slider->GetValue );
}

sub add_to_tags { qw(controls) }
sub title { 'wxTreeList' }

1;
