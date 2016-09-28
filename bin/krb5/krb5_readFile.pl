#!/usr/bin/perl -w
#
#       Copyright (c) 2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
#"@(#) $Id: krb5_readFile.pl,v 1.1 2006/11/06 06:53:58 liy Exp $"
## Function:
##	get the content of file [/etc/krb5.conf]
##	and diff [/etc/krb5.conf] file on two node if cluster
##  
## Parameter:
##     none
##
## Output:
##     STDOUT
##         diffFlag and the content of file [/etc/krb5.conf]
##         diffFlag: 0 -- no differences; 1 -- has differences; 2 -- trouble;
##                   -1 -- other node is not active;  -2 -- failed to prepair for diff
##
##     STDERR
##         error message and error code
##
## Exits:
##     0 -- success 
##     1 -- error

use strict;
use NS::Krb5Const;
use NS::NsguiCommon;

my $krb5Const = new NS::Krb5Const;
my $nsguiCommon = new NS::NsguiCommon;

my $krb5_file = $krb5Const->FILE_KRB5;
my $cmd_touch = $krb5Const->CMD_TOUCH;
my $cmd_cat   = $krb5Const->CMD_CAT;

## touch /etc/krb5.conf if file does not exist
if (! -f $krb5_file) {
	system("${cmd_touch} ${krb5_file} 2>/dev/null");
}

## get file content 
my @fileContent = `${cmd_cat} ${krb5_file} 2>/dev/null`;
if ($? != 0) {
	$nsguiCommon->writeErrMsg($krb5Const->ERR_EXECUTE_CAT, __FILE__, __LINE__+1);
	exit 1;	
}

## init different flag
my $diffFlag = 0;

## diff /etc/krb5.conf of the two node if cluster
my $friendIP = $nsguiCommon->getFriendIP();
if (defined($friendIP)) {
	if (($nsguiCommon->isActive($friendIP)) != 0) {
		## can not get /etc/krb5.conf from the other node if node node down
    	$diffFlag = -1;	
	} else {
	    my $fileExist = $nsguiCommon->rshCmd("[ -f ${krb5_file} ]", $friendIP);
	    if (!defined($fileExist)) { 
           ## rsh failed
	       $diffFlag = -2;     
        } else {
        	## file not exist
            if ($fileExist != 0) {
        		my $touchRet = $nsguiCommon->rshCmd("sudo ${cmd_touch} ${krb5_file} 2>/dev/null", $friendIP);
        		if (!defined($touchRet) || ($touchRet != 0)) {
        			$diffFlag = -2;
        		} else {
        			$fileExist = 0;
        		}
            }
            
            ## file exist
            if ($fileExist == 0) {
			    my $tmpFile  = $krb5Const->FILE_TMP_KRB5_ONOTHERNODE.$$;
				my $cmd_rcp  = $krb5Const->CMD_RCP;
			    my $cmd_diff = $krb5Const->CMD_DIFF;
			    my $cmd_rm   = $krb5Const->CMD_RM;            	
 			    ## copy the other node's file to local node, then diff the two file
			    if (system("sudo -u nsgui ${cmd_rcp} -p ${friendIP}:${krb5_file} ${tmpFile} 2>/dev/null") == 0) {
			    	$diffFlag = system("${cmd_diff} --brief ${krb5_file} ${tmpFile} 2>&1>/dev/null") >> 8;
			    } else {
			    	## failed to rcp file from other node
			    	$diffFlag = -2;  
			    }
			    
			    ## delete temp file
			    system("sudo ${cmd_rm} -f ${tmpFile} 2>/dev/null");
            }
        }
	}
}

## print different flag(0 or 1) and the file's content
print "$diffFlag\n";
foreach (@fileContent) {
	print $_;
}
exit 0;
