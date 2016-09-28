#!/usr/bin/perl
#
#      Copyright (c) 2006-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# "@(#) $Id: event_report.pl,v 1.3 2007/08/14 09:23:46 chenbc Exp $"
#
#Function:
#   Fetch the information from eventlog and EventResource, and merge them
#Parameters:
#   -f filename  --  specify the eventlog file, the default is /var/log/eventlog/eventlog
#   -o filename  --  the user gives a output file, the default value is STDOUT
#   -e [ja|en]   --  user select a language, the default value is according to current system
#Output:
#   The user-given file
#
#exit code:
#   0 -- successful
#   1 -- failure

use strict;
use NS::EventCommon;
use Encode;
binmode STDOUT, ":encoding(sjis)";

my ($lang, $ofile, $ifile, $selfName);
($selfName) = $0 =~/^.*\/(.*?)$/;
my @args = @ARGV;
my $usage = "Usage: $selfName [-f <FILE>] [-o <FILE>] [-e <ja|en>]\n".
            "Options:\n".
            "-f <FILE>  Specify the event log file to analyze.\n".
            "           The default is /var/log/eventlog/eventlog.\n".
            "-o <FILE>  Place the output into <FILE>.\n".
            "           Only alphanumeric characters, \"_\", \"-\", and \".\" are allowed.\n".
            "           The default is STDOUT.\n".
            "-e <ja|en> Specify the language in which the event report is generated.\n".
            "   -e ja   Generate the event report in Japanese.\n".
            "   -e en   Generate the event report in English.\n".
            "           The default language is given according to the GUI version.\n";
my $nsCmn = new NS::EventCommon;

use constant TIME_POS  => 0; # which column the time information stands in in eventlog
use constant ID_POS    => 1; # which column the id information stands in in eventlog
use constant LEVEL_POS => 2; # which column the level information stands in in eventlog
use constant COMP_POS  => 3; # which column the component information stands in in eventlog
use constant MAIL_POS  => 4; # which column the mail information stands in in eventlog
use constant SNMP_POS  => 5; # which column the SNMP information stands in in eventlog

### Check the arguments

## Parse the options
for(my $i = 0; $i < scalar(@args); ++$i){
    my $curArg = $args[$i];
    if(length($curArg) >= 2 && substr($curArg, 0, 1) eq '-'){ # distinguish an option
        # for the option '-o'
        if(substr($curArg, 1, 1) eq 'o'){
            &mydie(__FILE__, __LINE__, "$selfName: option -o has been already set") if(defined $ofile);
            # get the option arguments
            if(length($curArg) >2){
                $ofile = substr($curArg, 2);
            }else{
                $ofile = $args[++$i];
                if(not defined $ofile){
                    print STDERR "$usage\n";
                    exit 1;
                }
            }
        }
        # for the option '-e'
        elsif(substr($curArg, 1, 1) eq 'e'){
            &mydie(__FILE__, __LINE__, "$selfName: option -e has been already set") if(defined $lang);
            if(length($curArg) >2){
                $lang = substr($curArg, 2);
            }else{
                $lang = $args[++$i];
                if(not defined $lang){
                    print STDERR "$usage\n";
                    exit 1;
                }
            }
        }
        # for the option '-f'
        elsif(substr($curArg, 1, 1) eq 'f'){
            &mydie(__FILE__, __LINE__, "$selfName: option -f has been already set") if(defined $ifile);
            if(length($curArg) >2){
                $ifile = substr($curArg, 2);
            }else{
                $ifile = $args[++$i];
                if(not defined $ifile){
                    print STDERR "$usage\n";
                    exit 1;
                }
            }
        }else{
            print STDERR "$usage\n";
            exit 1;
        }
    }else{
        print STDERR "$usage\n";
        exit 1;
    }
}# end for

## Check the language
if(defined $lang){
    if($lang ne $nsCmn->JA && $lang ne $nsCmn->EN){
        print STDERR "$usage\n";
        exit 1;
    }
}else{
    # get the default language
    my $cmd = $nsCmn->GET_VER_INF;
    my $language = `$cmd`;
    chomp($language);
    if($language eq 'japan'){
        $lang = $nsCmn->JA;
    }else{
        $lang = $nsCmn->EN;
    }
}

## check the output filename

if((defined $ofile)){
    trim($ofile);
    my ($name) = $ofile =~/^.*\/(.*?)$/;
    if(not defined $name){
        $name = $ofile;
    }
    if(length($name) > 255){
        &mydie(__FILE__, __LINE__, "File name too long");
    }
    if(not $name =~/^[\-\.\w]*$/){
        warn "Invalid filename: ${ofile}\n$usage\n";
        exit 1;
    }
}

## check the eventlog filename
if(defined $ifile){
    &mydie(__FILE__, __LINE__, "Cannot find file ${ifile} or ${ifile}.1") if((not -f $ifile) and (not -f $ifile.'.1'));
}else{
    $ifile = $nsCmn->EVENT_LOG;
    $nsCmn->lockwait($nsCmn->EVENT_LOCK);
    system($nsCmn->EVENT_COLLECT);
}

### Handle the resource file
my %rsrcMap; # a resource map that is from keys to messages
my $rsrcFile = $nsCmn->RSRC_FILE.$lang;
{
    open(RFILE, $rsrcFile) or &mydie(__FILE__, __LINE__, "Failed to open ${rsrcFile}");

    while(<RFILE>){
        my ($curItem, $key, $keyType, $value);
        $curItem = $_;
        next if $curItem =~/^#/; # omit the comments
        next if $curItem =~/^\s*$/; # omit the blank lines
        chomp($curItem); # chop the newline characters
        # get the key, type and value
        # i.e. There is such a item : C0010002.content=Battery failure
        # then, key=C0010002, type=content, value=Battery failure
        Encode::_utf8_on($curItem);
        ($key, $value) = $curItem =~/^(.*?)=(.*)$/;
        next if(not defined $key);
        ($key, $keyType) = $key =~/^(.*?)\.(.*)$/;
        next if(not defined $keyType);
        if($key ne $nsCmn->COMPONENT and $key ne $nsCmn->LEVEL){
            $value =~s/\"/\"\"/g;
            $value = '"'.$value.'"'; # add double quotation marks according to the CSV grammar
        }
        # store the informations
        if($rsrcMap{$key}){
            $rsrcMap{$key}->{$keyType} = $value;
        }else{
            my %temp = ($keyType => $value);
            $rsrcMap{$key} = \%temp;
        }
    }# end while
    close(RFILE);
}

### Handle the eventlog

my %findKey = ('error' => 'error', 'warning' => 'warn', 'information' => 'info');
if(defined $ofile){
    &mydie(__FILE__, __LINE__, "$selfName: $ofile: Is a directory") if(-d $ofile);
    system("touch \"$ofile\" 2> /dev/null") and &mydie(__FILE__, __LINE__, "$selfName: $ofile: No such directory");
    open(STDOUT, ">$ofile") or &mydie(__FILE__, __LINE__, "$selfName: failed to open file $ofile");
    # Redirect STDOUT to file
}
open(EFILE, "/bin/cat ${ifile}.1 ${ifile} 2> /dev/null |");

# add form tags
{
    &mydie(__FILE__, __LINE__, "$selfName: cannot get the form tags") if not defined $rsrcMap{$nsCmn->FORMTAG};
    my %formTags = %{$rsrcMap{$nsCmn->FORMTAG}};
    my $tag = $formTags{$nsCmn->TIME}.','.
              $formTags{$nsCmn->ID}.','.
              $formTags{$nsCmn->LEVEL}.','.
              $formTags{$nsCmn->COMPONENT}.','.
              $formTags{$nsCmn->CONTENT}.','.
              $formTags{$nsCmn->MAIL}.','.
              $formTags{$nsCmn->SNMP}.','.
              $formTags{$nsCmn->DETAIL}.','.
              $formTags{$nsCmn->DEAL}."\n";
    print $tag;
}
while(<EFILE>){
    my $log = $_;
    next if $log =~/^\s*$/; # omit the blanklines
    chomp($log); # chop the newline characters
    $log =~s/\t//g; # delete the tab characters
    my @words = split(/,/, $log); # split current line into words by comma
    my $id = $words[&ID_POS]; # fetch the id
    &mydie(__FILE__, __LINE__, "$selfName: no such id: $id") if not defined $rsrcMap{$id}; # if no such id, error
    my %curMsg = %{$rsrcMap{$id}}; # fetch the information about current id
    &mydie(__FILE__, __LINE__, "$selfName: no such level: ${words[&LEVEL_POS]}") if not defined $findKey{$words[&LEVEL_POS]};
    my $curLevelKey = $findKey{$words[&LEVEL_POS]};
    my $curModule = $words[&COMP_POS];

    my $line = '"'.$words[&TIME_POS].'",'.
               '"'.$id.'",'.
               '"'.$rsrcMap{$nsCmn->LEVEL}->{$curLevelKey}.'",'.
               '"'.$rsrcMap{$nsCmn->COMPONENT}->{$curModule}.'",'.
               $curMsg{$nsCmn->CONTENT}.','.
               '"'.$words[&MAIL_POS].'",'.
               '"'.$words[&SNMP_POS].'",'.
               $curMsg{$nsCmn->DETAIL}.','.
               $curMsg{$nsCmn->DEAL}."\n"; # merge
    print $line;
}# end while
close(EFILE);
close(STDOUT);

exit 0;

sub mydie{
    my ($file, $line, $errorMsg) = @_;
    print STDERR $errorMsg.".\nExit in perl script:", $file, " line:", $line, ".\n";
    close(RFILE);
    close(EFILE);
    close(STDOUT);
    exit(1);
}

sub trim{
    my $string = shift @_;
    $string =~s/^\s+//;
    $string =~s/\s+$//;
    return $string;
}
