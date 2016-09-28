#!/usr/bin/perl
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
# "@(#) $Id: nic_getbondinfo.pl,v 1.1 2005/10/24 01:33:19 dengyp Exp $"
#

use strict;
use constant ERRCODE_ARGUMENT                    => "0x18A00011";
use constant ERRCODE_BONDS_CANNOTGET             => "0x18A00012";
use NS::NicCommon;
use NS::NsguiCommon;

my $nsgui_common = new NS::NsguiCommon;
my $nic_common = new NS::NicCommon;

my $bondName = shift;
if($bondName eq "" || scalar(@ARGV)!=0){
	$nsgui_common->writeErrMsg(ERRCODE_ARGUMENT,__FILE__,__LINE__+1);        
	exit 1;
}

$bondName =~ s/\:\w*$//;
$bondName =~ s/\.\w*$//;
#get all the bonds information
my $bonds = $nic_common->getBonds($bondName);
if(!defined($bonds)){		
    $nsgui_common->writeErrMsg(ERRCODE_BONDS_CANNOTGET,__FILE__,__LINE__+1);
    exit 1;
}
#get la and ab and ba information.
my %tmpBonds = %$bonds;
print $tmpBonds{$bondName}."\n";

exit 0;