#!/usr/bin/perl
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: volume_isbasempexist.pl,v 1.2 2005/09/30 08:29:16 liuyq Exp $"

###Function : get all the mount point path in system from mount command and cfstab file
###Parameter: 
###     directory
###Return:
###     0 : success
###     1 : error occurs
###Output:
###     1.stdout
###       true:  Exist directory that start with the specified directory.
###       false: No directory that start with the specified directory.

use strict;

my $path = shift;
my $dirName = `/usr/bin/dirname $path`;
chomp($dirName);

if(-d "$dirName") {
    my $baseName = `/bin/basename $path`;
    chomp($baseName);
    
    my @dirs = `/bin/ls -l $dirName`;
    @dirs = grep(/^d/, @dirs);
    chomp(@dirs);
    
    foreach(@dirs) {
        if ($_=~/^(\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s)(.*)$/){
            my $curDir = $2;
            if($curDir =~ /^\Q${baseName}\E\_\d+/) {
                print "true\n";
                exit 0;
            }            
        }
    }
}
               
print "false\n";
exit 0;