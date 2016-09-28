#!/usr/bin/perl
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: GDBarCGI.pl,v 1.1 2005/10/19 09:17:04 het Exp $"


use CGI;
use GD;
use NS::CGIConstInfo;
use strict;
my $cgi=new CGI;


#1)create bar graph
my $width = $cgi->param('wd');
my $height = $cgi->param('ht');
my $graph;
my $cgiConstInfo = new NS::CGIConstInfo();
if($width>0 &&$height>0)
{
    $graph = new GD::Image($width, $height);
}
else
{
    
    #$graph = new GD::Image(200,16);
    $graph = new GD::Image($cgiConstInfo->GDBAR_ERROR_GRAPH_WIDTH,$cgiConstInfo->GDBAR_ERROR_GRAPH_HEIGHT);
    my $white = $graph->colorAllocate(255,255,255);
    my $red = $graph->colorAllocate(255,0,0);
    my $blue = $graph->colorAllocate(0,0,255);
    $graph->rectangle(0,0, $cgiConstInfo->GDBAR_ERROR_GRAPH_WIDTH-1, $cgiConstInfo->GDBAR_ERROR_GRAPH_HEIGHT()-1,$blue);
    $graph ->fill(10,10,$white);
    $graph ->string(gdTinyFont,0,3,$cgiConstInfo->GDBAR_INVALID_SIZE_ERRMSG,$red);
}
#my $backclr = $graph->colorAllocate(10,100,255);
my $backclr = $graph->colorAllocate($cgiConstInfo->GDBAR_BACK_RED,$cgiConstInfo->GDBAR_BACK_GREEN,$cgiConstInfo->GDBAR_BACK_BLUE);
#my $foreclr = $graph->colorAllocate(60,50,225);
my $foreclr = $graph->colorAllocate($cgiConstInfo->GDBAR_FORE_RED,$cgiConstInfo->GDBAR_FORE_GREEN,$cgiConstInfo->GDBAR_FORE_BlUE);
#my $border = $graph->colorAllocate(128, 128, 128);
my $border = $graph->colorAllocate($cgiConstInfo->GDBAR_BORDER_RED,$cgiConstInfo->GDBAR_BORDER_GREEN,$cgiConstInfo->GDBAR_BORDER_BlUE);
my $red = $graph->colorAllocate(255,0,0);
my $partWidth = 10;
my $proportion = $cgi->param('pr');
if($proportion<=0)
{
    $partWidth = 0;     
}
elsif($proportion>=100)
{
    $partWidth=$width;    
}
else
{
    $partWidth = $width*$proportion/100;
    #$partWidth = $proportion;
}
$graph->filledRectangle(0,0, $width-1, $height-1,$backclr) if($width>0);
#$graph->fill($width-2, $height-2, $backclr) if($width > 2); 
$graph->filledRectangle(0,0, $partWidth -1, $height-1,$foreclr) if($partWidth>0);
#$graph->fill($partWidth-2, $height-2,$foreclr) if($partWidth > 2);
#2)putout  the PNG graph to Standard out,or putout a grahp with the wrong message.
$graph->rectangle(0, 0, $width-1, $height-1, $border);

print "Content-Type: image/png\n\n";
binmode STDOUT;
print $graph->png;
