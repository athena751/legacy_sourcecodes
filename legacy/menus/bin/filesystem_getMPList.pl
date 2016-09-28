#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: filesystem_getMPList.pl,v 1.2301 2004/11/12 02:22:28 wangzf Exp $"

use strict;
use NS::CodeConvert;
if(scalar(@ARGV)!=2)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#
# define and initial some variables

my $etcPath        = shift;
my $exportRoot     = shift;
#
$exportRoot = $exportRoot."/";
my $fstab    = $etcPath."cfstab";
my $mtab    = "/etc/mtab";
my $cc        = new NS::CodeConvert();
my $mountPoint     = "";
my $status;
my @fstabLine;
my @mtabLine;

system("touch $fstab")   unless (-e $fstab);
# Open the file specified by $filename and read it
my @mtabContains;
if(!open(MTAB,"$mtab"))
{
    print STDERR "The file \"$mtab\" can not be opened. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit(1);
}
while(<MTAB>)
{
   # $_=~s/\t+/ /;
    @mtabLine    = split(/\s+/,$_);
    if($mtabLine[1] =~ m"^$exportRoot")
    {
        push (@mtabContains,$_);
    }

}
close(MTAB);
if(!open(FSTAB,"$fstab"))
{
    print STDERR "The file \"$fstab\" can not be opened. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit(1);
}
my $repliStatus;
my $psid_exist;
while(<FSTAB>)
{
   # $_=~s/\t+/ /;
    @fstabLine    = split(/\s+/,$_);

    if(-d $fstabLine[1]."/.psid_lt") {
        $psid_exist="true";
    }else{
        $psid_exist="false";
    }

    if($fstabLine[1] =~ m"^$exportRoot")
    {
        $status = "-";
        $repliStatus = "-";
        foreach my $inMtab (@mtabContains)
        {
            @mtabLine = split(/\s+/,$inMtab);
            if($fstabLine[1] eq $mtabLine[1])
            {
                $status = "Mounted";
                last;
            }
        }
        my @tempArray = split(/\//,$fstabLine[0]);
        $mountPoint = $cc->str2hex($fstabLine[1]);
        my $fstype =  $fstabLine[2];
        if($fstype eq "syncfs")
        {
            if($_ =~ /cache_type=\s*(\w*)\W/)
            {
                $fstype = $1;
            }
            $repliStatus = "enable";
        }
        
        my $mode = "off";
        my $quota = "off";
        my $update = "on";
        my $dmAPI = "off";
        
        my @tmp = split(/,/, $fstabLine[3]);
        if ( scalar(grep(/^rw$/, @tmp)) >0 ){
                $mode = "on";
        }

        if ( scalar(grep(/^usrquota$/, @tmp)) >0 ){
                $quota = "on";
        }
        
        if ( scalar(grep(/^noatime$/, @tmp)) >0 ){
                $update = "off";
        }

        if ( scalar(grep(/^hsm$/, @tmp)) >0 ){
                $dmAPI = "on";
        }
        
        print "$mountPoint $tempArray[3] $status $fstype $repliStatus $psid_exist $mode $quota $update $dmAPI\n";
    }
}
close(FSTAB);

exit(0);