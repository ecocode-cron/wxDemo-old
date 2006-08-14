#############################################################################
## Name:        lib/Wx/DemoModules/wxStaticText.pm
## Purpose:     wxPerl demo helper for Wx::StaticText
## Author:      Mattia Barbon
## Modified by:
## Created:     13/08/2006
## RCS-ID:      $Id: wxStaticText.pm,v 1.1 2006/08/14 20:00:51 mbarbon Exp $
## Copyright:   (c) 2000, 2003, 2005-2006 Mattia Barbon
## Licence:     This program is free software; you can redistribute it and/or
##              modify it under the same terms as Perl itself
#############################################################################

package Wx::DemoModules::wxStaticText;

use strict;
use base qw(Wx::Panel Class::Accessor::Fast);

use Wx qw();
use Wx::Event qw(EVT_BUTTON);

__PACKAGE__->mk_ro_accessors( qw(statictext1 statictext2) );

sub new {
    my( $class, $parent ) = @_;
    my $self = $class->SUPER::new( $parent );

    $self->{statictext1} =
      Wx::StaticText->new( $self, -1, 'A label', [10, 10] );
    $self->{statictext2} =
      Wx::StaticText->new( $self, -1, '', [80, 10] );

    EVT_BUTTON( $self, Wx::Button->new( $self, -1, 'Set text', [10, 80] ),
                \&OnSetText );

    return $self;
}

sub OnSetText {
    my( $self, $event ) = @_;

    $self->statictext2->SetLabel( 'A l' . 'o' x 40 . 'ng text' );
}

sub add_to_tags { qw(controls) }
sub title { 'wxStaticText' }

1;
