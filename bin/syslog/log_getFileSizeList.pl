#!/usr/bin/perl -w
#       Copyright (c) 2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: log_getFileSizeList.pl,v 1.2 2008/05/16 04:49:15 hetao Exp $"

#Function: 
    #Get the size of each file in file list, include the size 
    #of rotate file (if not on share partition).
#Arguments: 
    #logtype
#Input:
    #filelist seperated by \n
#exit code:
    #0: success
#output:
    #size1
    #size2
    #size3
    #...
    #(acording the order of input, print '' if the file does not exist)

use strict;
my $logtype = shift;
foreach(<STDIN>){
        chomp;
        if( $_ eq '' ){
        	print "\n";
        	next;
        }
        if(! -f $_){
        	print "\n";
        	next;
        }
        my @sizes;
        if($logtype eq "ftpLog" || $logtype eq "httpLog"){
	 		@sizes = `/home/nsadmin/bin/log_getFileList.pl "$logtype" \Q$_\E "" | xargs -0 -n1 /home/nsadmin/bin/log_getFileSizeOfFtpOrHttp.sh`;
        }else{
            @sizes = `/home/nsadmin/bin/log_getFileList.pl "$logtype" \Q$_\E "" | xargs -0 -n1 ls -l | awk '{print \$5}'`;
        }
        my $size = 0;
        chomp, $size += $_ foreach(@sizes);
        print $size,"\n";
}
exit 0;

