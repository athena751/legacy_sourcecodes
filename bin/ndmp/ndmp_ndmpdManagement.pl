#!/usr/bin/perl
#opyright (c) 2006 NEC Corporation
#
#    NEC SOURCE CODE PROPRIETARY
#
#    Use, duplication and disclosure subject to a source code
#    license agreement with NEC Corporation.
#
# "@(#) $Id: ndmp_ndmpdManagement.pl,v 1.2 2006/10/09 01:26:18 qim Exp $"

if(scalar(@ARGV)!=1){
    print STDERR "PARAMETER ERROR\n";
    exit 1;
}
my $parameter = ${ARGV[0]};
my $cmd = "/opt/nec/ndmp/ndmp_service";
if($parameter eq "status"){
    `$cmd status 2>/dev/null 1>&2`;
    if($?==0){
        print "start\n";
    }else{
        print "stop\n";
    }
    exit 0;
}elsif($parameter eq "restart"){
    `$cmd stop 2>/dev/null 1>&2`;
    `$cmd start 2>/dev/null 1>&2`;
    if($?!=0){
        print "START_SCRIPT_EXEC_ERR\n";
        exit 0;
    }

}else{
    `$cmd $parameter 2>/dev/null 1>&2`;
    if($?!=0){
        if($parameter eq "start"){
            print "START_SCRIPT_EXEC_ERR\n";
        }else{
            print "STOP_SCRIPT_EXEC_ERR\n";
        }
        exit 0;
    }
}
print "SCRIPT_EXEC_SUCCESS";
exit 0;

