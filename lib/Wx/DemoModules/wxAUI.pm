#############################################################################
## Name:        lib/Wx/DemoModules/wxAUI.pm
## Purpose:     AUI (Advanced User Interface) demo
## Author:      Mattia Barbon
## Modified by:
## Created:     12/11/2006
## RCS-ID:      $Id: wxAUI.pm,v 1.1 2006/11/12 17:21:29 mbarbon Exp $
## Copyright:   (c) 2006 Mattia Barbon
## Licence:     This program is free software; you can redistribute it and/or
##              modify it under the same terms as Perl itself
#############################################################################

package Wx::DemoModules::wxAUI;

use strict;
use base qw(Wx::Frame Class::Accessor::Fast);

use Wx::AUI;
use Wx qw(:misc :frame :toolbar :textctrl);
use Wx::Event qw();
use Wx::ArtProvider qw(:artid);

__PACKAGE__->mk_accessors( qw(manager) );

sub new {
    my( $class, $parent ) = @_;
    my $self = $class->SUPER::new
      ( $parent, -1, 'wxPerl AUI demo' );

    $self->manager( Wx::AuiManager->new );
    $self->manager->SetManagedWindow( $self );
    $self->SetIcon( Wx::GetWxPerlIcon );

    $self->SetSize( 500, 400 );

    my $tb1 = Wx::ToolBar->new( $self, -1, [-1, -1], [-1, -1], wxTB_FLAT );
    $tb1->AddTool( 101, "Test", Wx::ArtProvider::GetBitmap( wxART_ERROR ) );
    $tb1->AddTool( 102, "Test", Wx::ArtProvider::GetBitmap( wxART_ERROR ) );
    $tb1->AddTool( 103, "Test", Wx::ArtProvider::GetBitmap( wxART_ERROR ) );
    $tb1->AddTool( 104, "Test", Wx::ArtProvider::GetBitmap( wxART_ERROR ) );
    $tb1->Realize;

    my $tb2 = Wx::ToolBar->new( $self, -1, [-1, -1], [-1, -1], wxTB_FLAT );
    $tb2->AddTool( 101, "Test", Wx::ArtProvider::GetBitmap( wxART_WARNING ) );
    $tb2->AddTool( 102, "Test", Wx::ArtProvider::GetBitmap( wxART_WARNING ) );
    $tb2->AddTool( 103, "Test", Wx::ArtProvider::GetBitmap( wxART_WARNING ) );
    $tb2->AddTool( 104, "Test", Wx::ArtProvider::GetBitmap( wxART_WARNING ) );
    $tb2->Realize;

    $self->manager->AddPane
      ( $self->create_textctrl, Wx::AuiPaneInfo->new->Name( "text_control" )
        ->CenterPane );
    $self->manager->AddPane
      ( $self->create_textctrl, Wx::AuiPaneInfo->new->Name( "text_control" )
        ->CenterPane->TopDockable->BottomDockable->Floatable->Movable
        ->PinButton->Caption( "Floating" )->CaptionVisible->Float );

    $self->manager->AddPane
      ( $tb1, Wx::AuiPaneInfo->new->Name( "tb1" )->Caption( "Toolbar 1" )
        ->ToolbarPane->Top->Row( 1 )->LeftDockable( 0 )->RightDockable( 0 ) );
    $self->manager->AddPane
      ( $tb2, Wx::AuiPaneInfo->new->Name( "tb2" )->Caption( "Toolbar 2" )
        ->ToolbarPane->LeftDockable( 0 )->RightDockable( 0 )->Float );

    $self->manager->Update;

    return $self;
}

sub DESTROY {
    my( $self ) = @_;

    $self->manager->UnInit;
}

my $count = 0;
sub create_textctrl {
    my( $self, $text ) = @_;

    $text ||= sprintf "This is text box %d", ++$count;
    return Wx::TextCtrl->new( $self, -1, $text, [0, 0], [150, 90],
                              wxNO_BORDER | wxTE_MULTILINE );
}

sub add_to_tags { qw(managed) }
sub title { 'AUI' }

1;

