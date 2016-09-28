#!/usr/bin/perl
#
#       Copyright (c) 2001-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: quota_getreport.pl,v 1.2302 2007/02/27 07:27:48 zhangjun Exp $"

use strict;
use NS::CodeConvert;

########add by zhangjun
use NS::NsguiCommon;
use NS::USERDBCommon;
my $userdbCommon = new NS::USERDBCommon;
my $nsguicommon  = new NS::NsguiCommon;
########

#check the number of argument , if it isn't  3 , exit
my $args=scalar(@ARGV);

if ($args!=7 && $args!=3 )  #modify by maojb on 2003.8.1
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1); 
} 

#get all the parameters , and change filesystem's coding
my $cc = new NS::CodeConvert();

my $command1 = shift;
my $command2 = shift;
my $filesystem = shift;
my $type=shift;
my $switch=shift;
my $limit=shift;

#added by maojb on 2003.8.1
my $displayControl=shift;
if ($filesystem=~/^0x/){
    $filesystem = $cc->hex2str($filesystem);
}
#run the command

########add by zhangjun
$filesystem =~ /^\s*(\/export\/[^\/]+)/;
my $exportGroup = $1;
my $groupNo  = $nsguicommon->getMyNodeNo();
my $encoding = $userdbCommon->getExpgrpCodePage($groupNo, $exportGroup);

$filesystem = $cc->changeUTF8Encoding($filesystem, $encoding, $cc->ENCODING_UTF8_NEC_JP);
if(!defined($filesystem) ) {
    print STDERR "Changing encoding failed. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
########

my @result = `$command1 $command2 \Q$filesystem\E`;

#add begin: by jinkc for [nas-dev-necas:07705]:2003/04/03
if ($? != 0){
    print STDERR "Failed to execute   \"$command1 $command2 $filesystem\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit (1);
}
#add end: by jinkc for [nas-dev-necas:07705]:2003/04/03

my $len = scalar(@result);
########add by zhangjun
foreach($result[0],$result[$len-4]){
    my $temp = $cc->changeUTF8Encoding($_, $encoding, $cc->ENCODING_UTF_8);
    if(!defined($temp) ) {
        print STDERR "Changing encoding failed. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
    $_ = $temp;
}
########

if($args==3) {
    print "$result[$len-4]";
    print "$result[$len-3]";
    print "$result[$len-2]";
    print "$result[$len-1]";
    exit 0;
}

if(($len-11) > $limit ) {
    print "1\n";
} else {
    print "0\n";
}

if($type eq "name") {
    my $name;
    my $id;

    for(my $i=0; $i<6; $i++) {
        print "$result[$i]";
    }

    for(my $i=6; $i<$len-5 && $i<6+$limit; $i++) {
        $result[$i]=~/^\s*(\d+)\s+.*/;
        $id = $1;
        if(defined($id) && ($id ne "")) {
            $name = &getName($filesystem,$id,$switch);
            if($displayControl eq "all") {
                $result[$i]=~s/^\s*\d+/$name/;
                print "$result[$i]";
            } elsif($displayControl eq "except") {
                if($name!~/^Unknown\[$id\]$/){
                    $result[$i]=~s/^\s*\d+/$name/;
                    print "$result[$i]";
                }
            } else {
                if($name=~/^Unknown\[$id\]$/){
                    $result[$i]=~s/^\s*\d+/$name/;
                    print "$result[$i]";
                }
            }
        }
    }    
} else {
    for(my $i=0; $i<$len -5 && $i<6+$limit; $i++) {
        print "$result[$i]";
    }
}

print "$result[$len-5]";
print "$result[$len-4]";
print "$result[$len-3]";
print "$result[$len-2]";
print "$result[$len-1]";
exit(0);

sub getName(){
    my $path=shift;
    my $id=shift;
    my $switch=shift;
    my $getNameCmd="echo \"set dir=".$path.";set id=";
    $getNameCmd=$getNameCmd.$switch.$id.";mapto name\" |sudo /sbin/ims_ctl";
    
    my @name=`$getNameCmd`;
    if($name[1]=~/ioctl failed:/) {     #modify by jinkc for [nas-dev-necas:07692]:2003/04/03
        return "Unknown[$id]";
    }
    
    #modify start: by jinkc for [nas-dev-necas:07691]:2003/04/03
    $name[1]=~/result:\s(.+)\s\(name\)\s*$/;
    my $ugname = $1;
    $ugname=~s/\s/:/g;
    return $ugname;
    #modify end: by jinkc for [nas-dev-necas:07691]:2003/04/03
}