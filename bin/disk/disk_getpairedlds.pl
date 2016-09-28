#!/usr/bin/perl -w
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: disk_getpairedlds.pl,v 1.1 2008/04/19 13:13:06 jiangfx Exp $"

#Function:      
#               get paired lds 
#Parameters:    
#               $arrayName -- DiskArray Name
#Exit:          
#               0 -- successful  
#               1 -- failed
#Output
#               $ldNum ---- ld Number in Hex
use strict;
use NS::DdrConst;

my $ddrConst = new NS::DdrConst;

if(scalar(@ARGV) != 1){
    &printHelp();
    exit 1;
}

my $pairedLdsHasH = &getRepl2LdInfo($ARGV[0]);
if(defined($$pairedLdsHasH{$ddrConst->ERR_FLAG})){
   exit 0; 
}
foreach(sort keys(%$pairedLdsHasH)){
    print $_."\n";
}

exit 0;

#### sub function defination start ####
###Function : Get ld information (attribute, capacity,...)
###
###Parameter:
###           null
###Return:
###           \%ldhash
###			      key=ldNo, value= ""
###						(eg: "00a0h"=>"")
###				  error: key= $ddrConst->ERR_FLAG, value= $ddrConst->ERR_EXECUTE_REPL2_LIST_LD
sub getRepl2LdInfo(){
    my $arrayName = shift;
    my $cmd_listld = $ddrConst->CMD_REPL2_LIST_LD." $arrayName 2>/dev/null";
    my @result  = `$cmd_listld`;
    my $retcode = $?;
    my %ldhash = ();

    if($retcode == 0){
        foreach(@result){
            if($_ =~ /^[\da-f]{4}h\s+/i){
                my @tmp = split(/\s+/, $_);
                my $num = scalar(@tmp);
        		
                if($tmp[$num-4] =~ /MV|RV/){
                    $ldhash{$tmp[0]} = "";
                }
	        }
	    }
	}else{
		$ldhash{$ddrConst->ERR_FLAG} = $ddrConst->ERR_EXECUTE_REPL2_LIST_LD;			
	}
    return \%ldhash;
}


### Function: show help message;
### Paremeters:
###     none;
### Return:
###     none
### Output:
###     Usage:
###         disk_getpairedlds.pl <DiskArrayName>
sub printHelp(){
    print (<<_EOF_);
Usage:
    disk_getpairedlds.pl <DiskArrayName>
        
_EOF_
}
#### sub function defination End ####