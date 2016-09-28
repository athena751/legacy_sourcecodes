#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: filesystem_makeAllDir.pl,v 1.1 2004/08/30 10:34:55 caoyh Exp $"


use strict;

#check number of the argument,if it isn't 1,exit
if(scalar(@ARGV)!=1)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}
#get the parameter and change its coding

my $groupNo  = shift;
my $filename = "/etc/group".$groupNo."/cfstab";

unless (-f $filename){
    if(system("touch $filename") != 0){
        print STDERR "Failed to touch file \"$filename\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit(1);        
    }
}    

if(!open(INPUT,"$filename"))
{
    print STDERR "Open $filename failed. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit(1);    
}

my @content = <INPUT>;
close(INPUT);

foreach(@content) {
    if(/\s*[^#]\S+\s+\S+\s+/) {
        my @tmp    = split(/\s+/,$_);
        if($tmp[1] =~ m"^/export/")
        {
            if (split(/\//,$tmp[1])==4){
                if(system("mkdir -p $tmp[1]")!=0)
                {
                    #print STDERR "Failed to execute \"mkdir -p $mp\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
                    print "$tmp[1]\n";
                    exit(0);
                }
                if(system("chmod 777 $tmp[1]")!=0)
                {
                    #print STDERR "Failed to execute \"chmod 777 $tmp[1]\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
                    print "$tmp[1]\n";
                    exit(0);
                }
            }
        }    
    }
}

exit(0);

## -------------------END--------------------##
