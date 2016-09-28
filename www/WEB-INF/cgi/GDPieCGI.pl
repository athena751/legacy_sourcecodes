#!/usr/bin/perl
#
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: GDPieCGI.pl,v 1.1 2005/10/19 09:17:04 het Exp $"


use CGI;
use GD;
use GD::Graph::pie;
use NS::ShowErrorGraph;
use NS::CGIConstInfo;
use strict;
my $cgi=new CGI;

#1) get new object of  ShowErrorGraph  
my $errorGraph = new NS::ShowErrorGraph;
my $cgiConstInfo = new NS::CGIConstInfo();
#2) create pie graph's Data
#if(($cgi->param('up')) && ($cgi->param('ap')))
#{
#        my @data = ([$cgi->param('up'), $cgi->param('ap')],[$cgi->param('us'), 100-$cgi->param('us')]);
#}
#else
#{
        my $used = $cgi->param('us');
        if($used<0||$used>100)
        {
            print "Content-Type: image/png\n\n";
            print ($errorGraph->display());
            exit;
        }
        my $available = (1000-$used*10)/10;
      #  my $usedPresent = "used $used%";
      #  my $availablePresent = "avail $available%";
        my @data = (["", ""], [$used,$available]);
#}

#5) get new object of  GD::Graph::pie and set it
my $graph;
my $width = $cgi->param('wd');
my $height = $cgi->param('ht');
if($width>50 && $height>50)
{
    $graph = new GD::Graph::pie($width,$height);
    #$graph = new GD::Graph::pie(30,50);
    
}
else
{
    my $defaultWidth = $cgiConstInfo->GDPIE_DEFAULT_WIDTH;
    my $defaultHeight = $cgiConstInfo->GDPIE_DEFAULT_HEIGHT;
    $graph = new GD::Graph::pie($defaultWidth,$defaultHeight);
    #$graph = new GD::Graph::pie(96,96);
}
#$graph->set(pie_height =>$cgi->param('ph')) if($cgi->param('ph'));#pie hight
#$graph->set(start_angle =>$cgi->param('sa')) if($cgi->param('sa'));#start angle
#$graph->set_text_clr($cgi->param('tc')) if($cgi->param('tc'));#text color
#$graph->set(dclrs=>[qw($cgi->param('uc') $cgi->param('ac')) ]) if($cgi->param('uc')&&$cgi->param('ac'));                    
###########the color for each part
print "Content-Type: image/png\n\n";
$graph->set (
                #dclrs            => ["#8040ff","#8080ff" ],
                dclrs            => [$cgiConstInfo->GDPIE_UED_COLOR,$cgiConstInfo->GDPIE_AVAILABLE_COLOR ],
                #accentclr       => 'lgray',
                accentclr       => $cgiConstInfo->GDPIE_ACCENT_CLR,
                #axislabelclr   => 'green'
                axislabelclr       => $cgiConstInfo->GDPIE_AXISLABEL_CLR,
                #start angle 180
                start_angle     => $cgiConstInfo->GDPIE_START_ANGLE
            );
###############
#6) putout  the PNG graph to Standard out,or putout a grahp with the wrong message.
$graph->set_value_font(GD::gdSmallFont);
binmode STDOUT;
print ($graph->plot( \@data )->png);
my $err= $graph->error();  #$error="Can't display graph";
###create Error message image and put stdout### if $err;
if($err)
{
    print ($errorGraph->display());
}
