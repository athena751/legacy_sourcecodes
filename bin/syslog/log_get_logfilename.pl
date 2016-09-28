#!/usr/bin/perl -w
#       Copyright (c) 2004-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: log_get_logfilename.pl,v 1.4 2008/05/16 04:48:03 hetao Exp $"

#Function: 
    #get the log file name from the conf file 
	
#Arguments: 
    #$conffile       :  the conf file name 
	#	/etc/sysconfig/nfsd/nfsaccesslog.conf
	#   /etc/sysconfig/nfsd/perform2.conf
	#$split       :  the split flag ":" "="
  
#exit code:
    #0:succeed 
    #1:failed
#output:
    #filename\n
    
use strict;
use NS::NsguiCommon;
use NS::SyslogConst;

my $comm  = new NS::NsguiCommon;
my $const = new NS::SyslogConst;

if(scalar(@ARGV)!=2){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}
my $conffile = shift;
my $separator = shift;
my $filename = "";
my @content = `cat $conffile`;

foreach(@content){
    if(/^\s*logfile\s*\Q$separator\E\s*(.+)$/){
        $filename = $1;
        chomp($filename);
        $filename =~ s/\s+$//g;
        last;      
   }
}

print "$filename\n";
my $getFileSize = '/opt/nec/nsadmin/bin/log_getFileSizeList.pl';
my $size = `echo \Q${filename}\E | ${getFileSize} 'nfsLog'`;
$size = '' if ($?!=0);
chomp($size);
print "${size}\n";

exit 0;