#!/usr/bin/perl
#
#       Copyright (c) 2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: nsgui_iconvByLicense.pl,v 1.2 2006/02/20 00:31:12 fengmh Exp $"

use strict;
use NS::RPQLicenseNo;
use NS::NsguiCommon;

my $RPQ_No = new NS::RPQLicenseNo;
my $nsguiCommon = new NS::NsguiCommon;
my $nsguiIconv = "/home/nsadmin/bin/nsgui_iconv.pl";

my $isLicenseExist = $nsguiCommon->checkRPQLicense($RPQ_No->RPQLICENSENO_UTF8);

my $iconv = join(" ", $nsguiIconv, @ARGV);
if($isLicenseExist == 0){
    while (<STDIN>) {
        open(ICONV, "|$iconv")
             or die ("cannot pipe to iconv: $!\n");
        print(ICONV);
        close(ICONV) or warn("iconv: $?\n");
    }
}else{
	while (<STDIN>){
        print;
    }
}
exit;
