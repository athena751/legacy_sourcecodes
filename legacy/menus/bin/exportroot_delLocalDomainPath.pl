#!/usr/bin/perl -w
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: exportroot_delLocalDomainPath.pl,v 1.2302 2005/05/26 01:23:42 baiwq Exp $"

use strict;
use NS::CIFSCommon;
use NS::SystemFileCVS;
if(scalar(@ARGV)!=5){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}
my $filePath=shift;
my $globeDomain=shift;
my $localDomain=shift;
my $exportRoot=shift;
my $hasNativeDomain = shift; # if true, not delete localDomain dir, else delete it.

my $findTimes = 0;
my $cifs = new NS::CIFSCommon;
my $filename = $cifs->getSmbOrVsName($filePath,$globeDomain,0);
my $regNtdomain = $cifs->str2RegStr($localDomain);
my $common = new NS::SystemFileCVS;
if($common->checkout($filename)!=0){
    print STDERR "Failed to checkout \"$filename\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;    
}
if(!open(INPUT,"$filename")){
    $common->rollback($filename);
    print STDERR "$filename can not be opened! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit(1);
}
my @content=<INPUT>;
close(INPUT);
chomp(@content);
if(!open(OUTPUT,">$filename")){
    $common->rollback($filename);
    print STDERR "$filename can not be opened! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit(1);
}

my $thisLine;
my @netbios;
foreach $thisLine (@content){
    if($thisLine=~/^\s*#.*/){
        print OUTPUT $thisLine."\n";
    }elsif($thisLine=~/^\s*\S+\s+$regNtdomain\s+/ ||
           $thisLine=~/^\s*\S+\s+$regNtdomain$/){
        $findTimes++;
        if ($thisLine=~/^\s*$exportRoot\s+$regNtdomain/) {
            $findTimes--;
            if ($thisLine =~ /^\s*$exportRoot\s+$regNtdomain\s+(.*)$/) {
                @netbios = split(/\s+/,$1);
            }
        }else {
            print OUTPUT $thisLine."\n";
        }
    }else{
        print OUTPUT $thisLine."\n";
    }
}
close(OUTPUT);
$common->checkin($filename);

if ($findTimes==0 && $hasNativeDomain eq "false") {
    my $path=$cifs->getSmbOrVsName($filePath,$globeDomain,$localDomain,"",1);
    if(system("rm -rf $path")!=0){
        print STDERR "In perl script(",__FILE__,"), Delete the directory ".$path." failed!\n";
        exit(1);
    }
}elsif ( scalar(@netbios)>0 ) {
    my $netbiosName;
    my $netbiosFile;
    my $smbpasswdFile;
    foreach $netbiosName (@netbios) {
        $netbiosFile = $cifs->getSmbOrVsName($filePath, $globeDomain, 
                                          $localDomain, $netbiosName,0);
        
        #delete the conf file of [dir access control] before delete the smb.conf.%L
        my $group_no = 0;
        if($filePath =~ /^\/etc\/group(\d)\//){
            $group_no = $1;
        }
        my $dirAccessConfFile = $cifs->getDirAccessConfFileName($group_no, $localDomain, $netbiosName);
        if($dirAccessConfFile ne ""){
            system("rm -f $dirAccessConfFile");
        }
        if(system("rm -rf $netbiosFile")!=0){
            print STDERR "In perl script(",__FILE__,"), Delete the directory ".$netbiosFile." failed!\n";
            exit(1);
        }
        #security = share : delete the smbpasswd.$netbiosName
        $smbpasswdFile = $cifs->getSmbOrVsName($filePath, $globeDomain,$localDomain, $netbiosName,1);
        $smbpasswdFile = $smbpasswdFile."/smbpasswd.".$netbiosName;
        system("rm -rf $smbpasswdFile"); 
    }
}
system("/home/nsadmin/bin/ns_nascifsstart.sh");
exit(0);
