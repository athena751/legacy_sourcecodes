#!/usr/bin/perl -w
#
#       Copyright (c) 2005-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
# "@(#) $Id: nic_ifconfig.pl,v 1.7 2007/08/29 00:51:57 fengmh Exp $"
#

#Function: 
#   The command to get interface list.
#   Including getting all interfaces, the service interfaces , 
#   the administrator interfaces and the specified one interface.
#Parameters: [ -s | -a |  -m | -dev interface | -help ]
    #No param: equal to "-a"
    # -s     : get all the service interface.
    # -m     : get all the administrator interface.
    # -a     : get all the interface.
    # -dev   : get the specified interface information.  
    # -ex   : get the redundant interface information.  
    #interface : interface name.
    #-help   : the help message.
#Exit code:
    #0:succeed 
    #1:failed
#Output:
    #Output the interface lists like the format:
		#Interface ifstatus link ip/netmask broadcast gateway mac mtu type la ab ba vl construction		
    #Interface     : the interface name.
    #ifstatus      : the interface's work status.      
    #link          : the interface card's link status.      
    #ip/netmask    : the interfacs's IP and netmask.      
    #broadcast     : the interface's broadcast address.    
    #gateway       : the interface's default gateway.      
    #mac           : the interface's mac address.      
    #mtu           : the interface's mtu setting.
    #type          : the interface's constructional type.
    #mode          : if the interface is made by link aggression, then the value is "LA",     
    #                    if the interface is made by active-backup, then the value is "AB"
    #                    if the interface is made by alb-active, then the value is "BA"
    #vl            : if the interface is virtual interface, then the value is "YES", otherwise is "NO".
    #alias         : if the interface is IP alias, then the value is "YES", otherwise is "NO".
    #construction  : if the interface is bond,show the its subcards' name. if the interface is virtual lan,show the parent card's name.
    #                if the interface is IP alias, show the base I/F.
#STDERR:
    #0x18A00011    :  the params input error
    #0x18A00012    :  the interfaces' bond information can't be get. 
    #0x18A00013    :  the interfaces' information can't be get.
    #0x18A00014    :  the interfaces' gateway information can't be get.
    #0x18A00015    :  the interfaces' linkstatus information can't be get.

format HELPMESSAGE =
Function: 
   The command to get interface list.
   Including getting all interfaces, the service interfaces , 
   the administrator interfaces and the specified one interface.
Parameters: [ -s | -a |  -m | -ex | -dev interface | -help ]
    No param: equal to "-a"
     -s     : get all the service interface.
     -m     : get all the administrator interface.
     -a     : get all the interface.
     -dev   : get the specified interface information.   
     -ex    : get the redundant interface information.   
    interface : interface name.
    -help   : the help message.
.

use strict;
use constant ERRCODE_ARGUMENT                    => "0x18A00011";
use constant ERRCODE_BONDS_CANNOTGET             => "0x18A00012";
use constant ERRCODE_INTERFACES_CANNOTGET        => "0x18A00013";
use constant ERRCODE_GATEWAYS_CANNOTGET          => "0x18A00014";
use constant ERRCODE_LINKSTATUSES_CANNOTGET      => "0x18A00015";
use NS::NicCommon;
use NS::NsguiCommon;

my $nsgui_common = new NS::NsguiCommon;
sub usage(){
    print STDERR "Invalid argument.\n",
        "Usage:", __FILE__,
        "[ -a | -m | -s | -ex | -dev interface | -help ]\n";  
    $nsgui_common->writeErrMsg(ERRCODE_ARGUMENT,__FILE__,__LINE__+1);               	 
}

my $param;
my $interface = "";

if(scalar(@ARGV) == 0) {
   $param = "-a";
}else{
	$param = shift;
	if($param eq "-help"){
		$~ = "HELPMESSAGE";
		write;
		exit 0;
	}
	if($param ne "-dev" && scalar(@ARGV) != 0) {  	
  	usage;
  	exit 1;
	}
	if($param eq "-dev"){
	    $interface = shift;
	    if(scalar(@ARGV) != 0 || $interface eq ""){
		    usage;
		    exit 1;
        }
    }
}

if( $param ne "-a" && $param ne "-s" && $param ne "-m" && $param ne "-dev" && $param ne "-ex"){
    usage;
    exit 1;
}

my $nic_common = new NS::NicCommon;

#get all the bonds information
my $bonds = $nic_common->getBonds();
if(!defined($bonds)){		
    $nsgui_common->writeErrMsg(ERRCODE_BONDS_CANNOTGET,__FILE__,__LINE__+1);
    exit 1;
}
#get all the constructions, la and ab and ba information.
my %tmpBonds = %$bonds;
my %bondsHash;
my %bondingModeHash;

foreach (keys(%tmpBonds)){
	my @tmpArray = split(" ",$tmpBonds{$_});
	$bondsHash{$_} = $tmpArray[0];
	$bondingModeHash{$_} = $tmpArray[2];	
}

#get all the interfaces information except the slave interface
my $interfaces = $nic_common->getInterfaces($param,$interface);
if(!defined($interfaces)){
	$nsgui_common->writeErrMsg(ERRCODE_INTERFACES_CANNOTGET,__FILE__,__LINE__+1);
	exit 1;
}
my @interfacesArray = @$interfaces;

#define the result struct in form of hash map
my %resultHash = ("interface"=>"","ip"=>"--", "linkStatus"=>"DOWN",
	"ifStatus"=>"DOWN","brd"=>"--","gw"=>"--","mac"=>"--",
	"mtu"=>"--","mode"=>"--","vl"=>"NO","alias"=>"NO",
	"type"=>"NORMAL","construction"=>"--");

#define the output head
my $outputHead = "    Interface Status Link         IP/Netmask       Broadcast         Gateway               MAC  MTU   Type Mode  VL  Alias Construction\n";

#define the output array and initiate
my @outputArray = ($outputHead);

#get the gateways into hash map
my $gateways = $nic_common ->getGateway();
my %gatewaysHash = ();
if(defined($gateways)){
        %gatewaysHash = %$gateways;	
}

#this method to store the interfaces' information in array
#this method get type, linkstatus and vl according to the interface name
foreach (@interfacesArray){			
	if($_ =~ /^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s*/){ 		
		$resultHash{"interface"} = $1;
		$resultHash{"ifStatus"} = $2;
		$resultHash{"ip"} = $3;
		$resultHash{"brd"} = $4;
		$resultHash{"mac"} = $5;
		$resultHash{"mtu"} = $6;			
	}else{
		next;
	}	
	
  my $interfaceName = $resultHash{"interface"};	
	if($interfaceName =~ /^(\w+)\:/){
			$interfaceName = $1;			
	}		
	my $tmpinterface = $interfaceName;
#get vlan information		
  my $isVlan = 0;
	if($tmpinterface =~ /^(\w+)\./){
        $tmpinterface = $1;
		$resultHash{"construction"} = $tmpinterface;
		$resultHash{"vl"} = "YES";
		$isVlan = 1;
	} 
	
	if(defined($bondsHash{$tmpinterface}) && 
		defined($bondingModeHash{$tmpinterface})){
 			my $tmpConstruction = "";
 			if( $isVlan == 0){ 				
 				  $resultHash{"construction"} = $bondsHash{$tmpinterface};
 			}
 			$resultHash{"mode"} = $bondingModeHash{$tmpinterface}; 			
 			$tmpConstruction = $bondsHash{$tmpinterface};
    		if( $tmpConstruction =~ /te/ && ($tmpConstruction =~ /ge/ || $tmpConstruction =~ /eth/)){
                $resultHash{"type"} = "MIX";
            }elsif( $tmpConstruction =~ /te/ && $tmpConstruction !~ /ge/ && $tmpConstruction !~ /eth/ ){
                $resultHash{"type"} = "TOE";
            }else{
                $resultHash{"type"} = "NORMAL";
            }
#get subcards' information and linkstatus                       
            my @subcard = split(/,/,$tmpConstruction);
            chomp(@subcard);                        
            foreach (@subcard){
			   	my $linkStatus = $nic_common->getLinkStatus($_);			     	
			   	if($linkStatus eq "yes"){			     	
			   	     $resultHash{"linkStatus"} = "UP";
			   	     last;
                }			
            }
    }else{
#if the card is not the bond card
#get the linkstatus     
    	my $linkStatus = $nic_common->getLinkStatus($tmpinterface);    	
    	if($linkStatus eq "yes"){			     	
		     $resultHash{"linkStatus"} = "UP";			     
        }			    	
#get the type    	
    	if($tmpinterface =~ /\bte/){
    		$resultHash{"type"} = "TOE";
    	}		
	}	
    if(defined($gatewaysHash{$resultHash{"interface"}})){
        $resultHash{"gw"} = $gatewaysHash{$resultHash{"interface"}};                             
    }	
    	
#get alias information
    if($resultHash{"interface"} =~ /^\s*(\S+):\d{3,}$/) {
        $resultHash{"alias"} = "YES";
        $resultHash{"construction"} = $1;
    }	
    
	my $resultString ;
	$resultString = sprintf("%13s %6.4s %4s %18s %15s %15s %17s %4s %6s %4s %3s %6s %s\n", 
		$resultHash{"interface"},	$resultHash{"ifStatus"},
		$resultHash{"linkStatus"},$resultHash{"ip"},
		$resultHash{"brd"},$resultHash{"gw"},
		$resultHash{"mac"},$resultHash{"mtu"},
		$resultHash{"type"},$resultHash{"mode"},
		$resultHash{"vl"},$resultHash{"alias"},
		$resultHash{"construction"});   		 				
#add the result to array
    push(@outputArray,$resultString); 
    $resultHash{"interface"} ="";
	$resultHash{"ifStatus"} = "DOWN";
	$resultHash{"linkStatus"} = "DOWN";
	$resultHash{"ip"} = "--";
	$resultHash{"gw"} = "--";
	$resultHash{"brd"} = "--";
	$resultHash{"mac"} = "--";
	$resultHash{"mtu"} = "--";
	$resultHash{"type"} ="NORMAL";
	$resultHash{"mode"} ="--";	
	$resultHash{"vl"} = "NO";
	$resultHash{"alias"} = "NO";
	$resultHash{"construction"} = "--"; 
}        
#output the result array in format:
#    nicname  ifstatus ip broadcast gateway mac mtu type la ab ba vl construction linkstatus

if(scalar(@outputArray) == 1){
	print "The interface information doesn't exist!\n";
}else{  
	print @outputArray;     
}

exit 0;