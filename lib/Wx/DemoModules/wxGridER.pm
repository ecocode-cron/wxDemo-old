#############################################################################
## Name:        lib/Wx/DemoModules/wxGridER.pm
## Purpose:     wxPerl demo helper for wxGrid editors and renderers
## Author:      Mattia Barbon
## Modified by:
## Created:     05/06/2003
## RCS-ID:      $Id: wxGridER.pm,v 1.2 2006/11/21 21:06:19 mbarbon Exp $
## Copyright:   (c) 2003, 2006 Mattia Barbon
## Licence:     This program is free software; you can redistribute it and/or
##              modify it under the same terms as Perl itself
#############################################################################

package Wx::DemoModules::wxGridER;

use strict;
use base 'Wx::Grid';

sub new {
  my $class = shift;
  my $this = $class->SUPER::new( $_[0], -1 );
  $this->CreateGrid( 13, 7 );
  # set every cell read-only
  for my $x ( 1 .. 7 ) { # cols
    for my $y ( 1 .. 13 ) { # rows
      $this->SetReadOnly( $y, $x, 1 ); # rows, cols
    }
  }

  $this->SetColSize( 0, 20 );
  $this->SetColSize( 1, 150 );
  $this->SetColSize( 2, 150 );
  $this->SetColSize( 3, 20 );
  $this->SetColSize( 4, 150 );
  $this->SetColSize( 5, 100 );
  $this->SetColSize( 6, 20 );

  $this->SetCellValue( 1, 1, "Default editor and renderer" );
  $this->SetCellValue( 1, 2, "Test 1" );

  $this->SetCellValue( 3, 1, "Float editor" );
  $this->SetCellValue( 3, 2, "1.00" );
  $this->SetCellEditor( 3, 2, Wx::GridCellFloatEditor->new() );
  # set read-write
  $this->SetReadOnly( 3, 2, 0 );

  $this->SetCellValue( 5, 1, "Bool editor" );
  $this->SetCellValue( 5, 2, "1" );
  $this->SetCellEditor( 5, 2, Wx::GridCellBoolEditor->new() );
  # set read-write
  $this->SetReadOnly( 5, 2, 0 );

  $this->SetCellValue( 7, 1, "Number editor" );
  $this->SetCellValue( 7, 2, "14" );
  $this->SetCellEditor( 7, 2, Wx::GridCellNumberEditor->new( 12, 20 ) );
  # set read-write
  $this->SetReadOnly( 7, 2, 0 );

  $this->SetCellValue( 9, 1, "Choice editor" );
  $this->SetCellValue( 9, 2, "Test" );
  $this->SetCellEditor( 9, 2, Wx::GridCellChoiceEditor->new( [qw(This Is a Test) ] ) );
  # set read-write
  $this->SetReadOnly( 9, 2, 0 );

  eval { # in case gridctrl renderers are not wrapped

  $this->SetCellValue( 11, 1, "Auto Wrap Editor" );
  $this->SetCellValue( 11, 2, "Multiple lines of text are displayed wrapped in the cell. AutoSize is set on to display the contents" );
  $this->SetCellEditor( 11, 2, Wx::GridCellAutoWrapStringEditor->new() );
  $this->SetCellRenderer( 11, 2, Wx::GridCellAutoWrapStringRenderer->new() );
  $this->AutoSizeRow( 11, 1 );
  # set read-write
  $this->SetReadOnly( 11, 2, 0 );

  $this->SetCellValue( 11, 4, "Enum Editor & Renderer" );
  $this->SetCellEditor( 11, 5, Wx::GridCellEnumEditor->new('First,Second,Third,Fourth,Fifth') );
  $this->SetCellValue( 11, 5, 1 );
  #$this->SetCellRenderer( 11, 5, Wx::GridCellEnumRenderer->new('First Choice,Second Choice,Third Choice') );
  # GridCellEnumRenderer can only work with Wx::PlGridTable as values must be of type 'long' - so made custom renderer
  $this->SetCellRenderer( 11, 5, Wx::DemoModules::wxGridER::EnumRenderer->new('Selected First,Selected Second,Selected Third,Selected Fourth') ); 
  # set read-write
  $this->SetReadOnly( 11, 5, 0 );

  };

  $this->SetCellValue( 3, 4, "Float renderer" );
  $this->SetCellValue( 3, 5, "1.00" );
  $this->SetCellRenderer( 3, 5, Wx::GridCellFloatRenderer->new( 12, 7 ) );
  $this->SetReadOnly( 3, 5, 0 );

  $this->SetCellValue( 5, 4, "Bool renderer" );
  $this->SetCellValue( 5, 5, "1" );
  $this->SetCellRenderer( 5, 5, Wx::GridCellBoolRenderer->new() );
  $this->SetReadOnly( 5, 5, 0 );

  $this->SetCellValue( 7, 4, "Number renderer" );
  $this->SetCellValue( 7, 5, "12" );
  $this->SetCellRenderer( 7, 5, Wx::GridCellNumberRenderer->new() );
  $this->SetReadOnly( 7, 5, 0 );

  return $this;
}

sub add_to_tags { 'controls/grid' }
sub title { 'Editors and renderers' }

package Wx::DemoModules::wxGridER::EnumRenderer;

use strict;
use base 'Wx::PlGridCellRenderer';
use Wx qw(wxBLACK_PEN wxWHITE_BRUSH wxSYS_DEFAULT_GUI_FONT);

sub new {
    my $class = shift;
    my $params = shift || undef;
    my $self = $class->SUPER::new();
    $self->{__params} = [];
    $self->SetParameters($params) if($params);
    return $self;
}


sub Draw {
  my( $self, $grid, $attr, $dc, $rect, $row, $col, $sel ) = ( shift, @_ );

  $self->SUPER::Draw( @_ );
  $dc->SetFont(Wx::SystemSettings::GetFont(wxSYS_DEFAULT_GUI_FONT ));
  my $enum;
  if( exists($self->{__params}->[$grid->GetCellValue( $row, $col )])) {
      $enum = $self->{__params}->[$grid->GetCellValue( $row, $col )];
  } else {
      $enum = $grid->GetCellValue( $row, $col );
  }

  $dc->DrawText( $enum, $rect->x, $rect->y );
}

sub SetParameters {
    my $self = shift;
    my $params = shift;
    $self->{__params} = [ split /,/, $params ]; 
}

sub Clone {
  my $self = shift;

  return $self->new;
}


1;
