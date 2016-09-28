#! /usr/bin/perl -w
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: fcsan_checkmodel.pl,v 1.1 2004/08/14 10:29:42 changhs Exp $"

my $filename = "/proc/hmd/model";

if (-e $filename){
  open(MODELFILE,$filename) || die("Can not open $filename.\n");
  @lines = <MODELFILE>;
  close(MODELFILE);
  $salar = @lines;
  if ($salar==0){
    print ("Invalid format of $filename, can not check the model!\n");
    exit 1;
  }     
  foreach $line (@lines){
     if ($line=~ /^\s*0\s+GENERAL_MODEL\s*$/){
        print ("0\n");
        exit 0;
     } elsif ($line=~ /^\s*1\s+MIRROR_MODEL\s*$/){
        print ("1\n");
        exit 0;
     } else{
        print ("Invalid format of $filename, can not check the model!\n");
        exit 1;
     }
  }
} else{
  print ("0\n");
  exit 0;
}

