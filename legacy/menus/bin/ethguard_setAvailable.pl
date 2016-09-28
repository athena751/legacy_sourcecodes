#!/usr/bin/perl
#
#       Copyright (c) 2001-2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: ethguard_setAvailable.pl,v 1.7 2005/09/01 05:56:34 key Exp $"

use strict;
use NS::EthguardCommon;

#    Definition: set port 8282 and 8585 to available
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
my ($availBond8282OK,$availBond8585OK,$availLO8282OK,$availLO8585OK)=(0,0,0,0);
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

if(!(&getFilterString($keyLO,$port8282))){
    if(system($cmdAvailLO8282)){
        print STDERR "Failed to run command \"${cmdAvailLO8282}\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }else{
        $availLO8282OK = 1;
    }
}
if(!(&getFilterString($keyLO,$port8585))){
    if(system($cmdAvailLO8585)){
        &rollback($availBond8282OK,$availBond8585OK,$availLO8282OK,$availLO8585OK);
        print STDERR "Failed to run command \"${cmdAvailLO8585}\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }else{
        $availLO8585OK = 1;
    }
}

if(!(&getFilterString($keyBond,$port8282))){
    if(system($cmdAvailBond8282)){
        &rollback($availBond8282OK,$availBond8585OK,$availLO8282OK,$availLO8585OK);
        print STDERR "Failed to run command \"${cmdAvailBond8282}\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }else{
        $availBond8282OK = 1;
    }
}
if(!(&getFilterString($keyBond,$port8585))){
    if(system($cmdAvailBond8585)){
        &rollback($availBond8282OK,$availBond8585OK,$availLO8282OK,$availLO8585OK);
        print STDERR "Failed to run command \"${cmdAvailBond8585}\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }else{
        $availBond8585OK = 1;
    }
}

if(system($cmdIptablesSave)){
    &rollback($availBond8282OK,$availBond8585OK,$availLO8282OK,$availLO8585OK);
    print STDERR "Failed to run command \"${cmdIptablesSave}\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
exit 0;

sub rollback(){
    if(scalar(@_) != 4){
        print STDERR "The number of parameters is wrong. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
    my ($availBond8282OK,$availBond8585OK,$availLO8282OK,$availLO8585OK) = @_;
    if($availBond8282OK){
        system($cmdDenyBond8282);
    }
    if($availBond8585OK){
        system($cmdDenyBond8585);
    }
    if($availLO8282OK){
        system($cmdDenyLO8282);
    }
    if($availLO8585OK){
        system($cmdDenyLO8585);
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

