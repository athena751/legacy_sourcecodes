#!/usr/bin/perl
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: GFSCommon.pm,v 1.6 2005/12/16 12:53:07 zhangjun Exp $"

package NS::GFSCommon;

use strict;
use NS::ConstForGFS;
use NS::SystemFileCVS;
use NS::NsguiCommon;

my $const    = new NS::ConstForGFS;
my $cvs      = new NS::SystemFileCVS;
my $nsguicommon  = new NS::NsguiCommon;

sub new(){
    my $this = {};     # Create an anonymous hash, and self points to it.
    bless $this;       # Connect the hash to the package update.
    return $this;      # Return the reference to the hash.
}

sub error(){
    my $self = shift;
    return $$self{ERROR};
}

#Function: 
#   read file
#parameters:  
#   filename: file name
#return:
#   pointer to  array of content : succeed 
#   undef : failed   
sub readFile(){
    my $self = shift;
    if(scalar(@_) != 1){
        $$self{ERROR} = "Parameters' number of function \"readFile()\" is error.\n";
        return undef;
    }
    my $filename = shift;
    if(!(-e $filename)){
        return [];
    }
    my @confContent;
    if(open(FILE,$filename)){
        @confContent = <FILE>;
        close(FILE);
        return \@confContent;
    }else{
        $$self{ERROR}="Failed to read \"$filename\" in function \"readFile()\".\n";
        return undef;
    }
}

#Function:
#   write file
#parameters:
#   filename: file name
#   contentref: pointer to  array of content
#return:
#   0: succeed
#   1: failed
sub writeFile(){
    my $self = shift;
    if(scalar(@_) != 2){
        $$self{ERROR} = "Parameters' number of function \"writeFile()\" is error.\n";
        return 1;
    }
    my ($filename,$content) = @_;
    my $fileCommon = new  NS::SystemFileCVS;
    my $cmd_syncwrite_o = $fileCommon->COMMAND_NSGUI_SYNCWRITE_O;
    if(open(FILE , "|$cmd_syncwrite_o $filename")){
        print FILE $content;
        if(!close(FILE)){
            $$self{ERROR}="Failed to write \"$filename\" in function \"writeFile()\".\n";
            return 1;    
        }
    }else{
        $$self{ERROR}="Failed to write \"$filename\" in function \"writeFile()\".\n";
        return 1;
    }
    return 0;
}

#Function:
#   modify gfs file
#parameters:
#   content: content
#return:
#   0: succeed
#   1: failed
#   2: failed,"gfsserv setdevice"excute failed
sub modifyFileProcess(){
    my $self     = shift;
    my $tmpFileName = shift;
    
    my $myNodeNo     = $nsguicommon->getMyNodeNo();
    my $myFileName   = ($myNodeNo == 0) ? $const->GFS_FILENAME_GROUP0 : $const->GFS_FILENAME_GROUP1;
    my $targetFileName = ($myNodeNo == 0) ? $const->GFS_TEMPFILE_GROUP0 : $const->GFS_TEMPFILE_GROUP1;
    
    my $cmd_syncwrite_m = $cvs->COMMAND_NSGUI_SYNCWRITE_M;
    if(system("${cmd_syncwrite_m} ${tmpFileName} ${targetFileName}")!=0) {
        system("rm -f ${tmpFileName}");
        $$self{ERROR} = "Failed to excute command \"$cmd_syncwrite_m\" in function \"modifyFileProcess()\".\n";
        return 1;
    }
    
    if($cvs->checkout($myFileName) != 0 ){
        $$self{ERROR} = "Failed to checkout file \"$myFileName\" in function \"modifyFileProcess()\".\n";
        return 1;
    }
    my $cmd = join(" ",$const->CMD_SUDO,$const->CMD_GFSSERV_SETDEVICE,$myFileName,$targetFileName);
    if( system("$cmd")!=0 ){
        $$self{ERROR} = "Failed to excute command \"$cmd\" in function \"modifyFileProcess()\".\n";
        $cvs->rollback($myFileName);
        my $rmTempFileCmd = join(" ",$const->CMD_SUDO,$const->CMD_RM,$targetFileName);
        `$rmTempFileCmd`;
        return 2;
    }
    if($cvs->checkin($myFileName) != 0){
        $$self{ERROR} = "Failed to checkin file \"$myFileName\" in function \"modifyFileProcess()\".\n";
        $cvs->rollback($myFileName);
        return 1;
    }
    return 0;
}

#Function:
#   get all the volume and the ldName
#parameters:
#   nodeNo: $nodeNo
#return:
#   pointer to the hash of volume
sub getAllVolumeAndLd() {
    my $self   = shift;
    my $nodeNo = shift;
    my $fileName = ($nodeNo == 0) ? $const->FILE_ASSIGN_NODE0 : $const->FILE_ASSIGN_NODE1;
    my %volume;
    if(-f $fileName){
        my $cmd = join(" ",$const->CMD_SUDO,$const->CMD_CAT,$fileName,$const->PRA_DEV2NULL);
        my @fileContent = `$cmd`;
        if($? != 0 ){
            $$self{ERROR} = join("","Failed to read the file \"$fileName\" in function getAllVolumeAndLd()",__FILE__," line:",__LINE__,".\n");
            return undef;
        }
        foreach(@fileContent){
            if($_ =~ /^\s*NV_LVM_(\S+)\s+(.+)$/){
                my @splitString = split(/\s+/,$2);
                for(my $i = 0; $i < scalar(@splitString); $i++ ){
                    $volume{$1}{'LD'}{$splitString[$i]} = $splitString[$i];
                }
            }
        }
    }
    return \%volume;
}

#Function:
#   get volume's mount point
#parameters:
#   nodeNo: nodeNo
#   volumeRef: pointer to the hash of volume
#return:
#   pointer to the hash of device
sub getMountPoint() {
    my ($self,$nodeNo,$volumeRef) = @_;
    my $fileName = ($nodeNo == 0) ? $const->FILE_CFSTAB_NODE0 : $const->FILE_CFSTAB_NODE1;
    if(!(-f $fileName)){
        %$volumeRef = ();
        return defined;
    }
    my $cmd = join(" ",$const->CMD_SUDO,$const->CMD_CAT,$fileName,$const->PRA_DEV2NULL);
    my @stabFileContent = `$cmd`;
    if($? != 0 ){
        $$self{ERROR} = join("","Failed to read the file \"$fileName\" in function getMountPoint() of ",__FILE__," line:",__LINE__,".\n");
        return undef;
    }
    foreach(@stabFileContent){
        if($_ =~ /^\s*\/dev\/NV_LVM_\S+\/NV_LVM_(\S+)\s+(\S+)\s+/){
            if(defined($$volumeRef{$1})){
                $$volumeRef{$1}{'mountPoint'} = $2;
            }
        }
    }
    my %ld;
    my @volumes = keys(%$volumeRef);
    foreach (@volumes){
        if( !defined( $$volumeRef{$_}{'mountPoint'} ) ){
            delete($$volumeRef{$_});
        }else{
            my $ldHashRef = $$volumeRef{$_}{'LD'};
            foreach (keys %$ldHashRef){
                $ld{$_}{'name'} = $_;
            }
        }
    }
    return \%ld;
}

#Function:
#   get volume's size
#parameters:
#   volumeRef: pointer to the hash of volume
#return:
#   succeed:  0
#   failed:   1
sub getVolumeSize() {
    my $self      = shift;
    my $volumeRef = shift;
    my $cmd = join(" ",$const->CMD_SUDO,$const->CMD_VGDISPLAY,$const->PRA_DEV2NULL);
    my @vgDisplayConntent = `$cmd`;
    if($? != 0 ){
        $$self{ERROR} = join("","Failed to execute the command \"$cmd\" in function getVolumeSize() of ",__FILE__," line:",__LINE__,".\n");
        return 1;
    }
    
    foreach (keys(%$volumeRef)){
        $$volumeRef{$_}{'volumeSize'} = "--";
    }
    
    my $volumeName = "";
    foreach (@vgDisplayConntent) {
        if ($_ =~ /^\s*VG\s+Name\s+NV_LVM_(\S+)\s+/) {
            $volumeName = $1;
        }
        if(defined($$volumeRef{$volumeName})){
            if ($_ =~ /^\s*VG\s+Size\s+(\d+[\.\d+]*)\s*(\S+)\s*$/) {
                my $unit = $2;
                my $vgSize;
                if ($unit eq "TB") {
                    $vgSize = $1 * 1024;
                } elsif ($unit eq "GB") {
                    $vgSize = $1;
                } elsif ($unit eq "MB") {
                    $vgSize = $1 / 1024;
                } elsif ($unit eq "KB") {
                    $vgSize = $1 / 1024 /1024;
                }
                $vgSize = sprintf("%.1f", $vgSize);
                $$volumeRef{$volumeName}{'volumeSize'} = $vgSize;
                next;
            }
        }
    }
    return 0;
}

#Function:
#   get ld's size
#parameters:
#   volumeRef: pointer to the hash of ld
#return:
#   succeed:  0
#   failed:   1
sub getLdSize() {
    my $self  = shift;
    my $ldRef = shift;
    foreach (keys %$ldRef){
        my $cmd = join(" ",$const->CMD_SUDO,$const->CMD_SFDISK,"$_",$const->PRA_DEV2NULL);
        my $result = `$cmd`;
        if($? == 0 ){
            chomp($result);
            my $deviceSize = $nsguicommon->deleteAfterPoint($result/1024/1024 , 1);
            $$ldRef{$_}{'deviceSize'} = $deviceSize;
        }else {
            $$ldRef{$_}{'deviceSize'} = "--";
        } 
    }
    return 0;
}

#Function:
#   get ld's type
#parameters:
#   volumeRef: pointer to the hash of ld
#return:
#   succeed:  0
#   failed:   1
sub getLdType() {
    my ($self,$nodeNo,$ldRef) = @_;
    
    my $fileName = ($nodeNo == 0) ? $const->GFS_FILENAME_GROUP0 : $const->GFS_FILENAME_GROUP1;
    my $fileContentRef=&readFile($self,$fileName);
    if( !defined($fileContentRef) ){
        return 1;
    }
    
    my @directEditLds = ();
    my @autoSetLds    = ();
    foreach(@$fileContentRef){
        if(/^\s*(\S+)\s+(\S+)\s+(\S+)\s*$/){
            push (@directEditLds,$1);
        }elsif(/^\s*(\S+)\s*$/){
            push (@autoSetLds,$1);
        }
    }
    
    foreach (keys %$ldRef){
        my $ldName = $_;
        $$ldRef{$ldName}{'type'} = "other";
        foreach(@directEditLds){
            if($_ eq $ldName){
                $$ldRef{$ldName}{'type'} = "edit";
                last;
            }
        }
        foreach(@autoSetLds){
            if($_ eq $ldName){
                $$ldRef{$ldName}{'type'} = "auto";
                last;
            }
        }
    }
    return 0;
}

#Function:
#   get ld's wwnn and lun
#parameters:
#   volumeRef: pointer to the hash of ld
#return:
#   succeed:  0
#   failed:   1
sub getLdWwnnAndLun() {
    my $self = shift;
    my $ldRef = shift;
    my $fileName = $const->FILE_LDHARDLN_CONF;
    foreach ( keys(%$ldRef) ){
        $$ldRef{$_}{'deviceWwnn'} = "--";
        $$ldRef{$_}{'deviceLun'} = "--";
    }
    if(!(-f $fileName)){
        return 0;
    }
    my $cmd = join(" ",$const->CMD_SUDO,$const->CMD_CAT,$fileName,$const->PRA_DEV2NULL);
    my @ldHardLn = `$cmd`;
    if($? != 0 ){
        $$self{ERROR} = join("","Failed to read the file:\"$fileName\" in function getLdWwnnAndLun() of ",__FILE__," line:",__LINE__,".\n");
        return 1;
    }
    foreach(@ldHardLn){
        if ($_ =~ /^\s*(\S+)\s*,\s*(\S+)\s*,\s*(\d+)\b/) {
            if(defined($$ldRef{$1})){
                $$ldRef{$1}{'deviceWwnn'} = $2;
                $$ldRef{$1}{'deviceLun'} = $3;
            }
        }
    }
    return 0;
}

#Function:
#   get the gfs serial no
#parameters:
#   ldRef: pointer to the hash of ld
#return:
#   succeed:  0
#   failed:   1
sub getSerialNo() {
    my $self = shift;
    my $ldRef = shift;
    
    my $cmd = join(" ",$const->CMD_SUDO,$const->CMD_GFSSERV_SERIAL,$const->PRA_DEV2NULL);
    my @serials = `$cmd`;
    if($? != 0 ){
        $$self{ERROR} = join("","Failed to execute the command \"$cmd\" in function getSerialNo() of ",__FILE__," line:",__LINE__,".\n");
        return 1;
    }
    
    my %ldSerials;
    foreach(@serials){
        if(/^\s*(\/dev\/\S+)\s+\S+\s+\S+\s+(\S+)\s*$/){
            $ldSerials{$1}=$2;
        }
    }
    foreach (keys %$ldRef){
        my $ldName = $_;
        if (defined($ldSerials{$ldName})){
            $$ldRef{$ldName}{'serialNo'} = $ldSerials{$ldName};
        }else{
            $$ldRef{$ldName}{'serialNo'} = "--";
        }
    }
    return 0;
}

1;