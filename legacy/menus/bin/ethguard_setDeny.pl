#!/usr/bin/perl
#
#       Copyright (c) 2001-2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: ethguard_setDeny.pl,v 1.8 2005/09/01 05:56:34 key Exp $"

use strict;
use NS::EthguardCommon;

#    Definition: set port 8282 and 8585 to deny
#    Parameter:
#         none
#    Return value:
#         successful - exit 0;
#         failed - exit 1;

my $const=new NS::EthguardCommon;
my $cmdAvailBond8282     = $const->CMD_AVAIL_BOND_8282;
my $cmdAvailBond8585     = $const->CMD_AVAIL_BOND_8585;
my $cmdAvailLO8282    = $const->CMD_AVAIL_LO_8282;
my $cmdAvailLO8585    = $const->CMD_AVAIL_LO_8585;
my $cmdDenyBond8282      = $const->CMD_DENY_BOND_8282;
my $cmdDenyBond8585      = $const->CMD_DENY_BOND_8585;
my $cmdDenyLO8282     = $const->CMD_DENY_LO_8282;
my $cmdDenyLO8585     = $const->CMD_DENY_LO_8585;
my $cmdIptablesSave     = $const->CMD_IPTABLES_SAVE;
my ($denyBond8282OK,$denyBond8585OK,$denyLO8282OK,$denyLO8585OK)=(0,0,0,0);
my $cmdIptablesList     = $const->CMD_IPTABLES_Lnv_INPUT;
my $keyBond              = "!bond0";
my $keyLO             = "lo";
my $port8585            = "8585";
my $port8282            = "8282";
my @content = `$cmdIptablesList`;
if($?!=0){
  print STDERR "Failed to get iptables information. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
  exit 1;
}

if(&getFilterString($keyBond,$port8282)){
    if(system($cmdDenyBond8282)){
        print STDERR "Failed to run command \"${cmdDenyBond8282}\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }else{
        $denyBond8282OK = 1;
    }
}
if(&getFilterString($keyBond,$port8585)){
    if(system($cmdDenyBond8585)){
        &rollback($denyBond8282OK,$denyBond8585OK,$denyLO8282OK,$denyLO8585OK);
        print STDERR "Failed to run command \"${cmdDenyBond8585}\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }else{
        $denyBond8585OK = 1;
    }
}
if(&getFilterString($keyLO,$port8282)){
    if(system($cmdDenyLO8282)){
        &rollback($denyBond8282OK,$denyBond8585OK,$denyLO8282OK,$denyLO8585OK);
        print STDERR "Failed to run command \"${cmdDenyLO8282}\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }else{
        $denyLO8282OK = 1;
    }
}
if(&getFilterString($keyLO,$port8585)){
    if(system($cmdDenyLO8585)){
        &rollback($denyBond8282OK,$denyBond8585OK,$denyLO8282OK,$denyLO8585OK);
        print STDERR "Failed to run command \"${cmdDenyLO8585}\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }else{
        $denyLO8585OK = 1;
    }
}

if(system($cmdIptablesSave)){
    &rollback($denyBond8282OK,$denyBond8585OK,$denyLO8282OK,$denyLO8585OK);
    print STDERR "Failed to run command \"${cmdIptablesSave}\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

exit 0;

sub rollback(){
    if(scalar(@_) != 4){
        print STDERR "The number of parameters is wrong. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
    my ($denyBond8282OK,$denyBond8585OK,$denyLO8282OK,$denyLO8585OK) = @_;
    if($denyBond8282OK){
        system($cmdAvailBond8282);
    }
    if($denyBond8585OK){
        system($cmdAvailBond8585);
    }
    if($denyLO8282OK){
        system($cmdAvailLO8282);
    }
    if($denyLO8585OK){
        system($cmdAvailLO8585);
    }
}

sub getFilterString(){
    my ($interface,$port) = @_;
    my $target="";
    if ($interface eq "!bond0"){
        $target = "DROP"
    }else{
        $target = "ACCEPT"
    }

   foreach(@content){
     if(/^\s*\S+\s+\S+\s+${target}\s+\S+\s+\S+\s+\Q${interface}\E\s+\S+\s+\S+\s+\S+\s+tcp\s+dpt\s*:\s*${port}\s*$/){
         return 0;
     }
        }
        return 1;

}



