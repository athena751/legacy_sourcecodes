#!/usr/bin/perl
#
#       Copyright (c) 2001-2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: General.pm,v 1.2302 2006/11/13 04:47:45 zhangjun Exp $"



package NS::General;
####import the module that will be used next
use strict;
use NS::MonitorConfig;
use NS::NASCollector;
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
    my $len = @_;
    if($len != 6)
    {
        #add error message to syslog
        my $errString = $ConstInfo->getParameterErr();
        my $errCode = $ConstInfo->getBParameterErr();
        $errString = join("",("[",$errCode,"]",$errString));
        $Common->writeSyslog('General.pm','collector',$ConstInfo->getSyslogDebug(),$errString);
        return undef;
    }
    my($self, $mc, $target, $collectionItem, $stockPeriod, $interval)=@_;
    my $result;
    
    my $targetDef = $mc->getTargetDef($target);
    if(!$targetDef)
    {
        $Common->writeSyslog('General.pm','collector',$ConstInfo->getSyslogDebug(),$mc->error());
        return undef;
    }
    my $targetType=$targetDef->{"type"};
    ###   3)get information of watchItem
    my $collectionItemDef=$mc->getCollectionItemDef($collectionItem);
    if(!$collectionItemDef)
    {
        $Common->writeSyslog('General.pm','collector',$ConstInfo->getSyslogDebug(),$mc->error());
        return undef;
    }
        my $rrdDir= $mc->getRRDFilesDir($target, $collectionItem);
        if(!$rrdDir)
        {
            $Common->writeSyslog('General.pm','collector',$ConstInfo->getSyslogDebug(),$mc->error());
            return undef;
        }
            
        my ($ds, $rra, $RRDinfo, $info, $ipAddr);
        
        $info = $targetDef->{"info"};
        $ds=$collectionItemDef->{"dataSources"};
        $ds=$ds->{"dataSource"};    
        $rra=$collectionItemDef->{"archives"};
        $RRDinfo={"ds"=>$ds,"rra"=>$rra};
        $ipAddr=$targetDef->{"address"};
        
        my $nas=new NS::NASCollector();
        $result=$nas->update([$collectionItem,$rrdDir,$RRDinfo,$stockPeriod,$ipAddr,$interval,ref($mc)]);
        return $result;
}
1;