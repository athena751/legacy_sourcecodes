#!/usr/bin/perl -w
#       Copyright (c) 2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: serverprotect_deleteTempFile.pl,v 1.1 2007/03/30 07:40:09 wanghui Exp $"

#Function: delete specified temp file 
#Parameters:null
#output:    null
#exit code:
    #0 ---- success
    #1 ---- failure
    
if(scalar(@ARGV)!=1){
    print STDERR "PARAMETER ERROR.Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
my $tmpFile = shift;
my $cmdDelTmpFile = "/bin/rm -f ".$tmpFile;
system("$cmdDelTmpFile 2>/dev/null 1>&2");
exit 0;