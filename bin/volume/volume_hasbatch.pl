#!/usr/bin/perl -w
#
#       Copyright (c) 2009 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: volume_hasbatch.pl,v 1.1 2009/01/12 10:06:09 wanghb Exp $"
# Function:
#     check whether there is batch volume setting in this exportgroup.
# Parameters:
#     $exportgroup ---- the exportgroup (ex.stingerA)
# Output:
#     STDOUT----yes|no
#     STDERR----error message and error code
# Returns:
#     0----success
#     1----failed

use strict;

if(scalar(@ARGV)!=1){
    print STDERR "PARAMETER ERROR.Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
my $exportgroup = shift;
my $hasFlag = "no";
my $cmd_ps  = "/bin/ps -axuwww 2>/dev/null";
my @retVal = `$cmd_ps`;
#root      9880 13.5  0.0 11988 7660 ?        S    17:40   0:00 /usr/bin/perl -w /home/nsadmin/bin/nas_fsbatch.pl create --do lunlist=2000003013840266(26) 
# --fs ftype=sxfs --mo snapshot=100,quota=on,useGfs=false,wpperiod=-- --lo name=NV_LVM_vol008,striped=false --mp /export/stingerA/vol008
my $strBatch  = "/usr/bin/perl -w /home/nsadmin/bin/nas_fsbatch.pl create";
my @arrayBatch = ();
@arrayBatch = grep(/$strBatch/, @retVal);
if(scalar(@arrayBatch) >0){
    foreach(@arrayBatch) {
        if(/\s+--mp\s+\/export\/\Q${exportgroup}\E\//) {
            $hasFlag = "yes";
            last;
        }
    }
}
print "$hasFlag\n";
exit 0;
