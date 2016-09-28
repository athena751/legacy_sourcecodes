#!/usr/bin/perl -w
#
#       Copyright (c) 2005-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: replication_modifyReplica.pl,v 1.4 2008/10/09 09:48:26 chenb Exp $"

use strict;
use NS::ReplicationConst;
use NS::ReplicationCommon;

#Function: set Import Bind IP and modify file "mvdsync.import" too.
#Parameters 
        #----------------------------------------------------------------
        #name            |type   |    value
        #----------------+-------+--------------------------------------- 
        #bindIP			 |string | value of bind IP
	    #----------------+-------+---------------------------------------
        #mountPoint		 |string | mount Point
        #----------------+-------+---------------------------------------
        #originalServer  |string | original server host
	    #----------------+-------+---------------------------------------
        #replicationData |string | replication timing, onlysnap|curdata|all
	    #----------------+-------+---------------------------------------	                  
        #snapKeepLimit	 |string | -- or number
        #----------------+-------+---------------------------------------  
        
#exit value:0 succed,1:failed

#1.  check number of the argument , if it is not 2, exit 1,else get bindIP,mountPoint
my $repliCommon = new NS::ReplicationCommon;
my $repliConst = new NS::ReplicationConst;

if( @ARGV != 5 ){
    $repliConst->printErrMsg($repliConst->ERR_PARAMETER_COUNT , __FILE__, __LINE__ + 1);
    exit 1;
}
my ($bindIP, $mountPoint, $originalServer, $replicationData, $snapKeepLimit) = @ARGV;

if ($replicationData ne "curdata") {
	my $retVal = $repliCommon->reimportReplica($mountPoint, $replicationData, $originalServer, $snapKeepLimit);
	if ($retVal eq $repliConst->ERR_EXECUTE_REPL_REIMPORT) {
    	$repliConst->printErrMsg($retVal , __FILE__ , __LINE__ + 1 );
    	exit(1);
	}
}

my $ret = $repliCommon->modBindIP("import", $mountPoint , $bindIP);
if($ret ne $repliConst->SUCCESS){
    $repliConst->printErrMsg($ret , __FILE__ , __LINE__ + 1 );
    exit(1);
}

$repliCommon->dumpConf();
exit(0);
