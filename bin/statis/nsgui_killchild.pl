#!/usr/bin/perl
#
#       Copyright (c) 2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: nsgui_killchild.pl,v 1.2 2006/07/03 05:16:00 pangqr Exp $"

#############################################################

use strict;

if (scalar(@ARGV) != 2) {
  die("few arguments\nUsage: nsgui_killchild.pl <signal> <pid>\n");
}

my $sig = shift(@ARGV);
if ($sig !~ /^\d+$/) {
  die("signal must be integer.\n");
}

my $ppid = shift(@ARGV);
if ($ppid !~ /^\d+$/) {
  die("pid must be integer.\n");
}

my @pslist = `ps -eo state,ppid,pid,cmd`;
if ($? != 0) {
  die("$!\n");
}
shift @pslist;  # remove header at first line.

kill_childs($sig, $ppid);

exit;

sub kill_childs
{
  my $sig = shift;
  my $ppid = shift;

  foreach (@pslist) {
    my @field = split(/\s+/, $_);
    my $pid = $field[2];
    if (($field[1] == $ppid) && ($pid != $$)) {
      kill_childs($sig, $pid);
      kill($sig, $pid);
    }
  }

  return;
}
