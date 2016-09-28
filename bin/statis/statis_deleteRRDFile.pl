#!/usr/bin/perl 
#
#       Copyright (c) 2001-2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: statis_deleteRRDFile.pl,v 1.2 2005/10/19 05:40:54 het Exp $"

use strict;
use NS::MonitorConfig;
if (scalar(@ARGV) < 3){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}
# Get arguments
my $target = shift;
my $collectionItem = shift;
my @resources = @ARGV;

# Prepare
my $mc = new NS::MonitorConfig();
$mc->loadDefs() or exit 1;

$mc->lockRRD($target, $collectionItem) or exit 1;

my $path = $mc->getRRDFilesDir($target, $collectionItem) or _exit();
my $rfi = $mc->loadRRDFilesInfo($target, $collectionItem);
_exit() if (!$rfi);

foreach my $resource (@resources) {
    # Delete the RRD file
    $resource  = $1 if($resource =~ /^\s*\#dev\#NV_LVM_([^\/]+)\#NV_LVM_\1\s*$/);
    
    system("rm -f $path/RRD${resource}.rrd");
    
    # Remove the entry from RRDFilesInfo.xml
    delete($rfi->{$resource});
}

# Done.
$mc->saveRRDFilesInfo($target, $collectionItem, $rfi) or _exit();
$mc->unlockRRD($target, $collectionItem) or exit 1;

exit 0;

sub _exit{
  $mc->unlockRRD($target, $collectionItem);
  exit 1;
}