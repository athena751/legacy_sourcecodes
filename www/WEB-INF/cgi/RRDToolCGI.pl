#!/usr/bin/perl
#
#       Copyright (c) 2001-2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: RRDToolCGI.pl,v 1.1 2005/10/19 09:17:04 het Exp $"


#use Sydney::MonitorConfig;
use NS::MonitorConfig;
use NS::MonitorConfig2;
use NS::MonitorConfig3;
use CGI;
use GD;
use RRDs;
use NS::GraphOption;
use NS::ConstInfo;
use NS::Common;
use strict;
# Read options
my $cgi=new CGI;

print "Content-Type: image/png\n\n";

# Read config
my $Common=new NS::Common;
my $ConstInfo=new NS::ConstInfo;
my $mc;
if($cgi->param('isInvestGraph')){
  $mc = new NS::MonitorConfig2;
}
elsif($cgi->param('isNsw')){
  $mc = new NS::MonitorConfig3;
}
else{
  $mc = new NS::MonitorConfig;
}
if(!$mc)
{        
        $Common->writeSyslog("RRDToolCGI.pl","main",$ConstInfo->getSyslogErr(),"Failed: new MonitorConfig");
        display();
        exit;
}
my $flag=$mc->loadDefs();
if(!$flag)
{        
        $Common->writeSyslog("RRDToolCGI.pl","main",$ConstInfo->getSyslogErr(),"Failed: load Defs");
        display();
        exit;
}
my $grf;
#require GraphOption;
$grf = new NS::GraphOption;

my $opts=$grf->makeGraphOptions($cgi, $mc);


#print $cgi->header(-type=>'image/png', -expires=>'+1m');
if(!$opts)
{
        $Common->writeSyslog("RRDToolCGI.pl","main",$ConstInfo->getSyslogErr(),"Failed: can't get rrd's options");
        display();
        exit;    
}

RRDs::graph(@$opts);
my $err=RRDs::error;  #$err="Can't display graph";
###create Error message image and put stdout### if $err;
if($err)
{
        $Common->writeSyslog("RRDToolCGI.pl","main",$ConstInfo->getSyslogErr(),$err);
        display();
        exit;
}
sub display
        {
        #create a new image
        my $errmessage=shift;
        my $graph = new GD::Image(96,64);
        #my $graph = new GD::Image(496,64);
        #allocate some colors
        my $white = $graph->colorAllocate(255,255,255);
        my $black = $graph->colorAllocate(0,0,0);
        my $red = $graph->colorAllocate(255,0,0);
        my $blue = $graph->colorAllocate(0,0,255);
        my $mycl = $graph->colorAllocate(123,100,255);
        my $unknown= $graph->colorAllocate(0,225,225);
        #  make the background transparent and interlaced
        $graph->transparent($white);
        $graph->interlaced('true');

        # put a black frame   around the picture

        $graph->rectangle(0,0,95,63,$white);
        
        $graph->fill(1,1,$white);
       
        my $str1="Can't";
        my $str2="display";
        my $str3="graph";
        $graph->string(gdGiantFont,10,10,$str1,$red);
        $graph->string(gdGiantFont,10,25,$str2,$red);
        $graph->string(gdGiantFont,10,40,$str3,$red);
        #$graph->char(gdGiantFont,2,30,"!",$red);
        #$graph->string(gdSmallFont,10,40,$errmessage,$red);
        ## the next centence maybe be canceled
        #print "Content-Type: image/png\n\n";
        # make sure we are writing to a binary stream
        binmode STDOUT;
        #Convert the image to PNG and print it to standard output
        print $graph->png;

        }
        
exit;




