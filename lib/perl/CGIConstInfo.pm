#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: CGIConstInfo.pm,v 1.2300 2003/11/24 00:55:20 nsadmin Exp $"


#Coding by Bai Weiqin,NAS-Group.
package NS::CGIConstInfo;
use strict;

sub new()
{
    my $this = {}; # Create an anonymous hash,and #self points to it.
    bless $this; # Connect the hash to the package update.
    return $this; # Return the reference to the hash.
}

use constant  GDBAR_INVALID_SIZE_ERRMSG    => "invalued width or height";
use constant  GDBAR_ERROR_GRAPH_WIDTH    => 200;
use constant  GDBAR_ERROR_GRAPH_HEIGHT    => 16;
    #the following define the color of Bar Graph
    #the color here lies on (red,green,blue),(red,green and blue requires decimal number)
use constant  GDBAR_BACK_RED            => 0xe8;
use constant  GDBAR_BACK_GREEN            => 0xe8;
use constant  GDBAR_BACK_BLUE            => 0xff;
use constant  GDBAR_FORE_RED            => 0x60;
use constant  GDBAR_FORE_GREEN            => 0x40;
use constant  GDBAR_FORE_BlUE            => 0xc0;   

use constant  GDBAR_BORDER_RED            => 0x80;
use constant  GDBAR_BORDER_GREEN            => 0x80;
use constant  GDBAR_BORDER_BlUE            => 0x80;     
    
use constant  GDPIE_DEFAULT_WIDTH        => 96;
use constant  GDPIE_DEFAULT_HEIGHT        => 96;
    # the options' value of Pie Graph
use constant  GDPIE_START_ANGLE            => 180;
use constant  GDPIE_UED_COLOR            => "#c0b0ff";
use constant  GDPIE_AVAILABLE_COLOR        => "#e8e8ff";
    # the following needs one of "white, lgray, gray, dgray, black, lblue, blue, dblue,
    # gold, lyellow, yellow, dyellow, lgreen, green, dgreen, lred, red, dred, lpurple,
    # purple, dpurple, lorange, orange, pink, dpink, marine, cyan, lbrown, dbrown"
use constant  GDPIE_ACCENT_CLR            => "gray";
use constant  GDPIE_AXISLABEL_CLR        => "black";
    
    #used in GraphOption.pm
use constant  ISCSI_ID                     => "iSCSI";
        #END of constant about GD and RRD CGI

1; # package end.
