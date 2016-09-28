#!/usr/bin/perl -w
#
#       Copyright (c) 2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
#"@(#) $Id: krb5_writeFile.pl,v 1.1 2006/11/06 06:54:12 liy Exp $"
## Function:
##	write the content to file [/etc/krb5.conf]
##	and sync [/etc/krb5.conf] file to other node if cluster
##  
## Parameter:
##     $tmpFile -- full path of the temp file which content will be write to file [/etc/krb5.conf]
##
## Output:
##     STDOUT
##         none
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
use NS::SystemFileCVS;

my $krb5Const = new NS::Krb5Const;
my $nsguiCommon = new NS::NsguiCommon;
my $systemFileCVS = new NS::SystemFileCVS;

## check parameter number
if(scalar(@ARGV)!= 1){
	$nsguiCommon->writeErrMsg($krb5Const->ERR_PARAMER_NUM, __FILE__, __LINE__+1);
	exit 1;
}

my $tmpFile = shift;
my $krb5_file = $krb5Const->FILE_KRB5;
my $cmd_rm = $krb5Const->CMD_RM;

## checkout /etc/krb5.conf
if ($systemFileCVS->checkout($krb5_file) != 0) {
	system("$cmd_rm -f $tmpFile 2>/dev/null");
	$nsguiCommon->writeErrMsg($krb5Const->ERR_FILE_CHECKOUT, __FILE__, __LINE__+1);
	exit 1;		
}

my $cmd_syncwrite_m = $systemFileCVS->COMMAND_NSGUI_SYNCWRITE_M;

## write the content of $tmpFile to /etc/krb5.conf by [mv $tmpFile /etc/krb5.conf]
if (system("$cmd_syncwrite_m ${tmpFile} ${krb5_file} 2>/dev/null") != 0) {
	system("$cmd_rm -f $tmpFile 2>/dev/null");
	$systemFileCVS->rollback($krb5_file);
	$nsguiCommon->writeErrMsg($krb5Const->ERR_FILE_WRITE, __FILE__, __LINE__+1);
	exit 1;	
}

## checkin /etc/krb5.conf
if ($systemFileCVS->checkin($krb5_file) != 0) {
	$systemFileCVS->rollback($krb5_file);
	$nsguiCommon->writeErrMsg($krb5Const->ERR_FILE_CHECKIN, __FILE__, __LINE__+1);
	exit 1;			
}

## sync /etc/krb5.conf to other node if cluster
my $friendIP = $nsguiCommon->getFriendIP();
if (defined($friendIP)) {
	if ($nsguiCommon->syncFileToOther($krb5_file, $friendIP) != 0) {
		$nsguiCommon->writeErrMsg($krb5Const->ERR_FILE_SYNC, __FILE__, __LINE__+1);
		exit 1;				
	}
}

exit 0;
