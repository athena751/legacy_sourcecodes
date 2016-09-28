#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: mapd_getregion.pl,v 1.2301 2004/03/12 04:48:16 key Exp $"


use strict;
use NS::CodeConvert;

#(scalar(@ARGV)==1) or exit 1;
if(scalar(@ARGV)!=2)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit 1;    
}
my $cc=new NS::CodeConvert();
my $imsPath = shift;
my $mp=shift;
my $a;
my $region="";
$mp=$cc->hex2str($mp);
if (!$mp) 
{ 
    print STDERR "Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
#my $mp="/export/nec/mp1";
#my @content = `sudo /home/nsadmin/src/test/mapd/test.sh`;
my @temp;
my @content=`/usr/bin/ims_auth -Lv -c $imsPath`;

foreach(@content)
    {
        #if(/^$mp\/\..*/){
        if(/^\Q$mp\E\s+/)
        {
            @temp = split(/\s+/,$_);
            $a=@temp;
            if ($a==2) 
                {$region=$temp[1];}
        }
    }
print "$region\n";
exit 0;
