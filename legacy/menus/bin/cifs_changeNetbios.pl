#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: cifs_changeNetbios.pl,v 1.2303 2005/08/29 02:49:21 liq Exp $"

# function: 
#       change the specified old netbios name with new netbios name.
#       modify files: virtual_servers, smbpasswd.{netBios},secrets.tlb.{netBios},browse.dat.<netbios>
# Parameter: 
#       $etcPath: /etc/group[0|1]/
#       $global : "DEFAULT"
#       $exportRoot : /export/{exportroot name}
#       $localDomain :
#       $oldNetbios :
#       $newNetbios :
#       $security : "share" or "domain" or "user"
#
# return value: 
#       0: successfully exit;
#       1: parameters error or command excuting error occured;

use strict;
use NS::CIFSCommon;
use NS::ConfCommon;
use NS::SystemFileCVS;

my $paraNum = scalar(@ARGV);
if($paraNum != 7 ){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}

my $etcPath = shift;
my $global = shift;
my $exportRoot = shift;
my $localDomain = shift;
my $oldNetbios = shift;
my $newNetbios = shift;
my $security = shift;

my $cifsCommon = new NS::CIFSCommon;
my $common = new NS::SystemFileCVS;
my $cmd_syncwrite_o = $common->COMMAND_NSGUI_SYNCWRITE_O;
my $cmd_syncwrite_m = $common->COMMAND_NSGUI_SYNCWRITE_M;

my $vsFile = $cifsCommon->getSmbOrVsName($etcPath,$global,0);
if($common->checkout($vsFile)!=0){
    print STDERR "Failed to checkout \"$vsFile\". Exit in perl script:" ,
             __FILE__," line:",__LINE__+1,".\n";
    exit 1;    
}

if (!open(FILE,$vsFile)) {
    $common->rollback($vsFile);
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
my @vscontent = <FILE>;
close(FILE);   #read file

my $hasFound = 0;
foreach (@vscontent) {
    if ($_ =~ /^\s*$exportRoot\s+$localDomain\s+$oldNetbios/){
        $hasFound = 1;
        $_ =  $exportRoot . " " . $localDomain . " " . $newNetbios . "\n";
        last;
    }
}

if ($hasFound==0) {
    $common->rollback($vsFile);
    print STDERR "Can not find the specified NTDomain and NetBIOS in ${vsFile}!\n Exit in perl script:"
        ,__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

#get the name of [dir access conf file] from smb.conf.%L
my $fileNameFromSmbConf = &getDirAccessConfNameFromSmbConf();

# rename smb.conf.{netBios} file.
my $oldSmbConfFile = $cifsCommon->getSmbOrVsName($etcPath,$global,$localDomain,$oldNetbios,0);
my $newSmbConfFile = $cifsCommon->getSmbOrVsName($etcPath,$global,$localDomain,$newNetbios,0);
system("rm -rf $newSmbConfFile");
if (system("${cmd_syncwrite_m} $oldSmbConfFile $newSmbConfFile") != 0){
    $common->rollback($vsFile);
    print STDERR "Rename $oldSmbConfFile failed!\n";
    exit 1;
}

# if the secure is "share" , rename the smbpasswd and secrets.tdb file.
my $oldSmbPwdFile = $etcPath . "nas_cifs/" . $global . "/" . $localDomain . "/smbpasswd." . $oldNetbios;
my $newSmbPwdFile = $etcPath . "nas_cifs/" . $global . "/" . $localDomain . "/smbpasswd." . $newNetbios;
my $oldSecrets = $etcPath . "nas_cifs/" . $global . "/" . $localDomain . "/secrets.tdb." . $oldNetbios;
my $newSecrets = $etcPath . "nas_cifs/" . $global . "/" . $localDomain . "/secrets.tdb." . $newNetbios;
my $oldBrowseFile = $etcPath . "nas_cifs/" . $global . "/" . $localDomain . "/browse.dat." . $oldNetbios;
my $newBrowseFile = $etcPath . "nas_cifs/" . $global . "/" . $localDomain . "/browse.dat." . $newNetbios;

#rename smbPasswd file
if (-f $oldSmbPwdFile){
	system("rm -rf $newSmbPwdFile");
    if (system("${cmd_syncwrite_m} $oldSmbPwdFile $newSmbPwdFile") != 0){
	    $common->rollback($vsFile);
        system("${cmd_syncwrite_m} $newSmbConfFile $oldSmbConfFile");
        print STDERR "Rename $oldSmbPwdFile failed!\n";
        exit 1;
    }
}    
#rename secrets.tdb file    
if (-f $oldSecrets){
	system("rm -rf $newSecrets");
    if (system("${cmd_syncwrite_m} $oldSecrets $newSecrets") != 0){
	    $common->rollback($vsFile);
        system("${cmd_syncwrite_m} $newSmbConfFile $oldSmbConfFile");
        (-f $newSmbPwdFile) && system("${cmd_syncwrite_m} $newSmbPwdFile $oldSmbPwdFile");
        print STDERR "Rename $oldSecrets failed!\n";
        exit 1;
    }
}

#rename browse.dat file
if (-f $oldBrowseFile) {
	system("rm -rf $newBrowseFile");
	if (system("${cmd_syncwrite_m} $oldBrowseFile $newBrowseFile") != 0) {
	    $common->rollback($vsFile);
		system("${cmd_syncwrite_m} $newSmbConfFile $oldSmbConfFile");
		if ($security eq "share"){
			(-f $newSmbPwdFile) && system("${cmd_syncwrite_m} $newSmbPwdFile $oldSmbPwdFile");
			(-f $newSecrets) && system("${cmd_syncwrite_m} $newSecrets $oldSecrets");
		}
		print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
		exit 1;
	}
}

if (!open(FILE,"| ${cmd_syncwrite_o} $vsFile")) {
    $common->rollback($vsFile);
    system("${cmd_syncwrite_m} $newSmbConfFile $oldSmbConfFile");
    (-f $newBrowseFile) && system("${cmd_syncwrite_m} $newBrowseFile $oldBrowseFile");
    if ($security eq "share"){
        (-f $newSmbPwdFile) && system("${cmd_syncwrite_m} $newSmbPwdFile $oldSmbPwdFile");
        (-f $newSecrets) && system("${cmd_syncwrite_m} $newSecrets $oldSecrets");
    }
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
print FILE @vscontent;
if(!close(FILE)){
      print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
      exit 1;
};

if($common->checkin($vsFile)!=0){
    $common->rollback($vsFile);
    system("${cmd_syncwrite_m} $newSmbConfFile $oldSmbConfFile");
    (-f $newBrowseFile) && system("${cmd_syncwrite_m} $newBrowseFile $oldBrowseFile");
    if ($security eq "share"){
        (-f $newSmbPwdFile) && system("${cmd_syncwrite_m} $newSmbPwdFile $oldSmbPwdFile");
        (-f $newSecrets) && system("${cmd_syncwrite_m} $newSecrets $oldSecrets");
    }
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
&changDirAccessConfName();
system("/home/nsadmin/bin/ns_nascifsstart.sh");
exit 0;

sub changDirAccessConfName(){
    my $groupNo = &getGroupNo();
    if(defined($fileNameFromSmbConf) && ($fileNameFromSmbConf ne "\"\"")&& ($fileNameFromSmbConf ne "")){
        my $oldConfName = $cifsCommon->varSubstitute($groupNo, $localDomain, $oldNetbios, $fileNameFromSmbConf);
        if(($oldConfName ne "")&&(-f $oldConfName)){
            my $newConfName = $cifsCommon->varSubstitute($groupNo, $localDomain, $newNetbios, $fileNameFromSmbConf);
            if($oldConfName ne $newConfName){
                system("${cmd_syncwrite_m} $oldConfName $newConfName");
            }
        }
    }
}

sub getDirAccessConfNameFromSmbConf(){
    my $smbContent = $cifsCommon->getSmbContent(&getGroupNo(), $localDomain, $oldNetbios);
    my $confCommon = new NS::ConfCommon;
    return $confCommon->getKeyValue("dir access list file", "global", $smbContent);
}

sub getGroupNo(){
    my $groupNo = 0;
    if($etcPath =~ /^\/etc\/group(\d)\//){
        $groupNo = $1;
    }
    return $groupNo;
}
