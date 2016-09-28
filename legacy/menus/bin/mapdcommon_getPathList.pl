#!/usr/bin/perl

#
#       Copyright (c) 2001-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: mapdcommon_getPathList.pl,v 1.2306 2008/05/28 03:27:06 liy Exp $"

use strict;
use NS::CodeConvert;
use NS::VolumeCommon;
use NS::VolumeConst;

if(scalar(@ARGV)!=3){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}
my $cc=new NS::CodeConvert();
my $volumeCommon = new NS::VolumeCommon();
my $volumeConst = new NS::VolumeConst();

my $filename="/etc/mtab";
if($ARGV[0] eq "-d"){
    my $exportRoot=$ARGV[1];
    my $er=join("",split("/",$exportRoot));
    if(!open(INPUT,"$filename"))
    {
        print STDERR "the $filename can not be opened! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit(1);
    }
    while(<INPUT>){
        if(/^\s*#.*/){
            next;
        }elsif($_!~m"$exportRoot"){
            next;
        }else{
            my @tmp=split(/\s+/,$_);
            if(scalar(@tmp)>1){
                my @list=split("/",$tmp[1]);
                if((scalar(@list)==4)&&($er eq $list[1].$list[2])){
                    my $mountPoint=$cc->str2hex('/'.$list[1].'/'.$list[2].'/'.$list[3]);
                    print "$mountPoint\n";
                }
            }
        }
    }
    close(INPUT);
}elsif(($ARGV[0] eq "-p")||($ARGV[0] eq "-dq")||($ARGV[0] eq "-s")||($ARGV[0] eq "-q")||($ARGV[0] eq "-snap")){

    my $path=$ARGV[1];
    my $etcPath=$ARGV[2];
    $path=$cc->hex2str($path);
    my $accessMode = &getAccessMode($path, $etcPath);
    my @tmp;
    my $result;
    my $flag;
    my $cowUsed_oldLimit;
    if(!$path){
        print STDERR "the path should be hex string. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit(1);
    }
    if(!open(INPUT,"$filename"))
    {
        print STDERR "the $filename can not be opened! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit(1);
    }
    
    my $mpsOptions = $volumeCommon->getMountOptionsFromCfstab();
    if(defined($$mpsOptions{$volumeConst->ERR_FLAG})){
        $volumeConst->printErrMsg($$mpsOptions{$volumeConst->ERR_FLAG});
        exit 1;
    }
	my $vgInfo;
    if($ARGV[0] eq "-snap"){
    	$vgInfo = $volumeCommon->getVgdisplayInfo();
    	if ((defined($$vgInfo{$volumeConst->ERR_FLAG}))&&($$vgInfo{$volumeConst->ERR_FLAG} ne "")){
    		exit 2;
    	}
    }
    while(<INPUT>){
        $flag = 0;
        if(/^\s*#.*/){
            next;
        }elsif(($_!~m"${path}")||($_=~m"\s${path}\s")){
            next;
        }elsif($_=~m"\s${path}/"){
            @tmp=split(/\s+/,$_);
            if(scalar(@tmp)>3){
                if($ARGV[0] eq "-p"){
                #get submountPoint in the specify path
                    $result=$cc->str2hex($tmp[1]);
                    print "$result\n";
                }elsif($ARGV[0] eq "-s"){
                # get submountPoint in the specify path except direct mountPoint
                    if(&count($tmp[1])>3){
                        $result=$cc->str2hex($tmp[1]);
                        print "$result\n";
                    }
                #}elsif(($ARGV[0] eq "-q")&&($tmp[3]=~/rw/ && $tmp[3]=~/usrquota,grpquota/)){
                }elsif(($ARGV[0] eq "-q")&& ($tmp[3]=~/usrquota,grpquota/)){
                #get read-write submountPoint in specify path with quota, for quota.
                    if($accessMode->{$tmp[1]} eq "rw"){
                        $result=$cc->str2hex($tmp[1]);
                        print "$result\n";
                    }
                }elsif(($ARGV[0] eq "-dq")&&($tmp[3]=~/usrquota,grpquota/)){
                #get read-write submountPoint in specify path with quota, for quota.
                    if($accessMode->{$tmp[1]} eq "rw"){
                        $result=$cc->str2hex($tmp[1]);
                        print "$result\n";
                    }
                #}elsif(($ARGV[0] eq "-snap")&&($tmp[3]=~/rw/)){
                }elsif($ARGV[0] eq "-snap"){
                #get read-write submountPoint in specify path, for snapshot.
                    #if( $tmp[2] eq "syncfs" ){
                    #    $flag = &checkMP($tmp[1]);#check if this mountPoint be made fileset, if it has be made, check the status is imported or not.
                    #}
                    #if(!$flag){
                    ###if($accessMode->{$tmp[1]} eq "rw"){
                    my $oneMpOptions = $$mpsOptions{$tmp[1]};
                    if(!defined($oneMpOptions)){
                        next;
                    }
                    if(!defined($$oneMpOptions{"dmapi"}) 
                        && !&overMaxCapacity($tmp[0],$volumeConst->VOLUME_SIZE_20TB,$vgInfo)){
                        if($$oneMpOptions{"access"} eq "rw"){
                            # original vol
                            $cowUsed_oldLimit = getUsed_limit($tmp[1]);
                            $result=$cc->str2hex($tmp[1]." rw"." ".$cowUsed_oldLimit);
                            print "$result\n";
                        }elsif($$oneMpOptions{"access"} eq "ro"){
                            # replica vol
                            if($$oneMpOptions{"repli"} eq "on"){
                                $result=$cc->str2hex($tmp[1]." syncro");
                                print "$result\n";
                            }
                        }
                    }
                }
            }
        }
    }#end while
    close(INPUT);
}else{
    print STDERR "first parameter error! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit(1);
}
exit 0;

sub count(){
    my $src = shift;
    my @temp = split("/",$src);
    my $result = scalar(@temp)-1;
    return $result;
}

sub getAccessMode(){
    my $path = shift;
    my $etcPath = shift;
    my @result=();
    my @tmp;
    my $accessMode;
    my $filename = $etcPath."cfstab";

    if(!-f $filename){
        system("touch $filename");
    }

    if(!open(FSTAB, $filename)) {
        print STDERR "the $filename can not be opened! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit(1);
    }

    while(<FSTAB>){
        if(/^\s*#.*/){
            next;
        }elsif(($_!~m"${path}")||($_=~m"\s${path}\s")){
            next;
        }elsif($_=~m"\s${path}/"){
            @tmp=split(/\s+/,$_);

            if($tmp[3]=~/\brw\b/){
                $accessMode="rw";
            }else{
                $accessMode="ro";
            }
            push(@result, $tmp[1], $accessMode);
        }
    }
    close(FSTAB);
    my %res=@result;
    return \%res;
}

### Function : check the mountPoint whether have import fileset
### if have return 1 , else return 0
sub checkMP()
{
    use NS::ConstForRepli;
    my $mountPoint    = shift;
    my $comm         = NS::ConstForRepli::COMMAND_FILESET;
    my @contents     = `$comm`;
    my $flag        = 1;
    for(my $i=2;$i<@contents;$i+=4)
    {
        if( $contents[$i+2] =~/\s*Directory\s*:\s*$mountPoint\s+|\s*Directory\s*:\s*$mountPoint$/)
        {
            $flag    = 0;### input mp is in the result of fileset command
            if($contents[$i+1] =~/Type\s*:\s*import/)
            {
                return 1;
            }else
            {
                return 0;
            }
            last;
        }
    }
    if($flag)### input mp is not in the result of fileset command
    {
        return 0;
    }
}

sub getUsed_limit()
{
    my $mountPoint = shift;
    my @result    = `/usr/sbin/sxfs_fileset $mountPoint`;
    if($?){
        print STDERR "Failed to execute \"/usr/sbin/sxfs_fileset $mountPoint\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }

    if((split(/\s+/, $result[0]))[1] !~ /\bSNAPSHOT\b/)
    {
        `/usr/sbin/sxfs_snapshot -s $mountPoint`;
        if($?){
            print STDERR "Failed to execute \"/usr/sbin/sxfs_snapshot -s $mountPoint\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
            exit 1;
        }
    }
    my @snapInfo = `/usr/sbin/sxfs_snapshot -P $mountPoint`;
    my $cowUsed = 0;
    my $oldLimit = 100;
    foreach (@snapInfo)
    {
        if($_ =~ /^\s*limit\s+(\d+)%\s+/)
        {
            $oldLimit = $1;
        }
        elsif($_ =~ /^\s*used\s+(\d+)%\s+/)
        {
            $cowUsed = $1;
        }
    }
    return "$cowUsed $oldLimit";
}

sub overMaxCapacity()
{
    my ($lvPath,$maxCapacity,$vgInfo) = @_;
    ## get Volume Name by mountpoint
    my $vgName =substr($lvPath,rindex($lvPath,"/")+1);
    ## get VG Size and check
  	my $capacity;
    if (defined($vgName) && defined($$vgInfo{$vgName})) {
        ($capacity) = split(":", $$vgInfo{$vgName});
        if($capacity>$maxCapacity){
		    return 1;
        }
    }
    return 0;
}
