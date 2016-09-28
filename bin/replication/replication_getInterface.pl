#!/usr/bin/perl -w
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: replication_getInterface.pl,v 1.1 2005/09/15 05:29:22 liyb Exp $"

use strict;
use NS::ReplicationCommon;
use NS::ReplicationConst;
my $comm = new NS::ReplicationCommon;
my $repliConst = new NS::ReplicationConst;
my ($result , $errCode)  = $comm->getUpIPList();
if(defined($errCode)){
    $repliConst->printErrMsg($errCode , __FILE__ , __LINE__ + 1);
    exit(1);
}
if(scalar(@$result)>0){
    foreach(@$result){
        print "$_\n";
    }
}
exit 0;

