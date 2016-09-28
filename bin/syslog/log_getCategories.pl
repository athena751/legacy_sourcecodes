#!/usr/bin/perl -w
#       Copyright (c) 2004-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: log_getCategories.pl,v 1.3 2007/03/07 01:02:26 wanghui Exp $"

#Function: 
    #get all the key of the directory "/home/nsadmin/etc/logview",
    #then get the first line of all the key file
#Arguments: 
    #none
#exit code:
    #0:succeed 
    #1:parameter's number error
    #2:the key file is empty
#output:
    #key=the first line of the key's file

use strict;
use NS::NsguiCommon;
use NS::SyslogConst;

my $comm  = new NS::NsguiCommon;
my $const = new NS::SyslogConst;

#check the parameter's number = 0
if(scalar(@ARGV)!=0){
    $comm->writeErrMsg($const->ERRCODE_PARAMETER_NUMBER_ERROR,__FILE__,__LINE__+1);
	exit 1;
}

my $dir = $const->CONST_LOGVIEW_PATH;
if  (!(-d $dir)){
    exit 0;
}

my @categories = `ls ${dir}`;
my ($category,$categoryFile);
foreach (@categories){
    $category = $_;
    chomp $category;
    $categoryFile = "$dir/$category";
    if (-f $categoryFile){
        if (-z $categoryFile){
            print STDERR "The category file:${category} is empty!\n";
            next;
        }
        open COK,"<${categoryFile}";
        my $keyword = <COK>;
        chomp $keyword;
        close COK;
        print "category=${category}\n";
        print "keyword=${keyword}\n";
    }
}

exit 0;