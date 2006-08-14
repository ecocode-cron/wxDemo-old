#############################################################################
## Name:        lib/Wx/DemoModules/wxStaticBitmap.pm
## Purpose:     wxPerl demo helper for Wx::StaticBitmap
## Author:      Mattia Barbon
## Modified by:
## Created:     13/08/2006
## RCS-ID:      $Id: wxStaticBitmap.pm,v 1.1 2006/08/14 20:00:51 mbarbon Exp $
## Copyright:   (c) 2000, 2003, 2005-2006 Mattia Barbon
## Licence:     This program is free software; you can redistribute it and/or
##              modify it under the same terms as Perl itself
#############################################################################

package Wx::DemoModules::wxStaticBitmap;

use strict;
use base qw(Wx::Panel Class::Accessor::Fast);

use Wx qw(:icon wxTheApp wxNullBitmap);
use Wx::Event qw(EVT_BUTTON);

__PACKAGE__->mk_ro_accessors( qw(staticbitmap1 staticbitmap2) );

sub new {
    my( $class, $parent ) = @_;
    my $self = $class->SUPER::new( $parent );

    my $icon = wxTheApp->GetStdIcon( wxICON_INFORMATION );
    $self->{staticbitmap1} =
      Wx::StaticBitmap->new( $self, -1, $icon, [10, 10] );
    $self->{staticbitmap2} =
      Wx::StaticBitmap->new( $self, -1, wxNullBitmap, [80, 10] );

    EVT_BUTTON( $self, Wx::Button->new( $self, -1, 'Set bitmap', [10, 80] ),
                \&OnSetBitmap );

    return $self;
}

sub OnSetBitmap {
    my( $self, $event ) = @_;

    $self->staticbitmap2->SetIcon( wxTheApp->GetStdIcon( wxICON_QUESTION ) );
}

sub add_to_tags { qw(controls) }
sub title { 'wxStaticBitmap' }

1;
