#!/usr/bin/perl 
#
#       Copyright (c) 2001-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: ExportgroupFun.pm,v 1.3 2007/06/28 01:28:31 zhangjx Exp $"

package NS::ExportgroupFun;
use strict;
use NS::ExportgroupConst;

my $const = new NS::ExportgroupConst();

sub new() {
    my $this = {};    # Create an anonymous hash, and #self points to it.
    bless $this;      # Connect the hash to the package update.
    return $this;     # Return the reference to the hash.
}

# Function: get the exportroot and codepage from file /etc/group[0|1]/exgrps.
# Parameter: etcPath such as "/etc/group0/"
# Return: if normal,return the refer of hash array:(key:exportgroup  value:codepage)
#         if error, undef
sub getExportGroupInfo(){
    ### 1.check parameters
    my $self = shift;
    if (@_!=1){
        return undef;
    }
    ### 2.get the given parameters and create file name;
    my $etcPath     = shift;
    my $confFile    = "${etcPath}expgrps";
    my @confContent;
    my %result;
    ### 3.file not exist, return empty hash
    if(!(-f $confFile)){
        return \%result;    
    }
    ### 4.open file and get the content
    if(open(CONF,$confFile)){
        @confContent = <CONF>;
        close(CONF);
    }else{
        return undef;
    }
    ### 5.loop for the content and then return values
    foreach (@confContent) {
    	if(/^\s*#/ || /^\s*$/){
            next;
        }
        if(/^\s*(\S+)\s+(\S+)\s*$/){
	    if($2 eq $const->STRING_LOWERCASE_EUC_JP){
		$result{$1} = $const->STRING_UPPERCASE_EUC_JP;
            }elsif($2 eq $const->STRING_LOWERCASE_SJIS){
		$result{$1} = $const->STRING_UPPERCASE_SJIS;
            }elsif($2 eq $const->STRING_ISO8859){
  		$result{$1} = $const->STRING_ENGLISH;
  	    }elsif($2 eq $const->STRING_LOWERCASE_UTF){
  		$result{$1} = $const->STRING_UPPERCASE_UTF;
  	    }elsif($2 eq $const->STRING_LOWERCASE_UTF_NFC){
  		$result{$1} = $const->STRING_UPPERCASE_UTF_NFC;
  	    }
        }
    }
    return \%result;
}   


# Function: convert the upper codepage to the lower
# Parameter: the upper codepage
# Return: the lower codepage
sub getStandardCodePage(){
    my $self = shift;
    my $tempCode = shift;
    if($tempCode eq $const->STRING_ENGLISH){
        return $const->STRING_ISO8859;
    }elsif($tempCode eq $const->STRING_UPPERCASE_EUC_JP){
        return $const->STRING_LOWERCASE_EUC_JP;
    }elsif($tempCode eq $const->STRING_UPPERCASE_SJIS){
        return $const->STRING_LOWERCASE_SJIS;
    }elsif($tempCode eq $const->STRING_UPPERCASE_UTF){
        return $const->STRING_LOWERCASE_UTF;
    }elsif($tempCode eq $const->STRING_UPPERCASE_UTF_NFC){
        return $const->STRING_LOWERCASE_UTF_NFC;
    }else{
        return $tempCode;
    }
}

# Function: get the path of exportgroup's config file
# Parameter: groupNo [0|1]
# Return: the path of exportgroup's config file
sub getFileName(){
    my $self = shift;
    my $groupNo = shift;
    return "/etc/group${groupNo}/expgrps";    
}

# Function: check mounted status in the exportroot
# Parameter: exportRoot: exportgroup path,such as "/export/nasgroup"
#            cfstab: cfstab file name, such as "/etc/group0/cfstab"
# Return: if mounted, return "true"
#         if not, return "false"
sub checkMounted(){
    ### 1.check whether parameters from command line is valid
    my $self = shift;
    if(scalar(@_)!=2){
        return undef;
    }

    my $exportRoot = shift;
    my $cfstab = shift;
    foreach (@$cfstab){
        if(/^\s*#.*/){
            next;
        }elsif($_=~m"\s${exportRoot}/"){
            return "true";
        }
    }
    return "false";
}

#   Function: check if a exportgroup's existed sxfsfw/sxfs domain.
#   parameters:
#              exportgroup --------------- exportgroup Name   eg--"/export/xxx"
#              alldomain     --------------- ims_domain command result 
#   Return value:
#              true , if domain existed
#              false , if not existed
sub checkUserDB(){
    my $self = shift;
    my $exportgroup = shift;
    my $alldomain = shift;
    my $result  = "false";
    my $exportshort = $exportgroup;
    if($exportgroup =~ /^\/export\//){
        $exportshort = (split("/",$exportgroup))[2];
    }
    #Step1: when type="sxfsfw"(windows domain),first get ntdomain and netbios.
    
    foreach(@$alldomain){
        if (/^\s*\w\w\w:$exportshort\-\d+\s+/){
            $result = "true"; 
            last;   
        }
    }
    
    return $result;
}

1;
