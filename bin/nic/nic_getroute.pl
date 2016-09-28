#!/usr/bin/perl
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
# "@(#) $Id: nic_getroute.pl,v 1.2 2005/09/26 02:48:59 dengyp Exp $"
#
#Function:
		#To get all the route list.
#Output:
		#Output the route lists like the format
		#des1 gateway1 nicName1
		#des2 gateway2 nicName2
		#des3 gateway3 nicName3
		#......
	  #Note:
    #The field1 des: The network of routing, default, host or network/mask are available.
  	#The field2 gateway: The gateway of routing.
  	#The field3 nicName: the device(interface name) of routing.
#Parameters: [ -l | -a ]
    #No param: equal to "-a"
    #	-l : Get the routes without the interfaces whose gateway is not set.
		# -a : Get all routes.
#Returns:
		#0: successful.
		#1: failure.

use strict;
use constant ERRCODE_ARGUMENT                    => "0x18A00025";
use constant ERRCODE_ROUTES_CANNOTGET            => "0x18A00003";
use NS::NicCommon;
use NS::NsguiCommon;

my $nsgui_common = new NS::NsguiCommon;
my $param = shift;
if($param eq ""){
	$param = "-a";
}
if($param ne "-a" && $param ne "-l"){
	$nsgui_common->writeErrMsg(ERRCODE_ARGUMENT,__FILE__,__LINE__+1);    
	exit 1;
}
my $nic_common = new NS::NicCommon;

#get the result array
my @result ;

my $route = $nic_common->getRoute($param);
if(!defined($route)){
	$nsgui_common->writeErrMsg(ERRCODE_ROUTES_CANNOTGET,__FILE__,__LINE__+1);    
	exit 1;
}
@result = @$route;

#print the result
print @result;

exit 0;