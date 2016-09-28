#!/usr/bin/perl -w
#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: exportroot_deleteNFS.pl,v 1.2300 2003/11/24 00:54:35 nsadmin Exp $"


use strict;
use NS::SystemFileCVS;
#check number of the argument,if it isn't 2,exit
if(scalar(@ARGV)!=3)
{
    print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
    exit(1);
}
#get the parameter then make the keyword
my $filePath    = shift;
my $exportRoot  = shift;
my $myNum        = shift;
my $keywordS    = "#ExportRoot=".$exportRoot."start";
my $keywordE    = "#ExportRoot=".$exportRoot."end";
my $filename    = $filePath."exports";
my $common         = new NS::SystemFileCVS;
if(!-f $filename)
{
    exit 0;    
}
if($common->checkout($filename)!=0)
{
    print STDERR "Failed to checkout \"$filename\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;    
}
#give content of file to array
my @content;
if(!open(INPUT,"$filename"))
{
    $common->rollback($filename);
    print STDERR $filename," can not be opened! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;
}
@content        = <INPUT>;
close(INPUT);
#ready for the writing of file
if(!open(OUTPUT,">$filename"))
{
    $common->rollback($filename);
    print STDERR $filename," can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;    
}
my $flag        = 0;
my $tmp;
my $count        = 0;
#check the file line by line ,at the same time
#cut off the accordant lines
foreach(@content)
{
    if ((/ExportRoot/)&&(/#/)&&(/=/))
    {
        $tmp    = &filterSpace($_);
        if($tmp eq $keywordS)
        {
            $flag++;
        }
        if($tmp eq $keywordE)
        {
            $flag--;
            next;
        }
        $count++;
    }
    if($flag==0)
    {
        print OUTPUT $_;
    }
    
}
close(OUTPUT);

if($flag!=0)
{
    #open(OUTPUT,">/etc/exports")||exit(1);
    #if(!open(OUTPUT,">$filename"))
    #{
    #    $common->rollback($filename);
    #    print STDERR $filename," can not be opened. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    #    exit(1);    
    #}
    #foreach(@content)
    #{
    #    print OUTPUT $_;    
    #}
    #close(OUTPUT);
    $common->rollback($filename);
    print STDERR "The number of start sign and end sign is odd! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    exit 1;    
}
if($common->checkin($filename)!=0)
{
    print STDERR "Failed to checkout \"$filename\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
    $common->rollback($filename);
    exit 1;    
}
if($count/2>1)
{
    if(system("/usr/sbin/exportnas -g $myNum $filename")!=0)
    {
        print STDERR "Failed to execute \"/usr/sbin/exportnas\". Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        exit 1;
    }
}
exit 0;
#sub function to filter the space and tab in one line 
sub filterSpace()
{
    my $param    = shift;
    chomp($param);
    $param        =~s/\t+//;
    my $result    = "";
    my @param    = split(m"\s+",$param);
    if($param[0]=~m/\s+/)
    {
        shift(@param);    
    }
    foreach(@param)
    {
        $result=$result.$_;
    } 
    return $result;
}
##------------------------END----------------------##
