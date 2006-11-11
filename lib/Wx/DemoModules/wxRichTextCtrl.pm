#############################################################################
## Name:        lib/Wx/DemoModules/wxRichTextCtrl.pm
## Purpose:     wxPerl demo helper for Wx::SpinCtrl
## Author:      Mattia Barbon
## Modified by:
## Created:     11/11/2006
## RCS-ID:      $Id: wxRichTextCtrl.pm,v 1.1 2006/11/11 14:55:40 mbarbon Exp $
## Copyright:   (c) 2006 Mattia Barbon
## Licence:     This program is free software; you can redistribute it and/or
##              modify it under the same terms as Perl itself
#############################################################################

package Wx::DemoModules::wxRichTextCtrl;

use strict;
BEGIN { eval { require Wx::RichText; } }
use base qw(Wx::DemoModules::lib::BaseModule Class::Accessor::Fast);

use Wx qw(:richtextctrl :textctrl :font);
# use Wx::Event qw(EVT_SPINCTRL EVT_SPIN EVT_SPIN_DOWN EVT_SPIN_UP);

__PACKAGE__->mk_accessors( qw(richtext) );

=pod

sub styles {
    my( $self ) = @_;

    return ( [ wxSP_ARROW_KEYS, 'Allow arrow keys' ],
             [ wxSP_WRAP, 'Wrap' ],
             );
}

=cut

sub commands {
    my( $self ) = @_;

    return ( { with_value  => 0,
               label       => 'Add styled text',
               action      => \&add_styled_text,
               },
               );
}

sub create_control {
    my( $self ) = @_;

    my $richtext = Wx::RichTextCtrl->new( $self, -1, 'Rich text', [-1, -1],
                                          [400, 300] );

    return $self->richtext( $richtext );
}

sub add_styled_text {
    my( $self ) = @_;
    my $r = $self->richtext;

    my $textFont = Wx::Font->new( 12, wxROMAN, wxNORMAL, wxNORMAL );
    my $boldFont = Wx::Font->new( 12, wxROMAN, wxNORMAL, wxBOLD );
    my $italicFont = Wx::Font->new( 12, wxROMAN, wxITALIC, wxNORMAL );
    my $font = Wx::Font->new( 12, wxROMAN, wxNORMAL, wxNORMAL );

    $r->BeginSuppressUndo;
    $r->BeginParagraphSpacing(0, 20);
    $r->BeginAlignment(wxTEXT_ALIGNMENT_CENTRE);
    $r->BeginBold;
    $r->BeginFontSize(14);
    $r->WriteText("Welcome to wxRichTextCtrl, a wxWidgets control for editing and presenting styled text and images");
    $r->EndFontSize;
    $r->Newline;
    $r->BeginItalic;
    $r->WriteText("by Julian Smart");
    $r->EndItalic;
    $r->EndBold;
    $r->Newline;
#    $r->WriteImage(wxBitmap(zebra_xpm));
    $r->EndAlignment;
    $r->Newline;
    $r->Newline;
    $r->WriteText("What can you do with this thing? ");
#    $r->WriteImage(wxBitmap(smiley_xpm));
    $r->WriteText(" Well, you can change text ");
    $r->BeginTextColour(Wx::Colour->new(255, 0, 0));
    $r->WriteText("colour, like this red bit.");
    $r->EndTextColour;
    $r->BeginTextColour(Wx::Colour->new(0, 0, 255));
    $r->WriteText(" And this blue bit.");
    $r->EndTextColour;
    $r->WriteText(" Naturally you can make things ");
    $r->BeginBold;
    $r->WriteText("bold ");
    $r->EndBold;
    $r->BeginItalic;
    $r->WriteText("or italic ");
    $r->EndItalic;
    $r->BeginUnderline;
    $r->WriteText("or underlined.");
    $r->EndUnderline;
    $r->BeginFontSize(14);
    $r->WriteText(" Different font sizes on the same line is allowed, too.");
    $r->EndFontSize;
    $r->WriteText(" Next we'll show an indented paragraph.");
    $r->BeginLeftIndent(60);
    $r->Newline;
    $r->WriteText("Indented paragraph.");
    $r->EndLeftIndent;
    $r->Newline;
    $r->WriteText("Next, we'll show a first-line indent, achieved using BeginLeftIndent(100, -40).");
    $r->BeginLeftIndent(100, -40);
    $r->Newline;
    $r->WriteText("It was in January, the most down-trodden month of an Edinburgh winter.");
    $r->EndLeftIndent;
    $r->Newline;
    $r->WriteText("Numbered bullets are possible, again using subindents:");
    $r->BeginNumberedBullet(1, 100, 60);
    $r->Newline;
    $r->WriteText("This is my first item. Note that wxRichTextCtrl doesn't automatically do numbering, but this will be added later.");
    $r->EndNumberedBullet;
    $r->BeginNumberedBullet(2, 100, 60);
    $r->Newline;
    $r->WriteText("This is my second item.");
    $r->EndNumberedBullet;
    $r->Newline;
    $r->WriteText("The following paragraph is right-indented:");
    $r->BeginRightIndent(200);
    $r->Newline;
    $r->WriteText("It was in January, the most down-trodden month of an Edinburgh winter. An attractive woman came into the cafe, which is nothing remarkable.");
    $r->EndRightIndent;
    $r->Newline;
    my $attr = Wx::TextAttrEx->new;;
    $attr->SetFlags( wxTEXT_ATTR_TABS );
    $attr->SetTabs( [ 400, 600, 800, 1000 ] );
    $r->SetDefaultStyle($attr);

    $r->WriteText("This line contains tabs:\tFirst tab\tSecond tab\tThird tab");
    $r->Newline;
    $r->WriteText("Other notable features of wxRichTextCtrl include:");
    $r->BeginSymbolBullet('*', 100, 60);
    $r->Newline;
    $r->WriteText("Compatibility with wxTextCtrl API");
    $r->EndSymbolBullet;
    $r->WriteText("Note: this sample content was generated programmatically from within the MyFrame constructor in the demo. The images were loaded from inline XPMs. Enjoy wxRichTextCtrl!");
    $r->EndSuppressUndo;
}

sub add_to_tags { qw(controls) }
sub title { 'wxRichTextCtrl' }

defined &Wx::RichTextCtrl::new ? 1 : 0;
