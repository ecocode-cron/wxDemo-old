#############################################################################
## Name:        lib/Wx/DemoModules/lib/BaseModule.pm
## Purpose:     wxPerl demo helper base class
## Author:      Mattia Barbon
## Modified by:
## Created:     25/08/2006
## RCS-ID:      $Id: BaseModule.pm,v 1.1 2006/08/25 21:19:04 mbarbon Exp $
## Copyright:   (c) 2006 Mattia Barbon
## Licence:     This program is free software; you can redistribute it and/or
##              modify it under the same terms as Perl itself
#############################################################################

package Wx::DemoModules::lib::BaseModule;

use strict;
use base qw(Wx::Panel Class::Accessor::Fast);

use Wx qw(:sizer);
use Wx::Event qw(EVT_CHECKBOX EVT_BUTTON EVT_SIZE);

__PACKAGE__->mk_accessors( qw(style control_sizer) );

sub new {
    my( $class, $parent ) = @_;
    my $self = $class->SUPER::new( $parent );

    my $sizer = Wx::BoxSizer->new( wxHORIZONTAL );

    $self->style( 0 );
    $self->add_styles( $sizer );
    $self->add_commands( $sizer );

    my $box = Wx::StaticBox->new( $self, -1, 'Control' );
    my $ctrlsz = Wx::StaticBoxSizer->new( $box, wxVERTICAL );

    $self->control_sizer( $ctrlsz );
    $ctrlsz->Add( $self->create_control, 0, wxALL|wxALIGN_CENTER_HORIZONTAL|wxALIGN_CENTER_VERTICAL, 5 );
    $sizer->Add( $ctrlsz, 1, wxGROW|wxALL, 5 );

    $self->SetSizerAndFit( $sizer );

    return $self;
}

sub add_styles {
    my( $self, $topsizer ) = @_;
    my @styles = $self->styles;

    return unless @styles;

    my $box = Wx::StaticBox->new( $self, -1, 'Styles' );
    my $sizer = Wx::StaticBoxSizer->new( $box, wxVERTICAL );

    foreach my $style ( @styles ) {
        my $cbox = Wx::CheckBox->new( $self, -1, $style->[1] );
        EVT_CHECKBOX( $self, $cbox, sub {
                          my( $self, $event ) = @_;

                          if( $event->GetInt ) {
                              $self->style( $self->style | $style->[0] );
                          } else {
                              $self->style( $self->style & ~$style->[0] );
                          }
                          $self->recreate_control;
                      } );
        $sizer->Add( $cbox, 0, wxGROW|wxALL, 3 );
    }

    $topsizer->Add( $sizer, 0, wxGROW|wxALL, 5 );
}

sub add_commands {
    my( $self, $topsizer ) = @_;
    my @commands = $self->commands;

    return unless @commands;

    my $box = Wx::StaticBox->new( $self, -1, 'Commands' );
    my $sizer = Wx::StaticBoxSizer->new( $box, wxVERTICAL );

    foreach my $command ( @commands ) {
        if( $command->{with_value} ) {
            my $sz = Wx::BoxSizer->new( wxHORIZONTAL );
            my $but = Wx::Button->new( $self, -1, $command->{label} );
            my $val = Wx::TextCtrl->new( $self, -1, '' );
            $sz->Add( $but, 1, wxRIGHT, 5 );
            $sz->Add( $val, 1 );
            EVT_BUTTON( $self, $but, sub {
                            $command->{action}->( $val->GetValue );
                        } );
            $sizer->Add( $sz, 0, wxGROW|wxALL, 3 );
        } else {
            my $but = Wx::Button->new( $self, -1, $command->{label} );
            EVT_BUTTON( $self, $but, $command->{action} );
            $sizer->Add( $but, 0, wxGROW|wxALL, 3 );
        }
    }

    $topsizer->Add( $sizer, 0, wxGROW|wxALL, 5 );
}

sub recreate_control {
    my( $self ) = @_;

    $self->control_sizer->GetItem( 0 )->DeleteWindows;
    $self->control_sizer->Detach( 0 );

    $self->control_sizer->Add( $self->create_control,
                               0, wxALL|wxALIGN_CENTER_HORIZONTAL|wxALIGN_CENTER_VERTICAL, 5 );
    $self->Layout;
}

sub styles { }
sub commands { }

1;
