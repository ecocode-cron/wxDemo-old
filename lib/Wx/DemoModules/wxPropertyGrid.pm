#############################################################################
## Name:        lib/Wx/DemoModules/wxPropertyGrid.pm
## Purpose:     wxPerl demo helper for Wx::PropertyGrid
## Author:      Mark Dootson
## Modified by:
## Created:     03/03/2012
## SVN-ID:      $Id$
## Copyright:   (c) 2012 Mattia Barbon
## Licence:     This program is free software; you can redistribute it and/or
##              modify it under the same terms as Perl itself
#############################################################################
use Wx;
use Wx::PropertyGrid;
package Wx::DemoModules::wxPropertyGrid;
use strict;

use Wx qw( :propgrid :misc wxTheApp :id :colour :sizer :window :panel :bitmap :font);
use base qw( Wx::Panel );

# we don't need to use an id enum in Perl but we use it here as it is simpler to translate the C++
# code from the wxWidgets propgrid sample

use constant {
    PGID 				=> 1,
    TCID 				=> 2,
    ID_ABOUT 			=> 3,
    ID_QUIT 			=> 4,
    ID_APPENDPROP 		=> 5,
    ID_APPENDCAT 		=> 6,
    ID_INSERTPROP 		=> 7,
    ID_INSERTCAT 		=> 8,
    ID_ENABLE 			=> 9,
    ID_SETREADONLY 		=> 10,
    ID_HIDE 			=> 11,
    ID_DELETE 			=> 12,
    ID_DELETER 			=> 13,
    ID_DELETEALL 		=> 14,
    ID_UNSPECIFY 		=> 15,
    ID_ITERATE1 		=> 16,
    ID_ITERATE2 		=> 17,
    ID_ITERATE3 		=> 18,
    ID_ITERATE4 		=> 19,
    ID_CLEARMODIF 		=> 20,
    ID_FREEZE 			=> 21,
    ID_DUMPLIST 		=> 22,
    ID_COLOURSCHEME1 	=> 23,
    ID_COLOURSCHEME2 	=> 24,
    ID_COLOURSCHEME3 	=> 25,
    ID_CATCOLOURS 		=> 26,
    ID_SETBGCOLOUR 		=> 27,
    ID_SETBGCOLOURRECUR => 28,
    ID_STATICLAYOUT 	=> 29,
    ID_POPULATE1 		=> 30,
    ID_POPULATE2 		=> 31,
    ID_COLLAPSE 		=> 32,
    ID_COLLAPSEALL 		=> 33,
    ID_GETVALUES 		=> 34,
    ID_SETVALUES 		=> 35,
    ID_SETVALUES2 		=> 36,
    ID_RUNTESTFULL 		=> 37,
    ID_RUNTESTPARTIAL 	=> 38,
    ID_FITCOLUMNS 		=> 39,
    ID_CHANGEFLAGSITEMS => 40,
    ID_TESTINSERTCHOICE => 41,
    ID_TESTDELETECHOICE => 42,
    ID_INSERTPAGE 		=> 43,
    ID_REMOVEPAGE 		=> 44,
    ID_SETSPINCTRLEDITOR => 45,
    ID_SETPROPERTYVALUE => 46,
    ID_TESTREPLACE 		=> 47,
    ID_SETCOLUMNS 		=> 48,
    ID_TESTXRC 			=> 49,
    ID_ENABLECOMMONVALUES => 50,
    ID_SELECTSTYLE 		=> 51,
    ID_SAVESTATE 		=> 52,
    ID_RESTORESTATE 	=> 53,
    ID_RUNMINIMAL 		=> 54,
    ID_ENABLELABELEDITING => 55,
    ID_VETOCOLDRAG 		=> 56,
    ID_SHOWHEADER 		=> 57,
    ID_ONEXTENDEDKEYNAV => 58,
};
	
sub new {
    my $class = shift;
    my $self = $class->SUPER::new($_[0], -1);
	$self->create_property_grid;
    return $self;
}

#sub tags { [ 'controls/propertygrid', 'wxPropertyGrid' ], [ 'new/propertygrid', 'wxPropertyGrid' ] }

sub add_to_tags { qw(controls new ) }
sub title { 'wxPropertyGrid' }

sub create_property_grid {
	my ($self, $style, $extrastyle ) = @_;
	if ( !defined($style) || $style == -1 ) {
        $style = wxPG_BOLD_MODIFIED | wxPG_SPLITTER_AUTO_CENTER |
                wxPG_AUTO_SORT | wxPG_TOOLBAR | wxPG_DESCRIPTION;
	}

    if ( !defined($extrastyle) || $extrastyle == -1 ) {
        $extrastyle = wxPG_EX_MODE_BUTTONS | wxPG_EX_MULTIPLE_SELECTION;
	}

	my $wascreated = ( $self->{panel} ) ? 0 : 1;
    $self->init_panel;

    ##This shows how to combine two static choice descriptors
    #m_combinedFlags.Add( _fs_windowstyle_labels, _fs_windowstyle_values );
    #m_combinedFlags.Add( _fs_framestyle_labels, _fs_framestyle_values );

	# create the manager - note bug causes failure if wxDefaultSize passed
	# so we pass an actual size
	
	my $pgman = $self->{manager} = Wx::DemoModules::wxPropertyGrid::Manager->new(
		$self->{panel}, PGID, wxDefaultPosition, [100,100], $style);
	
	
    $self->{propgrid} = $pgman->GetGrid();

    $pgman->SetExtraStyle($extrastyle);

    # This is the default validation failure behaviour
    $pgman->SetValidationFailureBehavior( wxPG_VFB_MARK_CELL |  wxPG_VFB_SHOW_MESSAGEBOX );

    $self->{propgrid}->SetVerticalSpacing( 2 );

    ## Set somewhat different unspecified value appearance
    my $cell = Wx::PGCell->new();
    $cell->SetText("Unspecified");
    $cell->SetFgCol( wxLIGHT_GREY );
    $self->{propgrid}->SetUnspecifiedValueAppearance($cell);

    $self->populate_grid;

    # Change some attributes in all properties
    $pgman->SetPropertyAttributeAll(wxPG_BOOL_USE_DOUBLE_CLICK_CYCLING, 1 );
    #$pgman->SetPropertyAttributeAll(wxPG_BOOL_USE_CHECKBOX, 1 );
	
    $self->{topsizer}->Add($pgman, 1, wxEXPAND );

    $self->finalise_panel( $wascreated );
	
}

sub init_panel {
	my ($self) = @_;
    $self->{panel}->Destroy if $self->{panel};
    $self->{panel} = Wx::Panel->new($self, wxID_ANY, [0, 0], [400, 400], wxTAB_TRAVERSAL);
    $self->{topsizer} = Wx::BoxSizer->new( wxVERTICAL );
}

sub populate_grid {
	my $self = shift;
	my $pgman = $self->{manager};
    
	$pgman->AddPage('Standard Items');

    $self->populate_standard_items();

    $pgman->AddPage('wxWidgets Library Config');

    $self->populate_library_config();

    my $page = Wx::DemoModules::wxPropertyGrid::Page->new();
    $page->Append( Wx::IntProperty->new('IntProperty', 'IntProperty', 12345678 ) );

    # Use Wx::DemoModules::wxPropertyGrid::Page (see above) to test the
    # custom wxPropertyGridPage feature.
    $pgman->AddPage( 'Examples', wxNullBitmap, $page);

    $self->populate_with_examples;
}

sub populate_standard_items {
	my $self = shift;
	
	my $pgman = $self->{manager};
	
	my $pg = $pgman->GetPage('Standard Items');
	
	$pg->Append( Wx::PropertyCategory->new('Appearance') );
    
	$pg->Append( Wx::StringProperty->new('Label', 'Label', 'My Frame Title') );
	
    my $fprop = $pg->Append( Wx::FontProperty->new('Font', 'Font', wxNullFont ) );
    
	$pg->SetPropertyHelpString ( 'Font', 'Editing this will change font used in the property grid.' );
	
	#$fprop->SetHelpString( 'Editing this will change font used in the property grid.' );
    
    $pg->Append( Wx::ColourProperty->new('Margin Colour','Margin Colour', $pgman->GetGrid()->GetMarginColour()) );
   
    $pg->Append( Wx::ColourProperty->new('Cell Colour', 'Cell Colour', $pgman->GetGrid()->GetCellBackgroundColour()) );
       
    $pg->Append( Wx::ColourProperty->new('Cell Text Colour','Cell Text Colour', $pgman->GetGrid()->GetCellTextColour()) );
    
	$pg->Append( Wx::FlagsProperty->new('Some Flags', 'Some Flags',
		[ 'wxFLAG_DEFAULT', 'wxFLAG_FIRST', 'wxFLAG_SECOND', 'wxFLAG_THIRD', 'wxFLAG_FIFTH', 'wxFLAG_SIXTH', ],
		[ 0, 1, 2, 4, 8, 16, 32 ] , 10 ) );
	
	
    $pg->SetPropertyAttribute( 'Some Flags' , wxPG_BOOL_USE_CHECKBOX, 1 , wxPG_RECURSE);
	
	
	$pg->Append( Wx::CursorProperty->new('Cursor','Cursor') );
										 
    $pg->Append( Wx::PropertyCategory->new('Position', 'PositionCategory') );
    
	$pg->SetPropertyHelpString( 'PositionCategory', 'Change in items in this category will cause respective changes in Demo Frame.' );

    #// Let's demonstrate 'Units' attribute here
    
    #// Note that we use many attribute constants instead of strings here
    #// (for instance, wxPG_ATTR_MIN, instead of "min".
    
    
    $pg->Append( Wx::IntProperty->new('Height','Height',480) );
    $pg->SetPropertyAttribute('Height', wxPG_ATTR_MIN,   10 );
    $pg->SetPropertyAttribute('Height', wxPG_ATTR_MAX,   2048  );
    $pg->SetPropertyAttribute('Height', wxPG_ATTR_UNITS, 'Pixels');
    
    #// Set value to unspecified so that Hint attribute will be demonstrated
	$pg->SetPropertyValueUnspecified("Height");
    $pg->SetPropertyAttribute("Height", wxPG_ATTR_HINT,  "Enter new height for window");
    #
    #// Difference between hint and help string is that the hint is shown in
    #// an empty value cell, while help string is shown either in the
    #// description text box, as a tool tip, or on the status bar.
	
    $pg->SetPropertyHelpString("Height", "This property uses attributes \"Units\" and \"Hint\"." );

    $pg->Append( Wx::IntProperty->new('Width', 'Width', 640 ) );
    $pg->SetPropertyAttribute('Width', wxPG_ATTR_MIN, Wx::Variant->new(10) );
	
    $pg->SetPropertyAttribute('Width', wxPG_ATTR_MAX, Wx::Variant->new(2048) );
    $pg->SetPropertyAttribute('Width', wxPG_ATTR_UNITS, Wx::Variant->new('Pixels') );
    
    $pg->SetPropertyValueUnspecified('Width');
    $pg->SetPropertyAttribute('Width', wxPG_ATTR_HINT, "Enter new width for window" );
    $pg->SetPropertyHelpString("Width", "This property uses attributes \"Units\" and \"Hint\"." );
    
    $pg->Append( Wx::IntProperty->new('X','X', 10 ));
    $pg->SetPropertyAttribute('X', wxPG_ATTR_UNITS, '"Pixels"' );
    $pg->SetPropertyHelpString('X', "This property uses \"Units\" attribute." );
    
    $pg->Append( Wx::IntProperty->new( 'Y','Y',10 ));
    $pg->SetPropertyAttribute('Y', wxPG_ATTR_UNITS, 'Pixels');
    $pg->SetPropertyHelpString('Y', "This property uses \"Units\" attribute." );
    
    my $disabledHelpString = qq(This property is simply disabled. In order to have label disabled as well, \n);
	$disabledHelpString .= qq(you need to set wxPG_EX_GREY_LABEL_WHEN_DISABLED using SetExtraStyle.);
    
    $pg->Append( Wx::PropertyCategory->new('Environment','Environment') );
    $pg->Append( Wx::StringProperty->new('Operating System','Operating System',Wx::GetOsDescription()) );
    
	$pg->Append( Wx::StringProperty->new('User Name','User Name',
				( Wx::wxMSW() ) ? getlogin : (getpwuid($<))[0] ) );
	$pg->Append( Wx::DirProperty->new('User Local Data Directory','UserLocalDataDir',
				Wx::StandardPaths::Get()->GetUserLocalDataDir ) );
	
    #// Disable some of them
    $pg->DisableProperty( 'Operating System' );
    $pg->DisableProperty( 'User Name' );
    
    $pg->SetPropertyHelpString( 'Operating System', $disabledHelpString );
    $pg->SetPropertyHelpString( 'User Name', $disabledHelpString );
    
    # $pg->Append( Wx::PropertyCategory->new('More Examples','More Examples') );
    
    # Custom Property Classes ??
	
}

sub populate_library_config {
	my $self = shift;
	
}

sub populate_with_examples {
	my $self = shift;
	
}

sub finalise_panel {
	my ( $self, $wascreated ) = @_;
	
	$self->{topsizer}->Add( Wx::Button->new($self->{panel}, wxID_ANY,
                     'Should be able to move here with Tab'),
                     0, wxEXPAND );

    $self->{panel}->SetSizer( $self->{topsizer} );
    $self->{topsizer}->SetSizeHints( $self->{panel} );

    my $mainsizer = Wx::BoxSizer->new( wxVERTICAL );
    $mainsizer->Add( $self->{panel}, 1, wxEXPAND|wxFIXED_MINSIZE );

    $self->SetSizer( $mainsizer );
    $mainsizer->SetSizeHints( $self );

    if ( $wascreated ) {
        # nothing to do in this implementation
	}
	
}

######################################################

package Wx::DemoModules::wxPropertyGrid::Manager;

use strict;
use Wx::PropertyGrid;
use Wx qw( :propgrid :misc );
use base qw( Wx::PropertyGridManager );

sub new { shift->SUPER::new( @_ ) }

######################################################

package Wx::DemoModules::wxPropertyGrid::Grid;

use strict;
use Wx::PropertyGrid;
use Wx qw( :propgrid :misc );
use base qw( Wx::PropertyGrid );

sub new { shift->SUPER::new( @_ ) }

######################################################

package Wx::DemoModules::wxPropertyGrid::Page;

use strict;
use Wx::PropertyGrid;
use Wx qw( :propgrid :misc );
use base qw( Wx::PropertyGridPage );

sub new { shift->SUPER::new( @_ ) }


eval { return Wx::_wx_optmod_propgrid(); };
