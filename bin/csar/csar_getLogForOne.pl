#!/usr/bin/perl -w
#
#       Copyright (c) 2008-2009 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
#
# "@(#) $Id: csar_getLogForOne.pl,v 1.3 2009/03/11 02:08:27 fengmh Exp $"
#Function:  
#   get archive file in one node
#Parameters: 
#   logType: full|summary
#Output:
#   result: status code
#   output: full path of log file,full path of md5 file,size | csar error info | ""
#
#exit code:
#   0 -- success
#   1 -- failed

use strict;
use NS::SystemFileCVS;
use NS::CsarConst;

if(scalar(@ARGV)!=1){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}
my $logType = shift;

my $cvs = new NS::SystemFileCVS;
my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;
my $const = new NS::CsarConst;
my $logdir=$const->CSAR_DIR;
my $result="-1";
my @md5info=();

#1: delete old file
system("/bin/rm -rf ${logdir}/csar*");
system("/bin/rm -f ${logdir}/*.md5sum");
system("/bin/rm -f ${logdir}/*.notice");

#2:csar save
#log         stinger0-20080130-010940  cc01c636e6f45636c6862724112fd7f4
#csar-log-stinger0-20080130-010940.tar.gz 
#summary     stinger0-20080130-010912  4352fb5b066a1ff1546fed3e4eb5db89
#csar-summary-stinger0-20080130-010912.tar.gz

my $logCMD=$const->CSAR_CMD_GET_SUMMARY;
if($logType eq "full"){
    $logCMD=$const->CSAR_CMD_GET_FULL;
}
my @csarInfo=`$logCMD 2>&1`;
my $exitCode = $?/256;
if ($exitCode !=0){
    my $output="";
    if($exitCode == 2){
        $result="1";
    }elsif($exitCode == 141){
        $result="2";
    }else{
        chomp(@csarInfo);
        $output=join ("\t", @csarInfo);
        $output="csar save error:exit '$logCMD'(ret=$exitCode)"."\t"."$output";
        $result="3";
    }
    print "$result\n";
    print "$output\n";
    exit 0;
}

#3:set info to md5sum file
my $tmptype=$logType; # full|summary
my $hostname="";
my $logfile="";

if($logType eq "full"){
    $tmptype="log";
    @md5info=@csarInfo;
}
foreach(@csarInfo){
    if($_=~/^\s*${tmptype}\s+(([\w][\w\-]*)\-\d{8}\-\d{6})\s+\w{32}\s*/){
        $logfile="csar-${tmptype}-$1.tar.gz";
        $hostname=$2;
        if ($tmptype eq "summary"){
            push (@md5info,$_);
        }
        last;
    }
}

my $MD5FILE="${logdir}/${hostname}.md5sum";
(-f ${MD5FILE}) || system("touch ${MD5FILE}");
open(FILE,"| ${cmd_syncwrite_o} ${MD5FILE}");
print FILE @md5info;
if(!close(FILE)){
    #$result=4;
    system("/bin/rm -f ${MD5FILE}");
    print "4\n";
    print "\n";
    exit 0;
}

#4:success
my $logSize=`ls -l ${logdir}/${logfile}| awk '{print \$5;}'`;
chomp($logSize);
my $md5Size=`ls -l ${MD5FILE}| awk '{print \$5;}'`;
chomp($md5Size);
my $fileSize=$logSize + $md5Size;
print "$result\n";
print "${logfile},${hostname}.md5sum,${fileSize}\n"; 
exit 0;
