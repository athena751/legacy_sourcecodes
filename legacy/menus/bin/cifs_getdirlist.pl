#! /usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: cifs_getdirlist.pl,v 1.2302 2005/07/22 10:08:02 key Exp $"

use strict;

my $paranum = scalar(@ARGV);
if($paranum!=2){
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;
}


my $pathStr = shift;
my $type = shift;


unless (-d $pathStr) {
    print STDERR "the directroy \"$pathStr\" doesn't exist!\n";
    exit 1;
}

if($pathStr eq "/etc") {
    my $dirStr = "/etc/openldap";
    my @content = `/bin/ls -ld '--time-style=+%a %b %d %H:%M:%S %G' \Q$dirStr\E`;

    foreach(@content) {
        if(s/\/etc\/openldap/openldap/g) {
            print "$_";
        }
    }
} else {
    my @content = `/bin/ls -l '--time-style=+%a %b %d %H:%M:%S %G' \Q$pathStr\E/`;

    my $dirProperty;
    my $thisLine;
    my $thisPath;

    foreach $thisLine(@content){
        if ($type eq "dir") {
            if ($thisLine!~/^(d\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s)(.*)$/){ #2003-01-14 lhy add
                next;
            }
            $dirProperty = $1;
            $thisPath = $2;
        } else {
            if ($thisLine!~/^([\-d]\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s)(.*)$/){ #2003-01-14 lhy add
                next;
            }
            $dirProperty = $1;
            $thisPath = $2;
        }
    
    

        if($thisLine =~ /[\200-\377]/){
            next;
        } 

        if($thisPath =~ /[^a-zA-Z0-9_\.~\-]/){ 
            next;
        }

        if(substr($dirProperty,length($dirProperty)-1) eq "("){
            $dirProperty = substr($dirProperty,0,length($dirProperty)-2);
        } #why

        $thisLine = join("",($dirProperty,$thisPath));
        $thisLine=~s/\s+/ /g;

        print "$thisLine\n";
    }
}
exit 0;
