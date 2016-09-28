#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: mapd_pwd.pl,v 1.2300 2003/11/24 00:54:36 nsadmin Exp $"

use strict;
use NS::CodeConvert;

my $len = @ARGV;
if($len != 5 && $len != 6)  
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";    
    exit 1; 
}
my $export = shift;
my $type=shift;
my $pass = shift;
my $group=shift;
my $ims_path=shift;
my $sid=shift;

my $cc=new NS::CodeConvert();
$pass=$cc->hex2str($pass);
$group=$cc->hex2str($group);

if (!$pass){
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

if (!$group){
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}

if($len == 5){
    if(system("/usr/bin/ims_domain -A $export $type -o passwd=$pass -o group=$group -f -c $ims_path")!=0){
        print STDERR "Failed to execute \"ims_domain -A $export $type -o passwd=$pass -o group=$group -f -c $ims_path\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit(1);
    }
}else{
    if(system("/usr/bin/ims_domain -A $export $type -o passwd=$pass -o group=$group $sid -f -c $ims_path")!=0){
        print STDERR "Failed to execute \"ims_domain -A $export $type -o passwd=$pass -o group=$group $sid -f -c $ims_path\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit(1);
    }
}
exit 0;
     
