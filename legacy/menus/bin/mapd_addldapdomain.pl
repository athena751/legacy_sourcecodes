#!/usr/bin/perl
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: mapd_addldapdomain.pl,v 1.1 2004/02/09 11:24:22 wangli Exp $"

#/usr/bin/ims_domain -A wangli ldu -o host=11 -o basedn=as ds -o mech=DIGEST-MD5 -o usetls=n -o bindname=ass -o bindpasswd=333 -o sidprefix=S-1-5-21-0-3884537481-4043727914 -f -c /etc/group0/ims.conf
#/usr/bin/ims_domain -A .0 ldu -o host=11 -o basedn=as ds -o mech=DIGEST-MD5 -o usetls=n -o bindname=ass -o bindpasswd=333 -f -c /etc/group0/ims.conf

#function:the wrapper of ims_domain for ldu, when the bindpasswd exist in CLI
#parameter:the parameter of ims_domain,besides the bindpasswd
#input:bindpasswd
#output:the output of the ims_domain
#exit:the exit of the ims_domain

use strict;
my @opts = @ARGV;
my $bindPasswd = <STDIN>;
chomp($bindPasswd);
splice(@opts,13,0,("-o",$bindPasswd));
system("/usr/bin/ims_domain", @opts);
exit $?/256;