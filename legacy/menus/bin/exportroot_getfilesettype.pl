#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: exportroot_getfilesettype.pl,v 1.2301 2004/03/03 08:11:21 xiaocx Exp $"

use strict;
use NS::CodeConvert;

# check number of the argument
if(scalar(@ARGV)!=1)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}
# get the parameter 
my $cc = new NS::CodeConvert();
my $mountPoint = shift;
$mountPoint = $cc->hex2str($mountPoint);

my $cmd = "/usr/bin/syncconf status filesets";
my @content = `$cmd`;
if($?){
    print STDERR "Failed to run command \"$cmd\". Exit in perl module:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
my $filesetType = "-";
# find fileset type according to the mountpoint
for(my $i=0;$i<scalar(@content);$i++){
    if ($content[$i] =~ /^\s*Directory:\s*\Q$mountPoint\E$/){
        if ($content[$i-1] =~ /^\s*Type:\s*(export|local|import)$/){
            $filesetType = $1;
            last;
        }
    }
}
# print the fileset type
print $filesetType."\n";
exit 0;