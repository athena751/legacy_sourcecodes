#!/usr/bin/perl
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: General3.pm,v 1.1 2005/10/18 16:54:15 het Exp $"



package NS::General3;
####import the module that will be used next
use strict;
use NS::MonitorConfig3;
use NS::NASCollector3;
use NS::ConstInfo;
use NS::Common;

# The constructor function of NAS.
sub new()
{
    my $this = {}; # Create an anonymous hash,and #self points to it.
    bless $this; # Connect the hash to the package update.
    return $this; # Return the reference to the hash.
}

sub collector()
{
    my $Common=new NS::Common();
    my $ConstInfo=new NS::ConstInfo();
    my($self, $mc, $target, $collectionItem, $subItemListRef, $interval)=@_;
    my $result;
    my $targetDef = $mc->getTargetDef($target);
    if(!$targetDef){
        $Common->writeSyslog('General3.pm','collector',$ConstInfo->getSyslogDebug(),$mc->error());
        return undef;
    }
    ###   3)get information of watchItem
    my $collectionItemDef=$mc->getCollectionItemDef($collectionItem);
    if(!$collectionItemDef){
        $Common->writeSyslog('General3.pm','collector',$ConstInfo->getSyslogDebug(),$mc->error());
        return undef;
    }
    my $rrdDir= $mc->getRRDFilesDir($target, $collectionItem);
    if(!$rrdDir){
        $Common->writeSyslog('General3.pm','collector',$ConstInfo->getSyslogDebug(),$mc->error());
        return undef;
    }
    my ($ds, $rra, $RRDinfo, $ipAddr);
    $ds=$collectionItemDef->{"dataSources"};
    $ds=$ds->{"dataSource"};    
    $rra=$collectionItemDef->{"archives"};
    $RRDinfo={"ds"=>$ds,"rra"=>$rra};
    $ipAddr=$targetDef->{"address"};
    
    my $nas=new NS::NASCollector3();
    $result=$nas->update([$mc,$target,$collectionItem,$rrdDir,$RRDinfo,$ipAddr,$subItemListRef,$interval]);
    return $result;
}
1;