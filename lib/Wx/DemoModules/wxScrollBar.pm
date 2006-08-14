#############################################################################
## Name:        lib/Wx/DemoModules/wxScrollBar.pm
## Purpose:     wxPerl demo helper for Wx::ScrollBar
## Author:      Mattia Barbon
## Modified by:
## Created:     27/05/2003
## RCS-ID:      $Id: wxScrollBar.pm,v 1.1 2006/08/14 20:00:43 mbarbon Exp $
## Copyright:   (c) 2003, 2005-2006 Mattia Barbon
## Licence:     This program is free software; you can redistribute it and/or
##              modify it under the same terms as Perl itself
#############################################################################

package Wx::DemoModules::wxScrollBar;

use strict;
use base qw(Wx::Panel);
use Wx qw(:sizer wxWHITE wxHORIZONTAL wxVERTICAL);

sub log_scroll_event {
  my( $event, $type ) = @_;

  Wx::LogMessage( 'Scroll %s event: orientation = %s, position = %d', $type,
                  ( ( $event->GetOrientation == wxHORIZONTAL ) ? 'horizontal' : 'vertical' ),
                  $event->GetPosition );

  # important! skip event for default processing to happen
  $event->Skip;
}

use Wx::Event qw(/EVT_SCROLL_*/);
use Wx qw(:scrollbar wxDefaultSize);

sub new {
  my $class = shift;
  my $parent = shift;
  my $this = $class->SUPER::new( $parent, -1 );

  my $horizontal = Wx::ScrollBar->new( $this, -1, [ 60, 20 ], [ 150, -1 ],
                                       wxSB_HORIZONTAL );
  my $vertical   = Wx::ScrollBar->new( $this, -1, [ 20, 20 ], [ -1, 150 ],
                                       wxSB_VERTICAL );

  $horizontal->SetScrollbar( 0, 80, 100, 10 );
  $vertical->SetScrollbar( 0, 80, 100, 10 );

  for my $this ( $horizontal, $vertical ) {
    EVT_SCROLL_TOP( $this,
                    sub { log_scroll_event( $_[1], 'to top' ) } );
    EVT_SCROLL_BOTTOM( $this,
                       sub { log_scroll_event( $_[1], 'to bottom' ) } );
    EVT_SCROLL_LINEUP( $this,
                       sub { log_scroll_event( $_[1], 'a line up' ) } );
    EVT_SCROLL_LINEDOWN( $this,
                         sub { log_scroll_event( $_[1], 'a line down' ) } );
    EVT_SCROLL_PAGEUP( $this,
                       sub { log_scroll_event( $_[1], 'a page up' ) } );
    EVT_SCROLL_PAGEDOWN( $this,
                         sub { log_scroll_event( $_[1], 'a page down' ) } );
#    EVT_SCROLL_THUMBTRACK( $this,
#                           sub { log_scroll_event( $_[1], 'thumbtrack' ) } );
    EVT_SCROLL_THUMBRELEASE( $this,
                             sub { log_scroll_event( $_[1], 'thumbrelease' ) } );
}

  return $this;
}

sub add_to_tags { qw(controls) }
sub title { 'wxScrollBar' }

1;
