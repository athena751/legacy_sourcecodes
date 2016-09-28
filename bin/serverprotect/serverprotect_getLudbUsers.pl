#!/usr/bin/perl -w
#
#       Copyright (c) 2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: serverprotect_getLudbUsers.pl,v 1.1 2007/03/23 05:23:31 qim Exp $"

# Function:
#       Get Ludb Users.
# Parameters:
#       groupNo
#       domain
#       computer
#       type       ( realtimescan | backup )
# output:
#       ludbUser
# Return value:
#       0: successfully exit;
#       1: parameters error or command excuting error occured;

use strict;
use NS::ServerProtectConst;
my $const = new NS::ServerProtectConst;

if(scalar(@ARGV)!=4)
{
    print STDERR "Parameter'number Error. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

my $groupNo=shift;
my $domain=shift;
my $computer=shift;
my $type=shift;

my $scan_group=$const->LUDB_SCAN_GROUP;
my $backup_group=$const->LUDB_BACKUP_GROUP;
my $cmd= $const->COMMAND_LUDB;
my $ludbInfoFile="/etc/group${groupNo}/ludb.info";

my $link_file="/.nas_cifs/DEFAULT/${domain}/smbpasswd.${computer}";
if ( -f $ludbInfoFile ){
    my @content = `cat $ludbInfoFile 2>/dev/null`;
    if( $? == 0 && scalar(@content) != 0){
        my $ludb="";
        #get ludb with domain computer
        foreach(@content){
            if($_=~/^\s*(\w+)\s+\S+\Q$link_file\E\s*$/){
                $ludb=$1;
                last;
            }
        }
        if($ludb ne ""){
            my $gid="";
            if($type eq "realtimescan"){
                $gid=&getgid($ludb,$scan_group);
            }elsif($type eq "backup"){
                $gid=&getgid($ludb,$backup_group);
            }
            if($gid ne ""){
                my $user=&getuser($ludb,$gid);
                if(defined($user) && scalar(@$user) != 0 ){
                    print @$user;
                }
            }
        }
    }
}
exit 0;

# get gid by groupName and ludb
sub getgid(){
    my $ludb=shift;
    my $groupName=shift;
    my $gid="";
    my @content =`$cmd userlist \Q$ludb\E group 2>/dev/null`;
    if ($? == 0 && scalar(@content) != 0){
        foreach(@content){
            if($_=~/^\s*\Q$groupName\E\s+(\d+)\s*$/){
                $gid=$1;
                last;
            }
        }
    }
    return $gid;
}

#get user with ludb and gid
sub getuser(){
    my $ludb=shift;
    my $gid=shift;
    my @user;
    my $tmpuser="";
    my $count=0;
    my @content = `$cmd userlist $ludb 2>/dev/null`;
    if ($? == 0 && scalar(@content) != 0){
        foreach(@content){
            if($count >= 200 ){
                last;
            }
            if($_=~/^\s*(\S+.*)\s+\d+\s+$gid\s*$/){
                $tmpuser=$1;
                $tmpuser=~ s/\s*$//;
                if(length($tmpuser) <= 20){
                    push(@user,"$tmpuser\n");
                    $count++;
                }
            }
        }
    }
    return \@user;
}

