#!/usr/bin/perl
#      copyright (c) 2005-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#       DengYunPeng 2005/06/21
# "@(#) $Id: nic_setroute.pl,v 1.4 2007/08/24 01:44:48 fengmh Exp $"

use strict;
use NS::NicCommon;

my $param;

#define the routes to be set
my @sets;

#define the  existing routes
my @content;
if(scalar(@ARGV) != 1){
	exit 1;
}
$param = shift;

my $nic_common = new NS::NicCommon;

#get all the existing routes except default route
my $route = $nic_common->getRoute("-l");
if(!defined($route)){
		exit 1;
}
@content = @$route;

#get the @sets from spliting the $param
if($param =~ /\,/){
   @sets=split(",",$param);
}
else{
     @sets=($param);
}

chomp(@content);
chomp(@sets);

my @delResult;

my $deleteAll = 0;
if($param !~ /\S+/){
    $deleteAll = 1;             
}

#delete all the routes which are found in @content but not found in @sets
#if delete failed, then print the failed route
foreach (@content){
    my $ifConf = $_;
 		my $isDel = 1;
		foreach (@sets){
			 if($ifConf eq $_){
			 		$isDel = 0;
			 		last;
			 }
		}
		if($isDel == 1 || $deleteAll == 1){
			 my $target = "";
			 my $gw = "";
			 my $dev = "";
			 if($ifConf =~ /^\s*(\S+)\s+(\S+)\s+(\S+)\s*$/	){
			 		$target = $1;
			 		$gw = $2;
			 		$dev = $3;
			 }
			 if($target eq "" || $gw eq "" || $dev eq ""){
			 		next;
			 }
			 my $result = $nic_common->delRoute($target,$gw,$dev); 
			 if($result != 0){
			 		push(@delResult,"$ifConf#$result\n");			 		
			 }		
		}
}

my @addResult;
#add all the routes which are found in @sets but not found in @content
#if add failed, then print the failed route
foreach (@sets){
    my $ifConf = $_;
 		my $isAdd = 1;
		foreach (@content){
			 if($ifConf eq $_){
			 		$isAdd = 0;
			 		last;
			 }
		}
		if($isAdd == 1){
			 my $target = "";
			 my $gw = "";
			 my $dev = "";
			 if($ifConf =~ /^\s*(\S+)\s+(\S+)\s+(\S+)\s*$/	){
			 		$target = $1;
			 		$gw = $2;
			 		$dev = $3;
			 }
			 if($target eq "" || $gw eq "" || $dev eq ""){
			 		next;
			 }
			 my $result = $nic_common->addRoute($target,$gw,$dev); 
			 if($result != 0){
			 		push(@addResult,"$ifConf#$result\n");
			 }		
		}
}

#print the operation error
my @printResult;
if(scalar(@addResult) > 0){
		push(@printResult,"(A)\n",@addResult);
}
if(scalar(@delResult) > 0){
		push(@printResult,"(D)\n",@delResult);
}
if(scalar(@printResult) > 0){
		print @printResult;
}
exit 0;
