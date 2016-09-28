#!/usr/bin/perl -w
#       Copyright (c) 2004-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: log_fileexists.pl,v 1.6 2008/05/16 04:44:56 hetao Exp $"

#Function: 
    #if the file is exist,output "true",else oupput "false"
#Arguments: 
    #file name
#exit code:
    #0: success
    #1: parameter's number is error
#output:
    #"true" or "false"

use strict;
use NS::NsguiCommon;
use NS::SyslogConst;
use NS::CodeConvert;
use NS::ExportgroupConst;

my $exportgroupConst = new NS::ExportgroupConst();
my $comm  = new NS::NsguiCommon;
my $const = new NS::SyslogConst;
my $cc=new NS::CodeConvert();
#check the parameter's number = 0
if(scalar(@ARGV)!=2&&scalar(@ARGV)!=1&&scalar(@ARGV)!=3){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
    exit 1;
}

my ($fileName, $encoding, $withSize) = @ARGV;
if(defined($encoding) && $encoding eq $exportgroupConst->STRING_UPPERCASE_UTF){
    if($fileName =~ /^\/export\//){
        my $checkChange = $cc->needChange($cc->ENCODING_UTF8_NEC_JP);
    	if(defined($checkChange) && $checkChange eq "y"){
        $fileName = $cc->changeEncoding($fileName, $cc->ENCODING_UTF_8, $cc->ENCODING_UTF8_NEC_JP);
        if(!defined($fileName)){
            exit 1;
        }
        }
    }
}
if(-f $fileName){
    print "true\n";
}else{
    print "false\n";
}

if(defined($withSize)){
	my $getFileSize = '/opt/nec/nsadmin/bin/log_getFileSizeList.pl';
    my $size = `echo \Q${fileName}\E | ${getFileSize} 'cifsLog'`;
    $size = '' if ($?!=0);
    chomp($size);
    print "${size}\n";
}

exit 0;