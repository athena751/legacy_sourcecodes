#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: mapd_buildsid.pl,v 1.2301 2004/01/07 00:49:06 wangli Exp $"
use strict;

if(scalar(@ARGV)!=4){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;    
}
my ($etcpath, $global, $ntdomain, $netbios) = @ARGV;

my $file = "${etcpath}nas_cifs/$global/$ntdomain/smb.conf.$netbios";

#getsid
&readFile($file);

#buildsid
if (system("sudo /home/nsadmin/bin/ns_smbpasswd.sh -S -g $global -l $ntdomain -L $netbios > /dev/null") != 0) {
    exit 1;
}

#getsid
&readFile($file);

exit 1;

sub readFile(){
    my $file = shift;
    my @content;
    if(-e $file) {
        if(!open(IN, $file)) {
            print STDERR " Can't open file $file. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
            exit 1;
        }
        @content = <IN>;
        close(IN);
    }else{
        exit 1;        
    }

    foreach (@content) {
        if ($_ =~ /^\s*security\s*=\s*domain\s*$/i){
            exit 101;
        }
        if ($_ =~ /^\s*security\s*=\s*share\s*$/i){
            exit 102;
        }
        if ($_ =~ /^\s*security\s*=\s*ads\s*$/i){
            exit 103;
        }
        if ($_=~/^\s*sid\s*machine\s*prefix\s*=\s*(.+)\s*$/i) {
            print "$1\n";
            exit 0;
        }
        
    }
}