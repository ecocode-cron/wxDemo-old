#############################################################################
## Name:        lib/Wx/Demo.pm
## Purpose:     wxPerl demo main module
## Author:      Mattia Barbon
## Modified by:
## Created:     20/08/2006
## RCS-ID:      $Id$
## Copyright:   (c) 2006-2007 Mattia Barbon
## Licence:     This program is free software; you can redistribute it and/or
##              modify it under the same terms as Perl itself
#############################################################################

package Wx::Demo;

=head1 NAME

Wx::Demo - the wxPerl demo

=head1 AUTHOR

Mattia Barbon <mbarbon@cpan.org>

=head1 LICENSE

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut

use Wx;

use strict;
use base qw(Wx::Frame Class::Accessor::Fast);

use Wx qw(:textctrl :sizer :window :id);
use Wx qw(wxDefaultPosition wxDefaultSize wxTheClipboard 
          wxDEFAULT_FRAME_STYLE wxNO_FULL_REPAINT_ON_RESIZE wxCLIP_CHILDREN);
use Wx::Event qw(EVT_TREE_SEL_CHANGED EVT_MENU EVT_CLOSE);
use File::Slurp;
use File::Basename qw();
use File::Spec;
use UNIVERSAL::require;
use Module::Pluggable::Object;

__PACKAGE__->mk_ro_accessors( qw(tree widget_tree source notebook left_notebook) );
__PACKAGE__->mk_accessors( qw(search_term) );

sub new {
    my( $class ) = @_;
    my $self = $class->SUPER::new
      ( undef, -1, 'wxPerl demo', wxDefaultPosition, [ 600, 500 ],
        wxDEFAULT_FRAME_STYLE|wxNO_FULL_REPAINT_ON_RESIZE|wxCLIP_CHILDREN );

    # $self->SetLayoutDirection( Wx::wxLayout_RightToLeft() );
    Wx::InitAllImageHandlers();

    # create menu bar
    my $bar  = Wx::MenuBar->new;
    my $file = Wx::Menu->new;
    my $help = Wx::Menu->new;
    my $edit = Wx::Menu->new;

    $file->Append( wxID_EXIT, '' );

    $help->Append( wxID_ABOUT, '' );

    $edit->Append( wxID_COPY,  '' );
    $edit->Append( wxID_FIND,  '' );

    $bar->Append( $file, "&File" );
    $bar->Append( $edit, "&Edit" );
    $bar->Append( $help, "&Help" );

    $self->SetMenuBar( $bar );

    # create splitters
    my $split1 = Wx::SplitterWindow->new
      ( $self, -1, wxDefaultPosition, wxDefaultSize,
        wxNO_FULL_REPAINT_ON_RESIZE|wxCLIP_CHILDREN );
    my $split2 = Wx::SplitterWindow->new
      ( $split1, -1, wxDefaultPosition, wxDefaultSize,
        wxNO_FULL_REPAINT_ON_RESIZE|wxCLIP_CHILDREN );
    my $left_nb = Wx::Notebook->new
      ( $split1, -1, wxDefaultPosition, wxDefaultSize,
        wxNO_FULL_REPAINT_ON_RESIZE|wxCLIP_CHILDREN );

    my $tree = Wx::TreeCtrl->new( $left_nb, -1 );
    my $widget_tree = Wx::TreeCtrl->new( $left_nb, -1 );
    $left_nb->AddPage( $tree, "Categories", 0 );
    $left_nb->AddPage( $widget_tree, "Widgets", 0 );

    my $text = Wx::TextCtrl->new
      ( $split2, -1, "", wxDefaultPosition, wxDefaultSize,
        wxTE_READONLY|wxTE_MULTILINE|wxNO_FULL_REPAINT_ON_RESIZE );
    my $log = Wx::LogTextCtrl->new( $text );
    $self->{old_log} = Wx::Log::SetActiveTarget( $log );

    my $nb = Wx::Notebook->new
      ( $split2, -1, wxDefaultPosition, wxDefaultSize,
        wxNO_FULL_REPAINT_ON_RESIZE|wxCLIP_CHILDREN );
    my $code = Wx::Demo::Source->new( $nb );

    $nb->AddPage( $code, "Source", 0 );

    $split1->SplitVertically( $left_nb, $split2, 150 );
    $split2->SplitHorizontally( $nb, $text, 300 );

    $self->{tree} = $tree;
    $self->{widget_tree} = $widget_tree;
    $self->{source} = $code;
    $self->{notebook} = $nb;
    $self->{left_notebook} = $left_nb;

    EVT_TREE_SEL_CHANGED( $self, $tree,        sub { on_show_module($tree, @_) } );
    EVT_TREE_SEL_CHANGED( $self, $widget_tree, sub { on_show_module($widget_tree, @_) } );
    EVT_CLOSE( $self, \&on_close );
    EVT_MENU( $self, wxID_ABOUT, \&on_about );
    EVT_MENU( $self, wxID_EXIT, sub { $self->Close } );
    EVT_MENU( $self, wxID_COPY, \&on_copy );
    EVT_MENU( $self, wxID_FIND, \&on_find );

    $self->populate_modules;
    $self->populate_widgets;

    $self->SetIcon( Wx::GetWxPerlIcon() );
    $self->Show;

    Wx::LogMessage( "Welcome to wxPerl!" );

    return $self;
}

sub on_find {
    my( $self ) = @_;

    my $search_term = $self->search_term || '';
    my $dialog = Wx::TextEntryDialog->new( $self, "", "Search term", $search_term );
    if ($dialog->ShowModal == wxID_CANCEL) {
        return;
    }   
    $search_term = $dialog->GetValue;
    $self->search_term($search_term);
    $dialog->Destroy;
    return if not $search_term;

    my $code = $self->{source};
    my ($from, $to) = $code->GetSelection;
    my $last = $code->isa( 'Wx::TextCtrl' ) ? $code->GetLastPosition()  : $code->GetLength();
    my $str  = $code->isa( 'Wx::TextCtrl' ) ? $code->GetRange(0, $last) : $code->GetTextRange(0, $last);
    my $pos = index($str, $search_term, $from+1);
    if (-1 == $pos) {
        $pos = index($str, $search_term);
    }
    if (-1 == $pos) {
        return; # not found
    }

    $code->SetSelection($pos, $pos+length($search_term));

    return;
}

sub on_close {
    my( $self, $event ) = @_;

    Wx::Log::SetActiveTarget( $self->{old_log} );
    $event->Skip;
}

sub on_about {
    my( $self ) = @_;
    use Wx qw(wxOK wxCENTRE wxVERSION_STRING);

    Wx::MessageBox( "wxPerl demo $main::VERSION, (c) 2001-2008 Mattia Barbon\n" .
                    "wxPerl $Wx::VERSION, " . wxVERSION_STRING,
                    "About wxPerl demo", wxOK|wxCENTRE, $self );
}

# TODO: disallow copy when not the code is in focus
# or copy the text from the log window too.
sub on_copy {
    my( $self ) = @_;

    my $code = $self->{source};
    my ($from, $to) = $code->GetSelection;
    my $str = $code->isa( 'Wx::TextCtrl' ) ? $code->GetRange($from, $to) : $code->GetTextRange($from, $to);
    if (wxTheClipboard->Open()) {
        wxTheClipboard->SetData( Wx::TextDataObject->new($str) );
        wxTheClipboard->Close();
    }

    return;
}


sub on_show_module {
    my( $tree, $self, $event ) = @_;
    my $module = $tree->GetPlData( $event->GetItem );
    return unless $module;

    $self->show_module( $module );
}

sub _module_file {
    my( $module ) = @_;

    return $module->file if $module->can( 'file' );

    my $mod_file = $module;

    $mod_file =~ s{::}{/}g;
    $mod_file .= '.pm';

    return $INC{$mod_file}
}

sub _add_menus {
    my( $self, %menus ) = @_;

    while( my( $title, $menu ) = each %menus ) {
        $self->GetMenuBar->Insert( 1, $menu, $title );
    }
}

sub _remove_menus {
    my( $self ) = @_;

    while( $self->GetMenuBar->GetMenuCount > 2 ) {
        $self->GetMenuBar->Remove( 1 )->Destroy;
    }
}

sub activate_module {
    my( $self, $module ) = @_;

    my( $package ) = grep $_->title eq $module,
                     grep $_->can( 'title' ),
                          $self->plugins;
    return unless $package;
    $self->show_module( $package );
    $self->show_demo_window;
}

sub show_demo_window {
    my( $self ) = @_;

    $self->notebook->SetSelection( 1 ) if $self->notebook->GetPageCount == 2;
}

sub show_module {
    my( $self, $module ) = @_;

    $self->source->set_source( scalar read_file _module_file( $module ) );

    my $nb = $self->notebook;
    my $window = $module->can( 'window' ) ? $module->window( $nb ) :
                                            $module->new( $nb );
    my $sel = $nb->GetSelection;

    if( $nb->GetPageCount == 2 ) {
        $nb->SetSelection( 0 ) if $sel == 1;
        $nb->DeletePage( 1 );
        $self->_remove_menus;
    }
    if( ref( $window ) ) {
        if( !$window->IsTopLevel ) {
            $self->notebook->AddPage( $window, 'Demo' );
            $nb->SetSelection( $sel ) if $sel == 1;
        } else {
            $window->Show;
        }
        $self->_add_menus( $window->menu ) if $window->can( 'menu' );
    }
}

my @tags =
  ( [ new        => 'New' ],
    [ controls   => 'Controls' ],
    [ windows    => 'Windows' ],
    [ managed    => 'Managed Windows' ],
    [ dialogs    => 'Dialogs' ],
    [ sizers     => 'Sizers' ],
    [ dnd        => 'Drag & Drop' ],
    [ misc       => 'Miscellanea' ],
    );

sub d($) { Wx::TreeItemData->new( $_[0] ) }

# poor man's insertion sort
sub add_item {
    my( $tree, $id, $module ) = @_;

    my $title = $module->title;
    my( $child, $cookie ) = $tree->GetFirstChild( $id );
    my $childtitle = $child ? $tree->GetItemText( $child ) : '';

    if( !$child || $childtitle gt $title ) {
        $tree->PrependItem( $id, $title, -1, -1, d $module );
    } else {
        my $pchild = $child;
        while( ( $child, $cookie ) = $tree->GetNextChild( $id, $cookie ) ) {
            last unless $child;
            $childtitle = $tree->GetItemText( $child );
            if( $childtitle lt $title ) {
                $pchild = $child;
            } else {
                $tree->InsertItem( $id, $pchild, $title, -1, -1, d $module );
                return;
            }
        }

        $tree->AppendItem( $id, $title, -1, -1, d $module );
    }
}

sub populate_widgets {
    my( $self ) = @_;

    my $widget_tree = $self->widget_tree;
    my $widgets = $self->widgets;

    my $root_id = $widget_tree->AddRoot( 'wxPerl', -1, -1 );
    foreach my $widget (sort keys %$widgets) {
        my $parent_id = $widget_tree->AppendItem( $root_id, $widget, -1, -1 );
        foreach my $name (sort keys %{ $widgets->{$widget} }) {
            my $id = $widget_tree->AppendItem( $parent_id, $name, -1, -1, Wx::TreeItemData->new($name) );
        }
    }

    $widget_tree->Expand( $root_id );
    return;
}

sub populate_modules {
    my( $self ) = @_;
    my $tree = $self->tree;
    my @modules = $self->plugins;

    my $root_id = $tree->AddRoot( 'wxPerl', -1, -1 );
    my %tag_map;

    foreach my $tag ( @tags, map $_->tags, grep $_->can( 'tags' ), @modules ) {
        my( $parent_id, $last );
        if( ( my $last_slash = rindex $tag->[0], '/' ) != -1 ) {
            $parent_id = $tag_map{ substr $tag->[0], 0, $last_slash };
        } else {
            $parent_id = $root_id;
        }
        die "'$tag' has no parent" unless $parent_id;
        next if $tag_map{$tag->[0]};
        my $id = $tree->AppendItem( $parent_id, $tag->[1], -1, -1 );
        $tag_map{$tag->[0]} = $id;
    }

    foreach my $module ( grep $_->can( 'add_to_tags' ), @modules ) {
        foreach my $tag ( $module->add_to_tags ) {
            my $parent_id = $tag_map{$tag};

            unless( $parent_id ) {
                Wx::LogWarning( 'Wrong parent: %s', $tag );
                next;
            }

            add_item( $tree, $parent_id, $module );
        }
    }

    $tree->Expand( $root_id );
}

sub plugins {
    my( $self ) = @_;
    return @{$self->{plugins}} if $self->{plugins};

    ($self->{plugins}, $self->{widgets}) = $self->load_plugins(sub { Wx::LogWarning( @_ ) });

    return @{$self->{plugins}};
}

sub widgets {
    my( $self ) = @_;
    if (not $self->{widgets}) {
        $self->plugins;
    }

    return $self->{widgets};
}

# allow ignoring load failures
sub load_plugins {
    my( $self , $w ) = @_;
    my %skip;
    my %widgets;
    my $finder = Module::Pluggable::Object->new
      ( search_path => [ qw(Wx::DemoModules) ],
        require     => 0,
        filename    => __FILE__,
        );

    foreach my $package ( $finder->plugins ) {
        next if $skip{$package};
        my $f = "$package.pm"; $f =~ s{::}{/}g;
        if( $package->require ) {
            $self->parse_file($package, $f, \%widgets);
        } else {
            $w->( "Skipping module '%s'", $package );
            $w->( $_ ) foreach split /\n/, $@;
#            delete $INC{$f}; # for Perl 5.10
#            $INC{$f} = 'skip it';
            $INC{$f} = 'skip it' unless exists $INC{$f};
            $skip{$package} = 1;
        };
    }

    # search inner packages
    my @plugins = grep !$skip{$_}, Module::Pluggable::Object->new
      ( search_path => [ qw(Wx::DemoModules) ],
        require     => 1,
        filename    => __FILE__,
        )->plugins;
    return (\@plugins, \%widgets);
}

sub parse_file {
    my ($self, $package, $path, $widgets) = @_;
    
    if (open my $fh, '<', $INC{$path}) {
        while (my $line = <$fh>) {
            for ($line =~ /\b(Wx(::\w+)+)\b/g) {
                my $name = $1;
                next if $name =~ /^Wx::DemoModules/;
                $widgets->{$name}{$package} = 1;
            }
            for ($line =~ /\b(wx\w+)\b/g) {
                $widgets->{$1}{$package} = 1;
            }
            for ($line =~ /\b(EVT_\w+)\b/g) {
                $widgets->{$1}{$package} = 1;
            }
        }
    } else {
        warn "Could not open $INC{$path} for $path $!";
    }

    return;
}

sub get_data_file {
    my( $class, $file ) = @_;
    ( undef, my $filename ) = caller;

    my $dir = File::Basename::dirname( $filename );
    until( -d File::Spec->catdir( $dir, 'files' ) ) {
        $dir = File::Basename::dirname( $dir )
    }

    return File::Spec->catdir( $dir, 'files', $file );
}

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
