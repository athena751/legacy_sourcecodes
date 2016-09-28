#! /usr/bin/perl
#
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: cifs_haveParentACL.pl,v 1.2 2008/03/07 00:55:07 chenbc Exp $"

use strict;

use NS::CodeConvert;
use NS::CIFSConst;
use NS::CIFSCommon;

my $codeConvert = new NS::CodeConvert;
my $const      = new NS::CIFSConst;
my $cifsCommon = new NS::CIFSCommon;

my $paranum = scalar(@ARGV);
if($paranum != 4){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}

my $groupNumber = shift;
my $domainName=shift;
my $computerName=shift;
my $directoryPath = shift;

$directoryPath =~ s/\/+/\//g;
$directoryPath =~ s/\/*$//;

my $expGroupEncoding = $cifsCommon->getExpGroupEncoding($groupNumber, $domainName, $computerName);

if(!defined($expGroupEncoding)) {
    print STDERR "Get export group is error"."\n";
    exit 1;
}
$directoryPath = $codeConvert->changeUTF8Encoding($directoryPath, $expGroupEncoding, $codeConvert->ENCODING_UTF8_NEC_JP);

if(!defined($directoryPath)){
    print STDERR "Get machine type failed.\n";
    exit 1;
}

while(1){
    if (-d $directoryPath) {
        last;
    } else {
        my $thePos = rindex($directoryPath , "/");
        $directoryPath = substr($directoryPath , 0 , $thePos);
    }
}

my $checkACLCmd = "/usr/bin/attr -l";
my $cutCmd = "/bin/cut";
my $grepCmd = "/bin/fgrep";

`${checkACLCmd} \Q${directoryPath}\E 2>/dev/null| ${cutCmd} -f2 -d' ' | ${grepCmd} 'NAS_ACL_1.0'`;
if($? == 0){
    print "yes\n";
}else{
    print "no\n";
}
exit 0;