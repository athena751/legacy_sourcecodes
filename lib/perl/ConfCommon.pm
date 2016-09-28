#!/usr/bin/perl
#
#       Copyright (c) 2004-2007 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: ConfCommon.pm,v 1.7 2007/02/12 01:09:26 qim Exp $"

package NS::ConfCommon;
use strict;

sub new(){
     my $this = {};     # Create an anonymous hash, and #self points to it.
     bless $this;       # Connect the hash to the package update.
     return $this;      # Return the reference to the hash.
}

#FUNCTION:
#       judge whether the specify key exists in the [<section>] of conf file
#PARAM:
#       $key            key name
#       $section        section name
#                               ex. "global" (express the [global] section)
#       \@content        the content of the conf file
#RETURN:
#       0       doesn't exist
#       1       exist
sub hasKey(){
    my ($self, $key, $section, $content) = @_;
    my $ret = &getKeyValue($self, $key, $section, $content);
    return (defined($ret) ? 1 : 0);
}

#FUNCTION:
#       delete the specify key exists in the [<section>] of conf file
#PARAM:
#       $key            key name
#       $section        section name
#                               ex. "global" (express the [global] section)
#       \@content       the content of the conf file
#RETURN:
#       none
sub deleteKey(){
    my ($self, $key, $section, $content) = @_;
    while(1){
        my ($offset, $value) = &getKeyInfo($self, $key, $section, $content);
        if (defined ($offset)){
            splice (@$content, $offset, 1);
        }else{
            last;
        }
    }
    return;
}

#FUNCTION:
#       get the value of the specify key in the [<section>] of conf file
#PARAM:
#       $key            key name
#       $section        section name
#                               ex. "global" (express the [global] section)
#       \@content        the content of the conf file
#RETURN:
#       the value of the key       
#       undef       the key doesn't exist
sub getKeyValue(){
    my ($self, $key, $section, $content) = @_;
    my ($offset, $value) = &getKeyInfo($self, $key, $section, $content);
    return (defined($offset) ? $value : undef);
}
#FUNCTION:
#       get the value of the specify key in the [<section>] of conf file
#       trim the ["] of the value's anterior and latter 
#PARAM:
#       $key            key name
#       $section        section name
#                               ex. "global" (express the [global] section)
#       \@content        the content of the conf file
#RETURN:
#       the value of the key       
#       undef       the key doesn't exist
sub getKeyValueTrimQuotation(){
    my ($self, $key, $section, $content) = @_;
    my ($offset, $value) = &getKeyInfo($self, $key, $section, $content);
    if(defined($offset)){
    	$value =~ s/^\"*//;
    	$value =~ s/\"*$//;
    	return $value;
    }else{
    	return undef;
    }
}
#FUNCTION:
#       modify the value of the specify key inside [<section>] in conf file
#PARAM:
#       $key            key name
#       $value          the new value of the specify key
#       $section        section name   
#                               ex. "global" (express the [global] section)
#       \@content        the content of the conf file
#RETURN:
#       none
sub setKeyValue(){
    my ($self, $key, $value, $section, $content) = @_;
    my ($offset, $tmpValue) = &getKeyInfo($self, $key, $section, $content);
    if (defined ($offset)){
        splice (@$content, $offset, 1, "${key} = ${value}\n");
    }else{
        my ($sectionOffset, $length) = &getSectionInfo($self, $section, $content);
        if(defined($sectionOffset)){
            splice (@$content, $sectionOffset + $length, 0, "${key} = ${value}\n");
        }else{
            #the section does not exist
            push(@$content, "[$section]\n");
            push(@$content, "${key} = ${value}\n");
        }        
    }
    return;
}
#FUNCTION:
#       modify the value of the specify key inside [<section>] in conf file
#       example: key=value (trim the spaces of two sides of equals sign)
#PARAM:
#       $key            key name
#       $value          the new value of the specify key
#       $section        section name   
#                               ex. "global" (express the [global] section)
#       \@content        the content of the conf file
#RETURN:
#       none
sub setKeyValue2(){
    my ($self, $key, $value, $section, $content) = @_;
    my ($offset, $tmpValue) = &getKeyInfo($self, $key, $section, $content);
    if (defined ($offset)){
        splice (@$content, $offset, 1, "${key}=${value}\n");
    }else{
        my ($sectionOffset, $length) = &getSectionInfo($self, $section, $content);
        if(defined($sectionOffset)){
            splice (@$content, $sectionOffset + $length, 0, "${key}=${value}\n");
        }else{
            #the section does not exist
            push(@$content, "[$section]\n");
            push(@$content, "${key}=${value}\n");
        }        
    }
    return;
}
#FUNCTION:
#       modify the value of the specify key inside [<section>] in conf file
#       example: key=value (trim the spaces of two sides of equals sign)
#       add ["] between front and end of the value.
#       example:key="value"
#PARAM:
#       $key            key name
#       $value          the new value of the specify key
#       $section        section name   
#                               ex. "global" (express the [global] section)
#       \@content        the content of the conf file
#RETURN:
#       none
sub setKeyValueAddQuotation(){
	my ($self, $key, $value, $section, $content) = @_;
    my ($offset, $tmpValue) = &getKeyInfo($self, $key, $section, $content);
    if (defined ($offset)){
        splice (@$content, $offset, 1, "${key} = \"${value}\"\n");
    }else{
        my ($sectionOffset, $length) = &getSectionInfo($self, $section, $content);
        if(defined($sectionOffset)){
            splice (@$content, $sectionOffset + $length, 0, "${key} = \"${value}\"\n");
        }else{
            #the section does not exist
            push(@$content, "[$section]\n");
            push(@$content, "${key} = \"${value}\"\n");
        }        
    }
    return;
}
#FUNCTION:
#       get the index of the specify key in the [<section>] of conf file
#PARAM:
#       $key            key name
#       $section        section name
#                               ex. "global" (express the [global] section)
#       \@content        the content of the conf file
#RETURN:
#       the index of the key
#       -1       the key doesn't exist
sub getKeyIndex(){
    my ($self, $key, $section, $content) = @_;
    my ($offset, $value) = &getKeyInfo($self, $key, $section, $content);
    return (defined($offset) ? $offset : -1);
}

#FUNCTION:
#       judge whether the specify [<section>] in the conf file
#PARAM:
#       $section        section name
#                               ex. "global" (express the [global] section)
#       \@content        the content of the conf file
#RETURN:
#       0       doesn't exist
#       1       exist
sub hasSection(){
    my ($self, $section, $content) = @_;
    my ($offset, $length) = &getSectionInfo($self, $section, $content);
    defined($offset) ? return 1 : return 0;
}

#FUNCTION:
#       delete the specify [<section>] in the conf file
#PARAM:
#       $section        section name
#                               ex. "global" (express the [global] section)
#       \@content        the content of the conf file
#RETURN:
#       none
sub deleteSection(){
    my ($self, $section, $content) = @_;
    while(1){
        my ($offset, $length) = &getSectionInfo($self, $section, $content);
        defined($offset) or last;
        splice (@$content, $offset - 1, $length + 1);
    }
    return;
}

#FUNCTION:
#       get the value of the specify [<section>] in conf file
#PARAM:
#       $section        section name   
#                               ex. "global" (express the [realms] section)
#       \@content       the content of the conf file
#RETURN:
#       \@retContent    the modified content of the conf file
#       undef           when the key doesn't exist
sub getSectionValue(){
    my ($self, $section, $content) = @_;
    my ($offset, $length) = &getSectionInfo($self, $section, $content);
    defined($offset) or return undef;
    my @retContent = @$content[$offset..$offset+$length-1];
    return \@retContent;
}

#FUNCTION:
#       modify the value of the specify [<section>] in conf file
#PARAM:
#       \@value          the new value of the specify section
#       $section        section name   
#                               ex. "global" (express the [realms] section)
#       \@content        the content of the conf file
#RETURN:
#       none
sub setSectionValue(){
    my ($self, $value, $section, $content) = @_;
    my ($offset, $length) = &getSectionInfo($self, $section, $content);
    if (!defined($offset)){
        push(@$content,"[$section]\n");
        push(@$content,@$value);
    }else{
        splice (@$content,$offset,$length,@$value);
    }
    return;
}

#FUNCTION:
#       get offset and value of the key in [<section>]'s content
#PARAM:
#       $key            key name
#       $section        section name   
#                           ex. "global" (express the [realms] section)
#       \@content       the content of the conf file
#RETURN:
#       $offset         the index of [<section>]'s content
#                           ex. if the first line is [<section>] ,the $offset is 1.
#       $value          the line count of [<section>]'s content
#       undef           when the key doesn't exist
sub getKeyInfo(){
    my ($self, $key, $section, $content) = @_;
    my ($offset, $length) = &getSectionInfo($self, $section, $content);
    defined($offset) or return undef;
    my $sectionValue = &getSectionValue($self, $section, $content);
    $key =~ s/\s+//g;
    my $index = 0;
    my $retIndex;
    my $retValue;
    foreach my $line(@$sectionValue){
        if($line =~ /^([^=]+)=(.*)$/i){
            my $curKey = $1;
            my $curValue = $2;
            $curKey =~ s/\s+//g;
            if ($key =~ /^\Q${curKey}\E$/i){
                $retIndex = $index;
                $retValue = &trim($curValue);
            }
        }
        $index++;
    }
    defined($retIndex) or return undef;
    return($offset + $retIndex, $retValue);
}

#FUNCTION:
#       get offset and length of the [<section>]'s content
#PARAM:
#       $section        section name   
#                           ex. "global" (express the [realms] section)
#       \@content        the content of the conf file
#RETURN:
#       $offset         the index of [<section>]'s content
#                           ex. if the first line is [<section>] ,the $offset is 1.
#       $length         the line count of [<section>]'s content
#       undef           when the [<section>] doesn't exist
sub getSectionInfo(){
    my ($self, $section, $content) = @_;
    my $offset;
    my $length = 0;
    my $startCount = 0;
    my $index = 0;
    foreach my $line (@$content){
        if ($line =~ /^\s*\[(.*)\]\s*$/i ) {
            my $tmpSection = &trim($1);
            if ($tmpSection =~ /^\Q${section}\E$/i) {
                $length = 0;
                $startCount = 1;
                $offset = $index + 1;
            }else{
                $startCount = 0;
            }
        }else{
            if ($startCount) {
                $length++;
            }
        }
        $index++;
    }
    if (!defined($offset)) {
        return undef;
    }
    return ($offset, $length);
}

#FUNCTION:
#       get all section name form the conf content
#PARAM:
#       \@content        the content of the conf file
#RETURN:
#       \@sectionList    the content of the conf file
sub getSectionList(){
    my ($self, $content) = @_;
    my @shareList = ();
    foreach my $line (@$content){
        if ($line =~ /^\s*\[(.*)\]\s*$/i ) {
            my $section = &trim($1);
            grep(/^\Q${section}\E$/i, @shareList) or push(@shareList, $section);
        }
    }
    return \@shareList;
}

sub trim(){
    my $str=shift;
    $str =~ s/^\s+|\s+$//g;
    return $str;
}

1;