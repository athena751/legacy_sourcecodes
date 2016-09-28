#!/usr/bin/perl
#
#       Copyright (c) 2001-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: statis_getFilesystemInfo.pl,v 1.3 2007/05/10 09:02:56 yangxj Exp $"



use strict;
use NS::MonitorConfig;
use NS::CodeConvert;
use NS::ConstForAgent;
use vars qw{@fileSystemInfo};
#input: option -d/-i String targetID String subItemID
#output:string 
#process:

    my $length=@ARGV;
    if($length!=1&&$length!=2){
         print STDERR "The number of parameters is not 1 or 2. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
         exit(1);
    }
    my $option=$ARGV[0];
    my $subItemID;
    if($length==2){
       $subItemID=$ARGV[1];
    }
    if(($option ne "-d")&&($option ne "-i")){
         print STDERR "The options of command is not '-i' or '-d'. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
         exit(1);
    }
    if($length==2){
         if(!defined($subItemID)){
              print STDERR "The subItemID is null. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
             exit(1);
         }
    }  
    
    &getFilesystemInfo();
    my $FilesystemNum = shift (@fileSystemInfo);
    print "$FilesystemNum ";
    #for each of Filesystem,get Device file name,File system type,mount point,totalsize or total inodes,Disk used or Inode used
    my $codeConvert=new NS::CodeConvert;
    my $step = 9;
    for(my $i=0;$i < $FilesystemNum; $i++){
        my ($Device,$Type,$Mount,$Avail,$Total,$Used,$UsePercent);
        
        $Device=$fileSystemInfo[$i*$step+0];
        $Device = $1 if($Device =~ /^\s*\/dev\/NV_LVM_([^\/]+)\/NV_LVM_\1\s*$/);
        if($length==2){
            if($Device ne $subItemID){
                next;
            }
        }
        $Type = $fileSystemInfo[$i*$step+1];
        $Mount = $fileSystemInfo[$i*$step+2];
        
        if($option eq "-d"){
            $Avail=$fileSystemInfo[$i*$step+3];
            $Used=$fileSystemInfo[$i*$step+6];
        }elsif($option eq "-i"){
            $Avail=$fileSystemInfo[$i*$step+4];
            $Used=$fileSystemInfo[$i*$step+8]; 
        }else{
            print STDERR "The options of command is error. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
            exit(1);
        }
        $Total=$Avail+$Used;
        if($Total eq '0'){
            $UsePercent="100";
        }else{
            $UsePercent=$Used/$Total*100;
            $UsePercent = sprintf("%1.1f",$UsePercent);
        }
        if($option eq "-d"){###########2002/5/10 lhy add for inode used rate--from GB->original data
            $Used = $Used / (1024*1024);
            $Used = sprintf("%1.1f",$Used);
            $Avail = $Avail / (1024*1024);
            $Avail = sprintf("%1.1f",$Avail);
            $Total = $Total / (1024*1024);
            $Total = sprintf("%1.1f",$Total);
        }else{
            $Used=&integer($Used);
            $Avail=&integer($Avail);
            $Total=&integer($Total);
        }         
        $Mount=$codeConvert->str2hex($Mount);
        print "$Mount $Total $Used $Type $Device $UsePercent ";
        if($length==2){
            exit(0);
        }
    }
    exit(0);

sub integer(){
    my $num = shift;
    my $index = index($num,".");
    if($index != -1){
        $num = substr($num,0,$index);
    }
    return $num;
}

sub getFilesystemInfo()
{
    my $fsType;
    my @mount_info = `mount`;
    if( $? ){
        print STDERR "Fail to run command \"mount\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit(1);
    }
    
    ### Define some local variables that will be used next 
    my $const       = new NS::ConstForAgent();
    my $commandT    = $const->COMMAND_DF_KT;
    my $commandI    = $const->COMMAND_DF_KI;
    my $sxfs        = $const->SXFS;
    my $sxfsfw      = $const->SXFSFW;
    my $syncfs      = $const->SYNCFS;
    
    my $tmpDiskResult   = `$commandT`;
    my $tmp         = $?;
    my $tmpNodeResult   = `$commandI`;
    if( $? || $tmp){
        print STDERR "Fail to run command \"df\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit(1);
    }
    $tmpDiskResult      =~s/\n/ /;
    $tmpNodeResult      =~s/\n/ /;
    my @diskInfo        = split (/\s+/,$tmpDiskResult );
    my @nodeInfo        = split (/\s+/,$tmpNodeResult );
    my @result          = ();
    my $itemNum         = 0;
    
    ###    Parse the result of command  typing ( df -kT  and df -ki)
    ##### cut the title     
    splice(@diskInfo,0,8);
    splice(@nodeInfo,0,7);
    ##### in @diskInfo find the items which have the same device name
    ##### then delete the same ones
    for (my $i=0; $i<@diskInfo; $i+=7 ){
        for (my $j=$i+7; $j< @diskInfo; $j+=7){
            if ($diskInfo[$i] eq $diskInfo[$j]){
                splice(@diskInfo,$j,7);
            }    
        }
    }
    ##### find which inode device name is same as disk device name
    ##### then push the 11 info items into @result
    LOOP1:for (my $i=0; $i<@diskInfo; $i+=7 ){
        if(($diskInfo[$i+1] ne $sxfs)
                &&($diskInfo[$i+1] ne $sxfsfw)
                &&($diskInfo[$i+1] ne $syncfs)){
            next LOOP1;
        }
        
        for ( my $j=$i+2;  $j<$i+5; $j++ ){
            if ( $diskInfo[$j] =~ "[^0-9]" ){
                next LOOP1;
            }
        }
        
        LOOP2:for (my $j=0; $j< @nodeInfo; $j+=6 ){
            for ( my $k=$j+1; $k<$j+4; $k++ ){
                next LOOP1 if ( $nodeInfo[$k] =~"[^0-9]" );
            }
            if ($diskInfo[$i] eq $nodeInfo[$j]){
                
                my @tmp = ();
                push ( @tmp,$diskInfo[$i],$diskInfo[$i+1],$diskInfo[$i+2],$diskInfo[$i+3],
                        $diskInfo[$i+4],$diskInfo[$i+5],$diskInfo[$i+6] );
        
                push ( @tmp,$nodeInfo[$j+1],$nodeInfo[$j+2],$nodeInfo[$j+3]
                           ,$nodeInfo[$j+4]);
                push ( @fileSystemInfo, $tmp[0],&getFsType(\@mount_info, $tmp[0], $tmp[1]),
                        $tmp[6], $tmp[4], $tmp[9], $tmp[2], $tmp[3], $tmp[7], $tmp[8]);
                $itemNum++;
                next LOOP1;
            }
        }### end of LOOP2
    }### end of LOOP1
    unshift  (@fileSystemInfo, $itemNum);
}# end sub updateFilesystem


sub getFsType() {
    my $point = shift;
    my @info = @$point;
    my $device = shift;
    my $fsType = shift;

    if($fsType eq "syncfs") {
        my @info = grep(/^$device\s/, @info);
        if(defined(@info)) {
            if($info[0]=~/cache_type\s*=(\w+)/) {
                $fsType = $1;
            }  
        }
    }
    return $fsType;
}