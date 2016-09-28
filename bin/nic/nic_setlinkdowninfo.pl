#!/usr/bin/perl
#copyright (c) 2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: nic_setlinkdowninfo.pl,v 1.5 2007/08/30 03:35:22 chenbc Exp $"
#Function :
    #use command to set portfail over 's info.
#Arguments: 
    #takeOver :yes|no
    #bondDown :all|each
    #checkInterval:integer
    #ignoreList:xx(,xx)
#exit code:
    #0:succeed 
    #1:fail
#output:
    #--

use strict;
use NS::NsguiCommon;
use NS::NicCommon;
my $com = new NS::NsguiCommon;
my $nicCmn = new NS::NicCommon;

if(scalar(@ARGV)!= 4){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    print "Usage: ",__FILE__," <takeOver>"," <bondDown>"," <checkInterval>"," <ignoreList>";
    exit 1 ;
}

my ($takeOver,$bondDown,$checkInterval,$ignoreList) = @ARGV;
my $getLinkInfoCmd="/usr/sbin/linkdown_ctl status 2>/dev/null";
my $setLinkInfoCmd="/usr/sbin/linkdown_ctl set";
my $setIgnoreListCmd="/usr/sbin/linkdown_ctl ignore_list";
my $ec="";

#step1:set self node
#clear ignore list
if ($takeOver eq "yes"){
    $ec=system("$setIgnoreListCmd clear 2>/dev/null")/256;
	if ($ec!=0 && $ec!=2){
	    print STDERR 'Failed to clear ignore list. Exit in perl script:',
	              __FILE__, ' Line:', __LINE__+1, ".\n";
	    exit 1;
	}
}
#set link down info
$ec=&setLinkInfo($takeOver,$bondDown,$checkInterval,"false");
if ($ec!=0){
    if(!printErrorMsg($ec, __FILE__, __LINE__+4)){
        print STDERR 'Failed to set linkdown information. Exit in perl script:',
                  __FILE__, ' Line:', __LINE__+2, ".\n";
    };
    exit 1;
}
#set ignore list
if ($takeOver eq "yes" && $ignoreList ne ""){
    $ec=&setIgnoreList($ignoreList,"false");
    if ($ec!=0){
        if(!printErrorMsg($ec, __FILE__, __LINE__+4)){
            print STDERR 'Failed to set ignore list. Exit in perl script:',
                     __FILE__, ' Line:', __LINE__+2, ".\n";
        };
        exit 1;
    }
}

#step2:set friend node
my $friendIP = $com->getFriendIP();
#clear ignore list
if ($takeOver eq "yes"){
    $ec = $com->rshCmd("sudo $setIgnoreListCmd clear 2>/dev/null", $friendIP);
    if ($ec!=0 && $ec!=2){
        printErrorMsg(4, __FILE__, __LINE__+1);
        exit 1;
    }
}

#set link down info
$ec=&setLinkInfo($takeOver,$bondDown,$checkInterval,"true");
if ($ec!=0){
    if(!printErrorMsg($ec, __FILE__, __LINE__+4)){
        print STDERR 'Failed to set linkdown information on friend node. Exit in perl script:',
                 __FILE__, ' Line:', __LINE__+2, ".\n";
    };
    exit 1;
}

#set ignore list
if ($takeOver eq "yes" && $ignoreList ne ""){
    $ec=&setIgnoreList($ignoreList,"true");
    if ($ec!=0){
        if(!printErrorMsg($ec, __FILE__, __LINE__+4)){
            print STDERR 'Failed to set ignore list on friend node. Exit in perl script:',
                     __FILE__, ' Line:', __LINE__+2, ".\n";
        };
        exit 1;
    }
}
exit 0;


#sub input an array address(linkdowninfo), and get bondDown and checkInterval
#return bondDown,checkInterval
sub getDefaultValue(){
    my $info=shift;
    my $tmp1="";
    my $tmp2="";
    foreach (@$info){
            if (/^\s*bonding\s+interface\s+down\s*:\s*(all|each)\s*$/){
                $tmp1=$1;
            }elsif (/^\s*check\s+interval\s*:\s*(\d+)\s*$/){
                $tmp2=$1;
            }
        }
    return $tmp1.",".$tmp2;
}

#sub function set link info
sub setLinkInfo(){
    my $to=shift;
    my $bd=shift;
    my $ci=shift;
    my $isFriend=shift;
    my $ec;
    
    if ($isFriend eq "true"){
        if ($to eq "no"){#if takeOver =no,get info from file.
            ($ec,my $friendContent) = $com->rshCmdWithSTDOUT ("sudo $getLinkInfoCmd",$friendIP);
            if ($ec==0){
                my $tmp=&getDefaultValue($friendContent);
                if ($tmp=~/(all|each)\,(\d+)/){
                    $bd=$1;
                    $ci=$2;
                }
            }elsif ($ec==2){
                $bd="all";
                $ci="30";
            }else{
                return 4;
            } 
        }
        $ec=$com->rshCmd("sudo $setLinkInfoCmd $to $bd $ci 2>/dev/null", $friendIP);
        if($ec!=0){return 4;}
    }else{
        if ($to eq "no"){#if takeOver =no,get info from file.
            my @linkdowninfo=`$getLinkInfoCmd`;
            $ec=$?/256;
            if ($ec==0){
                my $tmp=&getDefaultValue(\@linkdowninfo);
                if ($tmp=~/(all|each)\,(\d+)/){
                    $bd=$1;
                    $ci=$2;
                }
            }elsif ($ec==2){
                $bd="all";
                $ci="30";
            }else{
                return 1;
            }    
        }
        $ec=system("$setLinkInfoCmd $to $bd $ci 2>/dev/null")/256;
        if ($ec==1){return 2;}
        elsif($ec!=0){return 1;}
    }
    return 0;
}
#sub function set ignore list
sub setIgnoreList(){
    my $il=shift;
    my $isFriend=shift;
    my $ec;
    if ($isFriend eq "true"){
        $ec=$com->rshCmd("sudo $setIgnoreListCmd $il 2>/dev/null", $friendIP);
        if($ec!=0){return 4;}
    }else{
        $ec=system("$setIgnoreListCmd $il 2>/dev/null")/256;
        if ($ec==1){return 2;}
        elsif($ec==19){return 3;}
        elsif($ec!=0){return 1;}
    }
    return 0;
}

#sub function which prints error message and error code
sub printErrorMsg(){
    my ($errCode, $file, $line) = @_;
    if($errCode == 2){
        print STDERR $nicCmn->ERRMSG_SLAVE_IN_IGNORELIST."\n";
        $com->writeErrMsg($nicCmn->ERRCODE_SLAVE_IN_IGNORELIST, $file, $line);
    }elsif($errCode == 3){
        print STDERR $nicCmn->ERRMSG_INVALID_IN_IGNORELIST."\n";
        $com->writeErrMsg($nicCmn->ERRCODE_INVALID_IN_IGNORELIST, $file, $line);
    }elsif($errCode == 4){
        print STDERR $nicCmn->ERRMSG_FAIL_SET_FRIEND."\n";
        $com->writeErrMsg($nicCmn->ERRCODE_FAIL_SET_FRIEND, $file, $line);
    }else{
        return 0;
    }
    return 1;
}

exit 0;