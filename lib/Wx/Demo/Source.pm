package Wx::Demo::Source;

use strict;

use Wx qw(:stc :textctrl :font wxDefaultPosition wxDefaultSize
          wxNO_FULL_REPAINT_ON_RESIZE wxLayout_LeftToRight);

our @ISA = ( eval 'require Wx::STC' ) ? 'Wx::StyledTextCtrl' : 'Wx::TextCtrl';

sub new {
    my( $class, $parent ) = @_;
    my $self;

    if( $class->isa( 'Wx::TextCtrl' ) ) {
        $self = $class->SUPER::new
          ( $parent, -1, '', wxDefaultPosition, wxDefaultSize,
            wxTE_READONLY|wxTE_MULTILINE|wxNO_FULL_REPAINT_ON_RESIZE );
    } else {
        $self = $class->SUPER::new( $parent, -1, [-1, -1], [300, 300] );
        my $font = Wx::Font->new( 10, wxTELETYPE, wxNORMAL, wxNORMAL );

        $self->SetFont( $font );
        $self->StyleSetFont( wxSTC_STYLE_DEFAULT, $font );
        $self->StyleClearAll();

        $self->StyleSetForeground(0, Wx::Colour->new(0x00, 0x00, 0x7f));
        $self->StyleSetForeground(1,  Wx::Colour->new(0xff, 0x00, 0x00));

        # 2 Comment line green
        $self->StyleSetForeground(2,  Wx::Colour->new(0x00, 0x7f, 0x00));
        $self->StyleSetForeground(3,  Wx::Colour->new(0x7f, 0x7f, 0x7f));

        # 4 numbers
        $self->StyleSetForeground(4,  Wx::Colour->new(0x00, 0x7f, 0x7f));
        $self->StyleSetForeground(5,  Wx::Colour->new(0x00, 0x00, 0x7f));

        # 6 string orange
        $self->StyleSetForeground(6,  Wx::Colour->new(0xff, 0x7f, 0x00));

        $self->StyleSetForeground(7,  Wx::Colour->new(0x7f, 0x00, 0x7f));

        $self->StyleSetForeground(8,  Wx::Colour->new(0x00, 0x00, 0x00));

        $self->StyleSetForeground(9,  Wx::Colour->new(0x7f, 0x7f, 0x7f));

        # 10 operators dark blue
        $self->StyleSetForeground(10, Wx::Colour->new(0x00, 0x00, 0x7f));

        # 11 identifiers bright blue
        $self->StyleSetForeground(11, Wx::Colour->new(0x00, 0x00, 0xff));

        # 12 scalars purple
        $self->StyleSetForeground(12, Wx::Colour->new(0x7f, 0x00, 0x7f));

        # 13 array light blue
        $self->StyleSetForeground(13, Wx::Colour->new(0x40, 0x80, 0xff));

        # 17 matching regex red
        $self->StyleSetForeground(17, Wx::Colour->new(0xff, 0x00, 0x7f));

        # 18 substitution regex light olive
        $self->StyleSetForeground(18, Wx::Colour->new(0x7f, 0x7f, 0x00));

        #Set a style 12 bold
        $self->StyleSetBold(12,  1);

        # Apply tag style for selected lexer (blue)
        $self->StyleSetSpec( wxSTC_H_TAG, "fore:#0000ff" );

        $self->SetLexer( wxSTC_LEX_PERL );
    }

    $self->SetLayoutDirection( wxLayout_LeftToRight )
      if $self->can( 'SetLayoutDirection' );

    return $self;
}

sub set_source {
    my( $self ) = @_;

    if( $self->isa( 'Wx::TextCtrl' ) ) {
        $self->SetValue( $_[1] );
    } else {
        $self->SetText( $_[1] );
    }
}

1;