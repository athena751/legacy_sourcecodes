#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: nashead_gethbainfo.pl,v 1.2300 2003/11/24 00:54:36 nsadmin Exp"

use strict;
use NS::NasHeadConst;
use NS::NsguiCommon;
my $argnum = scalar(@ARGV);
my $cmd;
my @result;
my $whichCmd;
my $const = new NS::NasHeadConst();
my $nsguiCommon = new NS::NsguiCommon;
#check the number of argument. if it more than 1, exit
if($argnum>1){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}

#check if it has "-l"
if ($argnum == 0){
    $cmd = $const->CMD_INQPORT;
    $whichCmd = 0;   
} elsif (shift eq "-l"){
    $cmd = $const->CMD_INQPORT_l;
    $whichCmd = 1; 
} else{
    print STDERR "The parameter of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}
#do /sbin/inqport or /sbin/inqport -l
@result = `$cmd`;

#command failed
if ($? != 0){
    print STDERR "Failed to execute   \"$cmd\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    $nsguiCommon->writeErrMsg($const->ERR_EXECUTE_INQPORT);
    exit(1);
}
#pirnt the result
&printResult($whichCmd, \@result);
exit(0);

sub printResult{
    my $line;
    my($whichCmd, $result)=@_;
    if ($whichCmd==0){     
        foreach $line (@$result){
            if($line=~/Port#/ || $line=~/node-name=/ || $line=~/port-name=/){
                print $line;
            }            
        }
    }else{
        my $findPort = 0;
        my $fileName = $const->FILE_GROUP0_SANNICKNAME_CONF;   
        my @storageArr;
        if (-e $fileName){
            @storageArr = `cat $fileName`;
        }
        foreach $line (@$result){
            if($findPort == 0 && $line!~/### PORT INFORMATION/){
                next;
            }elsif ($findPort == 0 && $line=~/### PORT INFORMATION/){
                $findPort = 1;
                next;
            }else{
                my @lineArr=split(/\s+/,$line);   #split with space 
                if (scalar(@lineArr)==5) {                   
                    foreach my $nameLine (@storageArr) {
                        if ($nameLine=~/^\s*$lineArr[2]\s*,(.+)/ ) {
                            my $storageName = $1;
                            $line =~s/$lineArr[2]/$storageName/;
                            last;
                        }
                    }     
                }                            
                print $line;
            }
        }
    }  
}
