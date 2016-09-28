#!/usr/bin/perl -w
#
#       Copyright (c) 2001-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#


# "@(#) $Id: CIFSCommon.pm,v 1.2329 2008/05/19 06:46:35 fengmh Exp $"


package NS::CIFSCommon;

use strict;
use NS::NicCommon;
use NS::SystemFileCVS;
use NS::CodeConvert;
use NS::NFSCommon;
use NS::NsguiCommon;
no utf8;

my $comm = new NS::NsguiCommon;
my $cvs= new NS::SystemFileCVS;
my @japaneseKey=("path");
my $smbFile="smb.conf";
my $global="global";
my $defaultPath="nas_cifs/";#lhy add for "cluster" at 2002/5/28
my $fixedKey="irrevocable\\s*options";
my @commentKey=("#",";");
my $defPathPattern="nas_cifs";
my $configFile="configfile";
my $virtualServer="virtualservers";
my $specialKey="password\\s*server";
my $globalPath = "DEFAULT"; # liuyun add this at 6/7
my $smbName = "smb.conf";
my $vsName = "virtual_servers";
my $cmd_syncwrite_o = $cvs->COMMAND_NSGUI_SYNCWRITE_O;
my $cmd_syncwrite_a = $cvs->COMMAND_NSGUI_SYNCWRITE_A;
sub new(){
     my $this = {}; # Create an anonymous hash, and #self points to it.
     bless $this; # Connect the hash to the package update.
     return $this; # Return the reference to the hash.
}

sub getSmbOrVsName(){
    #Function: get full file name or path of 3!)smb.conf or vs.conf
    #Paramete:etcPath globalDomain localDomain NetBios pathFlag:1 only directory;0:full name of of 3!)smb.conf or vs.conf
    #Return value:succed: full file name of 3!)smb.conf(when 4 parameters) or vs.conf(2 parameters)  failed:undef
    #Process:
    #check parameters
    my $self=shift;
    my $length=@_;
    if($length!=5&&$length!=3){
        return undef;
    }
    my ($etcPath,$globalDomain,$localDomain,$NetBios,$pathFlag);
    if($length==3){
        ($etcPath,$globalDomain,$pathFlag)=@_;
        if ($pathFlag == 0) {
            return $etcPath . $defaultPath . $globalPath . "/" . $vsName;
        }
        else {
            return $etcPath . $defaultPath . $globalPath;
        }
    }else{
        ($etcPath,$globalDomain,$localDomain,$NetBios,$pathFlag)=@_;

        if ($pathFlag == 0) {
            return $etcPath . $defaultPath . $globalPath . "/" . $localDomain . "/smb.conf." . $NetBios;
        }
        else {
            return $etcPath . $defaultPath . $globalPath . "/" . $localDomain;
        }

    }

}

sub getSecondSMBName(){
    #Function: get full file name of 2!)smb.conf or path
    #Paramete:globalDomain flag(0:filename 1 path)
    #Return value:succed: full file name or path of 2!)smb.conf       failed:undef
    #Process:
    #1.check whether parameters from command line is valid
    my $self=shift;
    if(scalar(@_)!=3){#lhy add for "cluster" at 2002/5/28
        return undef;
    }

    my ($etcPath,$globalDomain,$pathFlag)=@_;#lhy add for "cluster" at 2002/5/28

    if ($pathFlag == 0) {
        return $etcPath . $defaultPath . $globalPath . "/" . $smbName;
    }
    if ($pathFlag == 1) {
        return $etcPath . $defaultPath . $globalPath;
    }
    else {
        return undef;
    }

}
sub makeSpecialStr(){
    #Function: make str by replacing some chars with specified str
    #Paramete:str separator last(sign that whether only get last element of array getting by split str) old1 new1 old2 new2 ....
    #return value:succed:if parameters is 3,then return spilted string array;else reurn replaced str               failed:undef
    #Process:
    #check parameters:if length is less than 3,return undef
    my $selft=shift;
    my $len=@_;
    if($len<3){
        return undef;
    }
    my $str=shift;
    my $separator=shift;
    my $last=shift;
    my @change=();
    if($len>3){
        @change=@_;
    }
    #delete space at begin and at end
    my @ret=split(/\s+/,$str);
    if(scalar(@ret)>0){
        if($ret[0]=~/^\s*$/){
            shift(@ret);
        }
    }
    $str=join(" ",@ret);
    #split string with separator
    @ret=split(/$separator/,$str);
    #replace one with another in string
    if($len>3){
        my $i;
        my $len1=@change;
        for($i=0;$i<$len1;$i=$i+2){
            $str=~s/$change[$i]/$change[$i+1]/;
            if($len<$i+2){
                last;
            }
        }
    }
    #if last is 0,return new string,else return value after the separator of string
    if($last==0){
        return \@ret;
    }else{
        my $len=@ret;
        return $ret[$len-1];
    }
}

sub makeDir(){
    #Function: make dir
    #Paramete:dir
    #Return value:succed:return 0           failed:return 1
    #Process:
    shift;
    if(scalar(@_)!=1){
        return 1;
    }
    my $dir=shift;

    if (system("mkdir -p $dir")) {
        print STDERR "Can't mkdir $dir. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        return 1;
    }
    return 0;
}

sub deleteSameItem(){
    #function:delete same items(only remain last one)
    #parameters:str(array)
    #return value:ref of array(haveing beed dealed with)
    my $self=shift;
    my $i=0;
    my @ret=();
    my @str=@_; 
    while($i<scalar(@str)){
        if($str[$i] =~ /^\s*#/){
            push(@ret,$str[$i]);
            $i++;
            next;
        }
        my @key=();
        #get key of this line
        @key=getKeyValueOfLine($self,$str[$i],"=");
        #if format of this line isn't (a=b),add it to result
        if(!$key[0]){
            push(@ret,$str[$i]);
            splice(@str,$i,1);      
            next;
        }
        my $ref=undef;
        #get the last one which has key as $key[0],and add it to result,set the string array from which lines including key as $key[0] have been deleted to @_
        (@key)=getKeyLine($self,$key[0],@str);
        if(!$key[0]){
            $i++;
            next;
        }
        push(@ret,$key[0]);
        $ref=$key[1];
        @str=@$ref;     
    }
    return \@ret;
}

sub addSpaceInKey(){
    #Function:add space among all char of key
    #Parameters:
        #key----key needing proceed
    #Return:
        #key----key having been proceed
    shift;
    my $key = shift;    
    my @arr = split(/\s+/,$key);
    if(scalar(@arr)>0){
        $key = $arr[0];
        for(my $i = 1; $i<scalar(@arr);$i++){
                $key=join("",($key,"\\s*",$arr[$i]));
        }
    }
    return $key;
}

sub getKeyLine(){
    #Function: get element that include "key"---if exist,delete it from str and return the element and str
    #Parameter:
        #key---which is be searched
        #str---in which key is be searched
    #Returns:
        #undef---- if failed
        #line including key,str from which elements including key have been deleted----if succeed
    #Process
    my $self=shift;
    if(scalar(@_)<2){
        return ();
    }
    my $key=shift;
    $key = &addSpaceInKey($self,$key);
    my @str=@_;   
    my $ret=undef; #the last line in then string array which include the key
    my @strRet=(); #string array which doesn't include elements including key
    foreach my $line(@str){       
        if($line=~/^\s*$key\s*=.*$/i){
            $ret=$line;
            next;
        }      
        push(@strRet,$line);
    }
    return ($ret,\@strRet);
}

sub getSpecialKey(){
     return $specialKey;
}

sub getOption(){
    #Function: return option
    #Parameter: contentRef(of array @content) keySpecialRef(of array that in keyChangeable parts of which is needed yet) keyChangeable(like global or share name) keyFixed(key like "irrevocable options)
    #Return value:0:succed 1:failed
    #Process
    my $self=shift;
    my $len=@_;
    if($len!=4){
        return undef;
    }
    my ($contentRef,$keySpecialRef,$keyChangeable,$keyFixed)=@_;
    my @content=@$contentRef; #string array which is content of file(passed from perl script)
    my @keySpecial=@$keySpecialRef;#key that need special dealing (now,it is useless)
    my $flag=0;
    my @result=();#string array which include all lines needing to return
    my $line;
    my $japaneseKey=getJapaneseKey();
    my $codeConvert=new NS::CodeConvert;
    foreach $line(@content){
        if($line=~/^\s*$/){
            next;
        }
        if($flag==0){         
            if($line =~ /^\s*\[\s*(.*[^\s]+)\s*\]\s*$/i){
                if($1 eq $keyChangeable){
                    $flag = 1;
                }
            }        
            next;
        }
        if($flag==1){
            if($line=~/^\s*\[.*$/){
                last;
            }else{
                my ($key,$value)=getKeyValueOfLine($self,$line,"=",);
                if(!$key){
                    push(@result,$line);
                    next;
                }
                my $keyTmp;
                foreach $keyTmp(@$japaneseKey){
                    if($key eq $keyTmp){
                        $value=$codeConvert->str2hex($value);
                        if(!$value){
                            next OUTER;
                        }
                        $line=join(" = ",($key,$value));
                        last;
                    }
                }
                push(@result,$line);
            }
        }
    }
    if($flag==0){
        my $tempGlobal = getGlobal();
        if ($keyChangeable eq $tempGlobal) {
            return 0;
        }
        return undef;
    }
    return \@result;
}

sub getKeyValueOfLine(){
    #Function: return value,key which not include " "
    #Parameter:str,separator
    #return value:array of key and value(having been trimed):succed     failed:(not be separated into two parts or value[right part] is ""):undef
    #Process
    my $self=shift;
    if(scalar(@_)!=2){
        return undef;
    }
    my ($str,$separator)=@_;
    if(!$str){
        return undef;
    }
    if(!$separator){
        $separator="";
    }
    my @arr=split(/$separator/,$str);
    if($arr[1]=~/^\s*$/){
        return undef;
    }
    my $key = $arr[0];
    if($str =~ /^\s*${key}\s*${separator}\s*(.+)\s*$/){
        $key=trim($self,$key);
        return ($key,$1);
    }
    return undef;
}

sub trim(){
    #function:trim space at begin and at end
    #parameter str separator(when this parameter is passed,space of key(left part of separator) is deleted
    #return value:success:str having been trimed    failed:undef
    shift;
    if(scalar(@_)!=1&&scalar(@_)!=2){
        return undef;
    }
    my $str=$_[0];
    if(!$str){
        return undef;
    }
    my @arr=split(/\s+/,$str);
    if($arr[0]=~/^\s*$/){
        shift(@arr);
    }
    $str=join(" ",@arr);
    if(scalar(@_)==2){
        my $separator=$_[1];
         @arr=split(/$separator/,$str);
         if(scalar(@arr)>1){
             my @arr1=split(/\s+/,$arr[0]);
             $arr[0]=join("",@arr1);
             $str=join($separator,@arr);
         }else{
             my $pos=index($str,"=",0);
            if($pos+1==length($str)){
                @arr=split(/\s+/,$str);
                $str=join("",@arr);
            }
        }
    }
    return $str;
}
sub isCommentLine(){
    #function:judge str whether is comment
    #parameters:str(need to judge it whether is a comment)
    #return value:1:it is a comment  0:it isn't a comment
    shift;
    my $line=shift;
    my @comments=getCommentKey();
    my $comment;
    foreach $comment(@comments){
        if($line=~/^\s*${comment}.*$/){
            return 1;
        }
    }
    return 0;
}

sub getUnchanedOption(){
    #Function: return options that can't be changed
    #Parameter:1:return all   0:return that can be modified in GUI
    #Return value:ref of array Options
    #Process
    shift;
    if(scalar(@_)!=1){
        return undef;
    }
    my $flag=$_[0];
    if($flag==1){#Ver1.2 unchangedable option
        my @options=("security","workgroup","include","config\\s*file","coding\\s*system","password\\s*server","smb\\s*passwd\\s*file","netbios\\s*name","#user\\s*database\\s*type","nt\\s*acl\\s*support","pam\\s*service\\s*name","sid\\s*machine\\s*prefix","realm");
        return \@options;
    }elsif($flag==2){#Ver1.3 unchangedable option
        my @options=("security","workgroup","include","config\\s*file","unix\\s*charset","password\\s*server","smb\\s*passwd\\s*file","netbios\\s*name","#user\\s*database\\s*type","nt\\s*acl\\s*support","pam\\s*service\\s*name","sid\\s*machine\\s*prefix","realm");
        return \@options;
    }else{
        my @options=("security","password\\s*server");
        return \@options;
    }
}

sub deleteItemsNoValue(){
    #function:delete elements that have no value:like "key="
    #parameters:str(array) in which same items should be deleted(only remain the last one)
    #return value:return result(array)
    shift;
    my $line;
    my @str=();
    foreach $line(@_){
        if($line!~/^[^=]*=\s*$/ || $line =~ /^\s*#/){
            push(@str,$line);
        }
    }
    return \@str;
}

sub getShareUser(){
    shift;
    my $filename = shift;
    if (!open(FILE,"$filename")) {
        print STDERR "Open $filename failed. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        return 1;
    }
    my @content = <FILE>;
    close(FILE);

    my $username;
    my $temp;
    if($content[0]=~/\s*\#\s*share(\d+)/){
        $temp = $1 + 1;
        $username = "share" . $temp;
        $content[0] = "\#".$username."\n";
    }else {
        $temp = 000000001;
        $username = "share".$temp;
        splice(@content, 0, 0, "\#".$username."\n");
    }

    if (!open(FILE,"|${cmd_syncwrite_o} ${filename}")) {
        print STDERR "Open $filename failed. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        return 1;
    }
    print FILE @content;
    if(!close(FILE)) {
     print STDERR "The $filename can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
     return 1;
	}
    
    return $username;
}

sub getShareName(){
    shift;
    my $line=shift;
    my $pos1=index($line,"[");
    my $pos2=index($line,"]");
    $line=substr($line,$pos1+1,$pos2-$pos1-1);
    my @arr=split(/\s+/,$line);
    if(scalar(@arr)>0&&$arr[0]=~/^\s*$/){
         shift(@arr);
    }
    join("",@arr);
}

sub str2RegStr(){
#  change "." to "\." for Reg
    shift;
    my $str = shift;
    $str =~ s/\./\\./g;
    return $str;
}


sub getSmbFile(){
    return $smbFile;
}
sub getGlobal(){
    return $global;
}
sub getDefaultPath(){
    return $defaultPath;
}
sub getFixedKey(){
    return $fixedKey;
}
sub getCommentKey(){
    return @commentKey;
}
sub getConfigFile(){
    return $configFile;
}
sub getVirtualServer(){
    return $virtualServer;
}

sub getJapaneseKey(){
    return \@japaneseKey;
}

sub winbindEtcIndirect{
    #Function:if curLine include "winbind ....",then delete them from param,
               #and replace curLine with correpond line in param if it can modified by user
    #Parameters:
        #curLine---current line to be modified
        #param---reference of param
        #winbindEtcUserNoMod---reference of array
        #winbindEtcUserCanMod---reference of array 
    #Return:
        #curLine---having been modified if needing
        #isWinbindEtc---
    #Process:
    my $self = shift;
    my ($curLine,$param,$winbindEtcUserNoMod,$winbindEtcUserCanMod) = @_;     
    my @winbindEtcUserNoMod = @$winbindEtcUserNoMod;
    my @winbindEtcUserCanMod = @$winbindEtcUserCanMod;
    my $isWinbindEtc = 0; 
    foreach my $key(@winbindEtcUserNoMod){
        my $keyPattern = &addSpaceInKey($self,$key);
        if($curLine =~ /^\s*${keyPattern}\s*=.*$/i){
            my ($keyLine,$refParam) = &getKeyLine($self,$key,@$param);
            @$param = @$refParam;
            $isWinbindEtc = 1;
            return ($curLine,$isWinbindEtc);
        }
    }
    foreach my $key(@winbindEtcUserCanMod){
        my $keyPattern = &addSpaceInKey($self,$key);
        if($curLine =~ /^\s*${keyPattern}\s*=.*$/i){
            my ($keyLine,$refParam) = &getKeyLine($self,$key,@$param);
            @$param = @$refParam;
            $isWinbindEtc = 1;
            return ($keyLine,$isWinbindEtc);
        }
    }
    return ($curLine,$isWinbindEtc);
}



use NS::ConfCommon;
use NS::CIFSConst;
use NS::VolumeCommon;
use NS::VolumeConst;

my $const = new NS::CIFSConst;
my $confCommon = new NS::ConfCommon;

my $const_etcPath = $const->CONST_etcPath;
my $const_cifsPath = $const->CONST_cifsPath;
my $const_globalPath = $const->CONST_globalPath;
my $const_vsName = $const->CONST_vsName;

sub getCifsPath(){
    #Function: according to Group NO. return /etc/group[0|1]/nas_cifs
    #Parameters:
        #$groupNumber: the group number 0 or 1
    #Return:
        #groupNumber: 0 ---/etc/group0/nas_cifs
        #groupNumber: 1 ---/etc/group1/nas_cifs
    #Process:
    my $self = shift;
    my $groupNumber = shift;
    
    return ("${const_etcPath}${groupNumber}/${const_cifsPath}");
}


sub getVsFileName(){
    #Function: according to Group NO. return the full file name of virtual_servers
    #Parameters:
        #$groupNumber: the group number 0 or 1
    #Return:
        #groupNumber: 0 ---/etc/group0/nas_cifs/DEFAULT/virtual_servers
        #groupNumber: 1 ---/etc/group1/nas_cifs/DEFAULT/virtual_servers
    #Process:
    my $self = shift;
    my $groupNumber = shift;
    
    return ("${const_etcPath}${groupNumber}/${const_cifsPath}/${const_globalPath}/${const_vsName}");
}

sub getSmbFileName(){
    #Function: according to Group NO. and the domain Name and the computer Name 
    #         return the full file name of smb.conf.%L
    #Parameters:
        #$groupNumber      : the group number 0 or 1
        #$domainName       : the Domain Name
        #$computerName     : the Computer Name
    #Return:
        #/etc/group[0|1]/nas_cifs/DEFAULT/<DomainName>/smb.conf.<ComputerName>
    #Process:
    my ($self, $groupNumber, $domainName, $computerName) = @_;
    
    return "${const_etcPath}${groupNumber}/${const_cifsPath}/${const_globalPath}/${domainName}/smb.conf.${computerName}";
}

sub getDefaultShareUser(){
    my ($self, $groupNumber, $domainName) = @_;
    my $filename = "${const_etcPath}${groupNumber}/${const_cifsPath}/${const_globalPath}/${domainName}/smbpasswd";
    if (!open(FILE,"$filename")) {
        return 1;
    }
    my @content = <FILE>;
    close(FILE);
    my $username;
    if($content[0]=~/\s*\#\s*share(\d+)/){
        my $temp = $1 + 1;
        $username = "share${temp}";
        $content[0] = "\#$username\n";
    }else {
        #set "share1" at the first line
        $username = "share1";
        unshift(@content, "\#share1\n");
    }

    if (!open(FILE,"|${cmd_syncwrite_o} ${filename}")) {
        return 1;
    }
    print FILE @content;
    if(!close(FILE)) {
     print STDERR "The $filename can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
     return 1;
	}
    return $username;
}

sub getSmbContent(){
    #Function: according to Group NO. and the domain Name and the computer Name 
    #         return the content of smb.conf.%L
    #Parameters:
        #$groupNumber      : the group number 0 or 1
        #$domainName       : the Domain Name
        #$computerName     : the Computer Name
    #Return:
        #ref of the @array which contain the file content
    #Process:
    my ($self, $groupNumber, $domainName, $computerName) = @_;
    my $fileName = &getSmbFileName($self, $groupNumber, $domainName, $computerName);
    my @fileContent;
    open(FILE,$fileName);
    @fileContent = <FILE>;
    close FILE;
    return \@fileContent;
}

sub isShareSection(){
    #Function: if the input line is section beginning for 
    #          a valid share return 1; else return 0
    #Parameters:
        #sectionName --- the section name in the [smb.conf.%L]
    #Return:
        # 1 ------ a valid share name
        # 0 ------ a invalid share name
    #Process:
    my $self = shift;
    my $sectionName = shift;
    if(($sectionName !~ /^global$/i)
        && ($sectionName !~ /^printers$/i) 
        && ($sectionName !~ /^homes$/i)){
        
            #$sectionName can not be global
            #$sectionName can not be printers
            #$sectionName can not be homes
            return 1;
    }
    return 0;
}

sub isWorkingShare(){
    #Function: check the share is busy or not 
    #Parameters:
        #$groupNumber      : the group number 0 or 1
        #$domainName       : the Domain Name
        #$computerName     : the Computer Name
        #$shareName        : the Share Name
    #Return:
        #true  ------ the share is busy
        #false ------ the share is not busy
    #Process:
    my $self = shift;
    my $groupNumber = shift;
    my $domainName = shift;
    my $computerName = shift;
    my $shareName = shift;
    my $cmd_smbstatus = $const->COMMAND_SMB_STATUS;
    $cmd_smbstatus = "$cmd_smbstatus -L0 -g ${const_etcPath}${groupNumber}/${const_cifsPath} -l $domainName -n $computerName -k \Q$shareName\E";
    my @content = `$cmd_smbstatus 2>/dev/null`;
    if(scalar(@content) > 4){
        return "true";
    }else{
        return "false";
    }
}

sub getAllShareName(){
    #Function: return all the share names in the smb.conf.%L
    #Parameters:
        #$groupNumber      : the group number 0 or 1
        #$domainName       : the Domain Name
        #$computerName     : the Computer Name
    #Return:
        #the Ref of Array which contains all the share names
    #Process:
    my $self = shift;
    my $groupNumber = shift;
    my $domainName = shift;
    my $computerName = shift;
    my $smb_conf_content = &getSmbContent($self, $groupNumber, $domainName, $computerName);
    my @allShareName;
    my $allSectionName = $confCommon->getSectionList($smb_conf_content);
    
    foreach(@$allSectionName){
        if(&isShareSection($self, $_) == 1){
            push(@allShareName, $_);
        }
    }
    return \@allShareName;
}


sub getSecurityMode(){
    #Function: 
        #get the securityMode from the smb.conf.%L;
    #Arguments: 
        #$groupNumber       : the group number 0 or 1
        #$domainName        : the domain Name
        #$computerName      : the computer Name
    #return:
        #Domain | ADS | Share | NIS | Passwd | LDAP | ""
    my ($self, $groupNumber, $domainName, $computerName) = @_;

    my $smbContent = &getSmbContent($self, $groupNumber, $domainName, $computerName);

    my $security = $confCommon->getKeyValue("security", "global", $smbContent);

    if ($security =~ /^domain$/i) {

        return $const->CONST_SECURITY_MODE_DOMAIN;

    }elsif($security =~ /^ads$/i){

        return $const->CONST_SECURITY_MODE_ADS;

    }elsif($security =~ /^share$/i){

        return $const->CONST_SECURITY_MODE_SHARE;

    }elsif($security =~ /^user$/i){

        my $encryptPasswords = $confCommon->getKeyValue("encrypt passwords", "global", $smbContent);
        $encryptPasswords = &convertBoolean($self, $encryptPasswords, "no");

        if ($encryptPasswords eq "no") {
            my $pamServiceName = $confCommon->getKeyValue("pam service name", "global", $smbContent);
            
            if (defined($pamServiceName)) {
                if ($pamServiceName =~/^xsmbd_ims$/i) {

                    return $const->CONST_SECURITY_MODE_NIS;

                }elsif ($pamServiceName =~/^xsmbd_ldap$/i) {

                    return $const->CONST_SECURITY_MODE_LDAP;

                }
            }
            return $const->CONST_SECURITY_MODE_PASSWORD;

        }else{
            my $passdbBackend = $confCommon->getKeyValue("passdb backend", "global", $smbContent);
            if (defined($passdbBackend)) {
                if ($passdbBackend =~ /^ldapsam/i) {
                    return $const->CONST_SECURITY_MODE_LDAP;
                }
            }
            return $const->CONST_SECURITY_MODE_PASSWORD;
        }
    }
    return "";
}

sub convertBoolean(){
    my $self = shift;
    my $rawValue = shift;
    my $defaultValue = shift;

    if($rawValue =~ /^\s*(yes|1|true)\s*$/i){
        return "yes";
    }elsif($rawValue =~ /^\s*(no|0|false)\s*$/i){
        return "no";
    }else{
        return $defaultValue;
    }
}

sub isShareNameUsed(){
    #Function: check the share name has been used or not
    #Parameters:
        #$groupNumber      : the group number 0 or 1
        #$domainName       : the Domain Name
        #$computerName     : the Computer Name
        #$shareName        : the Share Name
    #Return:
        #true  ------ the share is busy
        #false ------ the share is not busy
    #Process:
    my $self = shift;
    my $groupNumber = shift;
    my $domainName = shift;
    my $computerName = shift;
    my $shareName = shift;
    my $smb_conf_content = &getSmbContent($self, $groupNumber, $domainName, $computerName);
    if($confCommon->hasSection($shareName, $smb_conf_content)){
        return "true";
    }else{
        return "false";
    }
}

sub setUserDB_forPath(){
    
    my $self = shift;
    my $directory = shift;
    my $mountPointInfo = shift;

    my $directMP = &getDirectMP($self, $directory);
    
    foreach(@$mountPointInfo){
        if(/^\Q${directMP}\E,(sxfs|sxfsfw),(y|n)/){
            if($2 eq "y"){
                return "has_set";
            }else{
                my $volCommon = new NS::VolumeCommon;
                my $retValue = $volCommon->setAuth($directMP, $1);
                my $volConst = new NS::VolumeConst;
                if($retValue eq $volConst->REGION_NOT_EXIST){
                    return "no_region_for_set";
                }elsif($retValue eq $volConst->AUTH_SET_SUCCESS){
                    return "set_success";
                }else{
                    return "set_failed";
                }
            }
        }
    }
}

sub isMpPath(){

    my $self = shift;
    
    my $directory = shift;
    my $mountPointInfo = shift;

    my $directMP = &getDirectMP($self, $directory);
    foreach(@$mountPointInfo){
        if(/^([^,]+),/){
            if($directMP eq $1){
                return "true";
            }
        }
    }
    return "false";
}

sub getDirectMP(){

    my $self = shift;
    my $directory = shift;
        
    if($directory =~ /^(\/export\/[^\/]+\/[^\/]+)/){
        return $1;
    }else{
        return $directory;
    }
}

sub getMpInfo(){
    # get the direct MP info,
    # return the Array such as:
    #   /export/liq/win,sxfsfw,n,none
    #   /export/liq/unix,sxfs,y,nis
    #   /export/liq/w.n,sxfsfw,y,ldap
    
    my $self = shift;
    my $groupNumber = shift;
    my $directory = shift;

    my $home = $ENV{HOME} || "/home/nsadmin";
    my $exportName = "";
    if($directory =~ /^\/export\/([^\/]+)/){
        $exportName = $1;
    }
    
    my @mountPointInfo;
    @mountPointInfo = `${home}/bin/userdb_getdmountlist.pl $exportName $groupNumber all`;
    return \@mountPointInfo;
}


my %smbglobalcmdlist = ("CONNECT" => "SMBsesssetup SMBnegprot SMBtcon SMBtconX sessrequest",
                "LOGOFF" => "SMBulogoffX");

my %smbsharecmdlist = ("MKDIR" => "SMBmkdir TRANSACT2_MKDIR",
                "RMDIR" => "SMBrmdir",
                "CREATE_OPEN" => "SMBopen SMBopenX SMBntcreateX TRANSACT2_OPEN SMBcreate SMBctemp SMBmknew NT_TRANSACT_CREATE",
                "CLOSE" => "SMBclose SMBexit SMBwriteclose",
                "FLUSH" => "SMBflush",
                "UNLINK" => "SMBunlink",
                "MV" => "SMBmv NT_TRANSACT_RENAME",
                "READ" => "SMBread SMBlockread SMBreadbraw SMBreadbmpx SMBreadX",
                "WRITE" => "SMBwrite SMBwriteunlock SMBwritebraw SMBwritebmpx SMBwritebs SMBwriteclose SMBwriteX",
                "LOCK" => "SMBlock SMBlockread SMBlockingX",
                "UNLOCK" => "SMBunlock SMBwriteunlock",
                "FILECOPY" => "SMBcopy",
                "SEARCH" => "SMBfindclose SMBfindnclose SMBsearch SMBffirst SMBfunique SMBfclose TRANSACT2_FINDFIRST TRANSACT2_FINDNEXT",
                "DISCONNECT" => "SMBtdis",
                "GETDISK" => "SMBdskattr",
                "GETINFO" => "SMBchkpth SMBgetatr SMBgetattrE TRANSACT2_QFSINFO TRANSACT2_QPATHINFO TRANSACT2_QFILEINFO NT_TRANSACT_QUERY_SECURITY_DESC NT_TRANSACT_GET_USER_QUOTA",
                "SETINFO" => "SMBlseek SMBsetatr SMBsetattrE TRANSACT2_SETFSINFO TRANSACT2_SETPATHINFO TRANSACT2_SETFILEINFO NT_TRANSACT_SET_SECURITY_DESC NT_TRANSACT_SET_USER_QUOTA",
                "IOCTL" => "TRANSACT2_IOCTL NT_TRANSACT_IOCTL SMBioctl",
                "OTHER" => "SMBtrans SMBkeepalive SMBtranss2 SMBnttranss SMBntcancel TRANSACT2_FINDNOTIFTFIRST TRANSACT2_FINDNOTIFYNEXT TRANSACT2_GET_DFS_REFERRAL NT_TRANSACT_NOTIFY_CHANGE");


#FUNCTION:
#       get smb commoncmd/logpickupcmd
#PARAM:
#       $loggingItems           "CONNECT:LOGOFF"|"MKDIR:RMDIR:OPEN..."|""
#       $flag                   "global"|"share"
#RETURN:
#       smb global/share cmds   "SMBsesssetup SMBnegprot..."|"SMBmkdir TRANSACT2_MKDIR..."|""
#       undef                   when error
sub getSMBCmd(){
    my $self = shift;
    if (scalar(@_)!=2){
        return undef;
    }
    my ($loggingItems,$flag) = @_;
    if ($loggingItems eq ""){
        return "";
    }
    
    my %smbcmdlist;
    if ($flag eq "global"){
        %smbcmdlist = %smbglobalcmdlist;
    }elsif($flag eq "share"){
        %smbcmdlist = %smbsharecmdlist;
    }else{
        return undef;
    }
    
    my @arrayOfItems = split(":",$loggingItems);
    my $smbCmds = "";
    foreach (@arrayOfItems){
        $smbCmds .= $smbcmdlist{$_}." ";     # get the cmds refer to defined logging items
    }

    $smbCmds =~ s/^\s+|\s+$//g;

    my @arrayOfcmds = split(/\s+/, $smbCmds);
    
    my @indexArrayOfcmds;
    for (my $i=0;$i<scalar(@arrayOfcmds);$i++){
        if (!grep(/^$arrayOfcmds[$i]$/,@indexArrayOfcmds)){
            push(@indexArrayOfcmds,$arrayOfcmds[$i]);
        }
    }
    
    return join(" ",@indexArrayOfcmds);  #return  the smb cmds
}

#FUNCTION:
#       get cifs global/share accesslog loggint items
#PARAM:
#       $smbCmds                "SMBsesssetup SMBnegprot..."|"SMBmkdir..."|""
#       $flag                   "global"|"share"
#RETURN:
#       the logging items       "CONNECT:..."|"MKDIR:RMDIR:OPEN:..."|""
#       undef                   when  error
sub getLoggingItems(){
    my $self = shift;
    if (scalar(@_)!=2){
        return undef;
    }
    my ($smbCmds, $flag) = @_;
    if ($smbCmds eq ""){
        return "";
    }
    
    my %smbcmdlist;
    if ($flag eq "global"){
        %smbcmdlist = %smbglobalcmdlist;
    }elsif($flag eq "share"){
        %smbcmdlist = %smbsharecmdlist;
    }else{
        return undef;
    }    
    my @arrayOfcmds = split(/\s+/, $smbCmds);
    my $loggingItems = "";
    my $key;
    my $value;
    while (($key,$value) = each %smbcmdlist){
        my @cmdsOfoneitem = split(/\s+/,$value);                #"SMBmkdir TRANSACT2_MKDIR"... 
        my $i = 0;
        my $eachCmd;
        foreach $eachCmd (@cmdsOfoneitem){              #grep each cmd of the item
            if (!grep(/^${eachCmd}$/, @arrayOfcmds)){
                last;
            }
            $i++;
        }
        if ($i==scalar(@cmdsOfoneitem)){
            $loggingItems.=$key.":";        #if the item's every cmds in the $smbCmds, the item is logging. 
        }
    }
    chop($loggingItems);
    return $loggingItems;
}

#FUNCTION:
#       get all logging items for share
#PARAM:
#       none
#RETURN:
#       "MKDIR:RMDIR:OPEN..."
sub getAllItems(){
    my $self = shift;
    my @allItem = keys (%smbsharecmdlist);
    my $ret = join(":", @allItem);
    return $ret;
}

#FUNCTION:
#       get cifs userspace
#PARAM:
#       $accesslogFlag          "yes"|"no"
#       $smbSuccessCmds         "COLLECTALL SMBmkdir SMBread..."|""
#       $smbErrorCmds           "COLLECTALL SMBmkdir SMBread..."|""
#RETURN:
#       "yes"|"no"
#       undef
sub getExecuserspace(){
    my $self = shift;
    if (scalar(@_)!=3){
        return undef;
    }
    my ($accesslogFlag, $smbSuccessCmds, $smbErrorCmds) = @_;
    
    if ($accesslogFlag ne "yes"){
        return "no";
    }
    if ($smbSuccessCmds eq "" && $smbErrorCmds eq ""){
        return "no";
    }
    
    my @arrayOfsuccessCmds = split(/\s+/,$smbSuccessCmds);
    my @arrayOferrorCmds = split(/\s+/,$smbErrorCmds);
    
    my @smbUserspaceCmds = ("COLLECTALL","SMBread","SMBlockread","SMBreadbraw","SMBreadbmpx","SMBreadX","SMBwrite",
            "SMBwriteunlock","SMBwritebraw","SMBwritebmpx","SMBwritebs","SMBwriteclose","SMBwriteX");
    my $userspaceCmd;
    foreach $userspaceCmd (@smbUserspaceCmds){
        if($smbSuccessCmds =~ /\b$userspaceCmd\b/g){
            return "yes";
        }
        if($smbErrorCmds =~ /\b$userspaceCmd\b/g){
            return "yes";
        }
    }
    return "no";
}
#FUNCTION:
#       write gui log info file
#PARAM:
#        $groupNumber      : the group number 0 or 1
#        $domainName       : the Domain Name
#        $computerName     : the Computer Name
#RETURN:
#       0       when write successful
#       1       when error
sub writeGUILogInfo(){
    my $self = shift;
    if (scalar(@_)!=3){
        return 1;
    }
    my ($groupNumber, $domainName, $computerName) = @_;
    my $vsfile = &getVsFileName($self, $groupNumber);

    my @vsContent = `cat ${vsfile} 2>/dev/null`;
    
    my $smbContent = &getSmbContent($self, $groupNumber, $domainName, $computerName);
    my $logfile = $confCommon->getKeyValue("alog file", "global", $smbContent);
    if (defined($logfile)){
        $logfile .=".inf";
    }else{
        return 1;
    }
    
    my $smbGlobalSuccesscmd = $confCommon->getKeyValue("alog logging success without tid", "global", $smbContent);
    my $smbGlobalErrorcmd = $confCommon->getKeyValue("alog logging error without tid", "global", $smbContent);
    if (!defined($smbGlobalSuccesscmd)){
        $smbGlobalSuccesscmd = "";   
    }
    if (!defined($smbGlobalErrorcmd)){
        $smbGlobalErrorcmd = "";   
    }
    
    my $exportgroup;   #exportgroup name
    foreach (@vsContent){
        if ($_ =~ /^\s*\/export\/(\w+)\s+\Q${domainName}\E\s+\Q${computerName}\E\s*$/){
            $exportgroup = $1;
            last;
        }
    }
    
    my $curtime = `date +'%Y/%m/%d %T'`;   #format: 2004/04/15 13:22:51
    chomp($curtime);
    my @newContent = ();
    push(@newContent, "#### ${curtime} ${exportgroup}\n");
    push(@newContent, "alog logging success without tid=${smbGlobalSuccesscmd}\n");
    push(@newContent, "alog logging error without tid=${smbGlobalErrorcmd}\n");
    
    my ($shareNameRef, $shareSectionIndexRef) = &getAllShareInfo($self, $smbContent);
    my $shareNumbers = scalar(@$shareNameRef);
    for(my $tmpIndex = 0; $tmpIndex < $shareNumbers; $tmpIndex++){#share section
        my $shareName = @$shareNameRef[$tmpIndex];
        my $endIndex;
        if($tmpIndex == ($shareNumbers - 1)){
            $endIndex = scalar(@$smbContent) - 1;
        }else{
            $endIndex = @$shareSectionIndexRef[$tmpIndex + 1] - 1;
        }
        my @tmpSection = @$smbContent[@$shareSectionIndexRef[$tmpIndex]..$endIndex];
        
        my $cifsAccesslog = $confCommon->getKeyValue("alog enable", ${shareName}, \@tmpSection);
        my $smbShareSuccesscmd = $confCommon->getKeyValue("alog logging success with tid", ${shareName}, \@tmpSection);
        my $smbShareErrorcmd = $confCommon->getKeyValue("alog logging error with tid", ${shareName}, \@tmpSection);
        if (!defined($cifsAccesslog)){
            $cifsAccesslog = "no";
        }        
        if (!defined($smbShareSuccesscmd)){
            $smbShareSuccesscmd = "";   
        }        
        if (!defined($smbShareErrorcmd)){
            $smbShareErrorcmd = "";   
        }
        push(@newContent, "#${shareName}\n");
        push(@newContent, "alog enable=${cifsAccesslog}\n");
        push(@newContent, "alog logging success with tid=${smbShareSuccesscmd}\n");
        push(@newContent, "alog logging error with tid=${smbShareErrorcmd}\n");
    }
    push (@newContent, "\n");
    
#    if (!open(FILE,"|${cmd_syncwrite_a} ${logfile}")) {
    if (!open(FILE, ">>", "${logfile}")) {
        print STDERR "Open $logfile failed. Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
        return 1;
    }
    print FILE @newContent;
    if(!close(FILE)) {
     print STDERR "The $logfile can not be written! Exit in perl script:",__FILE__," line:",__LINE__+1,".\n";
     return 1;
	}
    
    return 0;
}

sub getLdapAnonymous(){
    my $self = shift;
    my $content = &get_proftpd_ldap_confContent($self);
    my $ldapAuthType = "";
    my $hasLdapAuthName = 0;
    foreach(@$content){
        if(/^\s*nas_mech\s+(\S+)/){
            $ldapAuthType = $1;
        }elsif(/^\s*nas_bindname\s+(\S+.*)/){
            $hasLdapAuthName = 1;
        }
    }
    
    if(($ldapAuthType eq "SIMPLE") && ($hasLdapAuthName == 0)){
        return "yes";
    }else{
        return "no";
    }
}

sub get_proftpd_ldap_confContent(){
    my $self = shift;
    my $LDAP_CONF = "/etc/ftpd/proftpd_ldap.conf";
    my @content;
    @content = `cat $LDAP_CONF 2>/dev/null`;
    return \@content;
}

sub getAllInterfaces(){
    my $self = shift;
    my $nic_common = new NS::NicCommon;
	my $arrayRef = $nic_common->getInterfaces("-s");
	if(!defined($arrayRef)){
		 return ("", "");
	}
	my @result = @$arrayRef;
    if(scalar(@result)>0){
    	my @allInterfaces;
        my @allInterfacesLabel;
    	for(my $index = 0; $index < @result; $index ++){
            my @tmp = split(/\s+/,$result[$index]);
            if($tmp[1] eq "UP"){
            	
            	my @IP = split(/\//,$tmp[2]);
            	push(@allInterfaces,$IP[0]);
            	push(@allInterfacesLabel,"$IP[0]($tmp[0])");
            }
        }
        return (join(" ", @allInterfaces), join(" ", @allInterfacesLabel));
    }else{
    	return ("", "");
    }
}

sub makeLogFileDir(){
    my ($self, $logFileName, $userRead) = @_;

    if (-d $logFileName){
        return 1;
    }
    
    my $logdirname = substr($logFileName,0,rindex($logFileName,"/"));
    my @arrayOfdir = split(/\//, $logdirname);
    
    shift(@arrayOfdir);		#delete first element
    
    my $work = "/";
    foreach  (@arrayOfdir){
        if ($_ ne ""){      #prevent from "/a/b//c"
            $work .=$_;
            unless (-e $work) {
                if (!mkdir($work)) {
                    return 0;
                }
                &chgdirmod($self, $work, $userRead);
            }else{
                unless (-d $work){   # if $work isn't directory
                    print STDERR "Failed to mkdir, [$work] is not a directory.\n";
                    return 2;
                }
            }
            $work .= "/";
        }
    }
    return 0;
}

#change the specify directory's read right.
sub chgdirmod(){
    my ($self, $dir, $userRead) = @_;
    if ($userRead eq "yes"){
        system("chmod","0775","$dir");
    }elsif($userRead eq "no"){
        system("chmod","0771","$dir");
    }
    return 0;
}

sub setLdapInfo(){
    my $self = shift;
    my $groupNumber = shift;
    my $domainName = shift;
    my $computerName = shift;
    my $encryptPasswords = shift;# "yes"|"no"
    my $fileContent = shift;
    
    if($encryptPasswords eq "yes"){
        #update the parameter for LDAPSAM in the $fileContent
        &setLdapSamPara($self, $groupNumber, $domainName, $computerName, $fileContent, &getLdapSamParaInfo($self));
    }else{
        #delete the parameter for LDAPSAM from $fileContent
        &deleteLdapSamPara($self, $fileContent);
    }
    
}

sub deleteLdapSamPara(){
    my $self = shift;
    my $fileContent = shift;
    $confCommon->deleteKey("passdb backend", "global", $fileContent);
    $confCommon->deleteKey("ldap admin dn", "global", $fileContent);
    $confCommon->deleteKey("ldap suffix", "global", $fileContent);
    $confCommon->deleteKey("ldap filter", "global", $fileContent);
    $confCommon->deleteKey("ldap ssl", "global", $fileContent);
    $confCommon->deleteKey("ldap bind", "global", $fileContent);
    $confCommon->deleteKey("ldap tls_cacert", "global", $fileContent);
    $confCommon->setKeyValue("pam service name", "xsmbd_ldap", "global", $fileContent);
}

sub setLdapSamPara(){
    my ($self, $groupNumber, $domainName, $computerName, $fileContent, 
        $ldapServer, $ldapSSL, $ldapAdminDN, $ldapSuffix, 
            $ldapUserFilter, $ldapBind, $tls_cacert, $ldapPassword) = @_;
    
    #add the parameter for LDAPSAM
    $ldapServer =~ s/^\s+|\s+$//g;#delete the spaces at the start or the end of the string,if there is
    my $passdbBackend = $ldapServer;
    if($ldapSSL eq "yes"){
        #like as [passdb backend = ldapsam:"ldaps://192.168.0.1,ldaps://192.168.0.2:636"]
        #        [passdb backend = ldapsam:ldaps://192.168.0.1]
        if($passdbBackend =~ s/\s+/,ldaps:\/\//g){
            #instead the spaces as [,ldaps://] in the $passdbBackend
            #the ldap server is more than 1
            $passdbBackend = "ldapsam:\"ldaps://$passdbBackend\"";
        }else{
            #the ldap server is only 1
            $passdbBackend = "ldapsam:ldaps://$passdbBackend";
        }
        
    }else{
        #like as [passdb backend = ldapsam:"ldap://192.168.0.1,ldap://192.168.0.2:636"]
        #        [passdb backend = ldapsam:ldap://192.168.0.1]
        if($passdbBackend =~ s/\s+/,ldap:\/\//g){
            #instead the spaces as [,ldap://] in the $passdbBackend 
            #the ldap server is more than 1
            $passdbBackend = "ldapsam:\"ldap://$passdbBackend\"";
        }else{
            #the ldap server is only 1
            $passdbBackend = "ldapsam:ldap://$passdbBackend";
        }
    }
    $confCommon->setKeyValue("passdb backend", $passdbBackend,         "global", $fileContent);
    $confCommon->setKeyValue("ldap admin dn",  "\"".$ldapAdminDN."\"", "global", $fileContent);
    $confCommon->setKeyValue("ldap suffix",    $ldapSuffix,            "global", $fileContent);
    if($ldapUserFilter ne ""){
        $confCommon->setKeyValue("ldap filter", $ldapUserFilter, "global", $fileContent);
    }
    
    $confCommon->setKeyValue("ldap ssl", $ldapSSL, "global", $fileContent);
    if($ldapBind eq "SIMPLE"){
        $confCommon->setKeyValue("ldap bind", "simple", "global", $fileContent);
    }elsif($ldapBind eq "DIGEST-MD5"){
        $confCommon->setKeyValue("ldap bind", "sasl_dmd5", "global", $fileContent);
    }elsif($ldapBind eq "CRAM-MD5"){
        $confCommon->setKeyValue("ldap bind", "sasl_cmd5", "global", $fileContent);
    }
    
    if($tls_cacert ne ""){
        $confCommon->setKeyValue("ldap tls_cacert", $tls_cacert, "global", $fileContent);
    }
    
    $confCommon->deleteKey("pam service name", "global", $fileContent);
    
}

sub getLdapSamParaInfo(){
    my $self = shift;
    my $content = &get_proftpd_ldap_confContent($self);
    
    my $ldapServer = "";
    my $ldapSSL = "";
    my $ldapAdminDN = "";
    my $ldapSuffix = "";
    my $ldapUserFilter = "";
    my $ldapBind = "";
    my $tls_cacert = "";
    my $ldapPassword = "";
    foreach(@$content){
        if(/^\s*nas_host\s+(\S+.*)/){
            $ldapServer = $1;
        }elsif(/^\s*nas_usetls\s+(\S+)/){
            if($1 eq "y"){
                $ldapSSL = "start_tls";
            }elsif($1 eq "n"){
                $ldapSSL = "no";
            }elsif($1 eq "ssl"){
                $ldapSSL = "yes";
            }
        }elsif(/^\s*nas_bindname\s+(\S+.*)/){
            $ldapAdminDN = $1;
        }elsif(/^\s*nas_basedn\s+(\S+.*)/){
            $ldapSuffix = $1;
        }elsif(/^\s*nas_pam_filter\s+(.+)/){
            $ldapUserFilter = $1;
        }elsif(/^\s*nas_mech\s+(\S+)/){
            $ldapBind = $1;
        }elsif(/^\s*nas_certfile\s+(\S+)/){
            $tls_cacert = $1;
        }elsif(/^\s*nas_bindpasswd\s(.+)/){
            $ldapPassword = $1;
        }
    }
    
    return ($ldapServer, $ldapSSL, $ldapAdminDN, $ldapSuffix, 
            $ldapUserFilter, $ldapBind, $tls_cacert, $ldapPassword);
}

#FUNCTION:
#       check file read right
#PARAM:
#       $filename: file name
#RETURN:
#       "yes"|"no"
#       undef: when error
sub checkUserRead(){
    my $self = shift;
    my $filename = shift;
    $filename="\Q$filename\E";
    my @filestat = `stat $filename | grep Access`;   #Access: (0775/-rwxrwxr-x)  Uid: (  500/ nsadmin)   Gid: (  500/ nsadmin)
    foreach (@filestat){
    	if ($_ =~ /^Access:\s+\(\d{3}(\d)\/.*/i){
            if ($1 eq '5'||$1 eq '7'){
            	return "yes";
            }else{
            	return "no";
            }
    	}
    }
    return undef;
}

#FUNCTION:
#       get the the mount point that the directory is included
#PARAM:
#       $groupNo
#       $directory
#RETURN:
#       $directory's mount point 
#       undef: when error
sub getMP(){
    my $self = shift;
    my $groupNo = shift;
    my $directory = shift;
    my $cfstabContent = shift;
    my @content;
    if(defined($cfstabContent)){
        @content = @$cfstabContent;
    }else{
        my $conffile = "/etc/group".$groupNo."/cfstab";
        @content = `cat $conffile`;
    }
    my $length = scalar(@content);
    if ($length == 0) {
        return undef;
    }
    my $mp = "";
    for (my $i=$length-1;$i>=0;$i--) {
        if (($content[$i] =~ /^\s*#/)
            ||($content[$i] =~ /^\s*$/)){
            next;
        }
        my @tmp = split(/\s+/,$content[$i]);
        if(($directory eq $tmp[1])
           ||($directory =~ /^\Q$tmp[1]\E[\/]/)
          ) {
           $mp = $tmp[1];
           last;
        }
    }

    if ($mp eq "") {
        return undef;
    }else{
        return $mp;
    }
   
}
#FUNCTION:
#       check the specified directory 's volume  whether the DMAPI is used
#PARAM:
#       $groupNo
#       $directory
#RETURN:
#       true | false 
#       undef: when error

sub chkDMAPI(){

    my $self = shift;
    my $groupNo = shift;
    my $directory = shift;
    my $mp = &getMP($self,$groupNo,$directory);

    if (!defined($mp)){
        print STDERR "Failed to get the mount point for [$directory].\n";
        return undef;
    }

    my $volumeCommon = new NS::VolumeCommon;
    my $volumeConst = new NS::VolumeConst;
    my $mpsOptions = $volumeCommon->getMountOptionsFromCfstab();
    
    if(defined($$mpsOptions{$volumeConst->ERR_FLAG})){
		print STDERR "The [$$mpsOptions{$volumeConst->ERR_FLAG}] occurred.\n";
		return undef;
    }
    my $oneMpOptions = $$mpsOptions{$mp};
    if(!defined($oneMpOptions)){
		print STDERR "Failed to get the mount point option.\n";
		return undef;
    }
    my $dmapiPath = $$oneMpOptions{"dmapi"};
    if (defined($dmapiPath) && $dmapiPath eq "on") {
        return "true";
    }else{
        return "false";
    }

}

#FUNCTION:
#       get the dir access file name from the smb.conf.%L
#PARAM:
#       $self
#       $groupNo
#       $domainName    
#       $computerName  
#RETURN:
#       $fileName
#       "": can not get the corresponding value
sub getDirAccessConfFileName(){
        
    my $self = shift;
    my $groupNo = shift;
    my $domainName = shift;
    my $computerName = shift;
    # get the smb.conf file content
    my $smbContent = &getSmbContent($self, $groupNo, $domainName, $computerName);

    # get the dir access conf file name from the smb.conf
    my $dirAccessFile = $confCommon->getKeyValue("dir access list file", "global", $smbContent);
    if (!defined($dirAccessFile) || ($dirAccessFile eq "\"\"")||($dirAccessFile eq "")){
        return "";
    }
    
    return &varSubstitute($self, $groupNo, $domainName, $computerName, $dirAccessFile);
}

#FUNCTION:
#       return the default dir access file name [%r/%D/diraccesslist.%L]
sub getDefaultDirAccessConfFileName(){
    my $self = shift;
    my $groupNo = shift;
    my $domainName = shift;
    my $computerName = shift;
    return "/etc/group$groupNo/nas_cifs/DEFAULT/$domainName/diraccesslist.$computerName";
}

#FUNCTION:
#       VARIABLE SUBSTITUTIONS
#PARAM:
#       $self
#       $groupNo
#       $domainName    
#       $computerName  
#	    $fileName

#RETURN:
#       $modFileName

sub varSubstitute(){
        
    my $self = shift;
    my $groupNo = shift;
    my $domainName = shift;
    my $computerName = shift;
    my $fileName = shift;

    # replace %r -> /etc/group[0|1]/nas_cifs/DEFAULT
    $fileName =~ s/%r/\/etc\/group$groupNo\/nas_cifs\/DEFAULT/g;
    # replace %D -> $domainName
    $fileName =~ s/%D/${domainName}/g;
    # replace %L -> $computerName
    $fileName =~ s/%L/${computerName}/g;

    return $fileName;
}

sub getSectionInfo(){
    my ($self, $section, $content) = @_;
    my $offset;
    my $length;
    my $startCount = 0;
    my $index = 0;
    foreach my $line (@$content){
        if ($line =~ /^share:(.*)\s*$/i ) {
            my $tmpSection = &trimSpace($1);
            if ($tmpSection =~ /^\Q${section}\E$/i){
                $length = 1;
                $startCount = 1;
                $offset = $index;
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

sub trimSpace(){
    my $str=shift;
    $str =~ s/^\s+|\s+$//g;
    return $str;
}

sub touchDirAccessConf(){
    my $self = shift;
    my $groupNo = shift;
    my $domainName = shift;
    my $computerName = shift;
    my $confFileName = &getDirAccessConfFileName($self, $groupNo, $domainName, $computerName);
    if($confFileName ne ""){
        if(!(-e $confFileName)){
            &makeLogFileDir($self, $confFileName, "yes");
            system("touch $confFileName");
            system("chmod","644",$confFileName);
        }
    }
}

sub getValidBaseDir(){
    my $self = shift;
    my $fileName = shift;
    my $groupNo = shift;
    my $const_cifsLogDir = "/var/log";
    my $const_exportDir = "/export";
    if($fileName eq "/var/log"){
        return $const_cifsLogDir;
    }elsif($fileName =~ /^\/var\/log\//){
        return $fileName;
    }if(($fileName eq "/export") || ($fileName eq "/export/")){
        return $const_exportDir;
    }elsif($fileName =~ /^(\/export\/[^\/]+)/){
        #such as /export/exportGroup
        #        /export/exportGroup/sxfsfw
        #        /export/exportGroup/sxfs
        #        /export/exportGroup/sxfs/submp
        my $tmpExportGroup = $1;
        if(&isExportGroup($self, $tmpExportGroup, $groupNo)==1){
            if($fileName =~ /^(\/export\/[^\/]+\/[^\/]+)/){
                #such as /export/exportGroup/sxfsfw
                #        /export/exportGroup/sxfs
                #        /export/exportGroup/sxfs/submp
                if(&isSXFS_MP($self, $1, $groupNo)==1){
                    #the fstype is sxfs
                    return &getMountingBaseDir($self, $fileName, $groupNo);
                }
            }
            return $tmpExportGroup;
        }else{
            return $const_exportDir;
        }
    }else{
        return $const_cifsLogDir;
    }
}

sub isSXFS_MP(){
    my $self = shift;
    my $path = shift;
    my $groupNo = shift;
    if(&getFstypeOfSpecifiedDir($self, $path, $groupNo) eq "sxfs"){
        return 1;
    }else{
        return 0;
    }
}

sub getMountingBaseDir(){
    my $self = shift;
    my $fileName = shift;
    my $groupNo = shift;
    my $mountingInfoRef = &getAllMountingMP($self);
    my @cfstabContent = `cat /etc/group$groupNo/cfstab`;
    while(1){
        if($fileName =~ /^\/export\/[^\/]+$/){
            #such as: /export/exportGroup
            return $fileName;
        }
        my $tmpMp = &getMP($self, $groupNo, $fileName, \@cfstabContent);
        if(defined($$mountingInfoRef{$tmpMp})){
            #is mounting
            return $fileName;
        }else{
            #get his father
            $fileName = substr($fileName, 0, rindex($fileName, "/"));
        }
    }
}

sub isExportGroup(){
    my $self = shift;
    my $path = shift;
    my $groupNo = shift;
    my $allExportGroup = shift;
    if(!defined($allExportGroup)){
        $allExportGroup = &getAllExportGroup($self, $groupNo);
    }
    if(defined($$allExportGroup{$path})){
        return 1;
    }else{
        return 0;
    }
}

sub getAllExportGroup(){
    my $self = shift;
    my $groupNo = shift;
    my $expgrpsFile = "/etc/group${groupNo}/expgrps";
    my %exportGroupInfo;
    if(-f $expgrpsFile){
        my @content = `cat $expgrpsFile 2>/dev/null`;
        foreach(@content){
            if(/^\s*(\S+)\s+/){
                $exportGroupInfo{$1} = "";
            }
        }
    }
    return \%exportGroupInfo;
}

sub logFileInRightArea(){
    my $self = shift;
    my $alogFileName = shift;
    my $groupNo = shift;
    my $const_cifsLogDir = "/var/log/";
    if($alogFileName =~ /^\Q$const_cifsLogDir\E/){
        if($alogFileName eq $const_cifsLogDir){
            return 0;
        }else{
            return 1;
        }
    }else{
        my $result = &fileInUserArea($self, $alogFileName, $groupNo);
        if($result == 1){
            #need check the corresponding mp is mounting or not
            return &fileInMountingMp($self, $alogFileName, $groupNo);
        }else{
            return 0;
        }
    }
}

sub fileInUserArea(){
    my $self = shift;
    my $fileName = shift;
    my $groupNo = shift;
    my $const_exportDir = "/export/";
    
    if($fileName =~ /^\/export\/[^\/]+\/[^\/]+\/[^\/]+/){
        #such as: /export/exportGroup/directMP/file
        my $cfstabFile = "/etc/group${groupNo}/cfstab";
        if(-f $cfstabFile){
            my @content = `cat $cfstabFile 2>/dev/null`;
            foreach(@content){
                if(/^\s*\S+\s+(\S+)\s+/){
                    if(($fileName eq $1) || $fileName=~/^\Q$1\E\//){
                        return 1;
                    }
                }
            }
        }
        return 0;
    }else{
        return 0;
    }
}

sub fileInMountingMp(){
    my $self = shift;
    my $fileName = shift;
    my $groupNo = shift;
    my $tmpMp = &getMP($self, $groupNo, $fileName);
    my $mountingInfoRef = &getAllMountingMP($self);
    if(defined($$mountingInfoRef{$tmpMp})){
        #is mounting
        return 1;
    }else{
        return 0;
    }
}

#FUNCTION:
#       get the fstype of all the MP from the cfstab
#PARAM:
#       $self
#       $groupNo

#RETURN:
#       the ref of the hash which contain the fstype of all the MP

sub getFstypeOfAllMP(){
    my $self = shift;
    my $groupNo = shift;
    my $cfstabContent = shift;
    my @content;
    if(defined($cfstabContent)){
        @content = @$cfstabContent;
    }else{
        my $conffile = "/etc/group".$groupNo."/cfstab";
        @content = `cat $conffile`;
    }
    
    my %fstypeInfo;
    my ($tmpMP, $tmpFSType, $tmpOption);
    foreach(@content){
        if(/^\s*\S+\s+(\S+)\s+(\S+)\s+(\S+)\s+/){
            $tmpMP = $1;
            $tmpFSType = $2;
            $tmpOption = $3;
            if(lc($tmpFSType) eq "syncfs"){
                if($tmpOption =~ /cache_type=(\w+)/i){
                    $tmpFSType = lc($1);
                }
            }
            $fstypeInfo{$tmpMP} = lc($tmpFSType);
        }
    }
    return \%fstypeInfo;
}

#FUNCTION:
#       get the fstype of all the MP from the cfstab
#PARAM:
#       $self
#       $groupNo

#RETURN:
#       the ref of the hash which contain the fstype of all the MP

sub getFstypeOfSpecifiedDir(){
    my $self = shift;
    my $directory = shift;
    my $groupNo = shift;
    my $fstypeOfAllMp = shift;
    if(!defined($fstypeOfAllMp)){
        $fstypeOfAllMp = &getFstypeOfAllMP($self, $groupNo);
    }
    
    my $directMP = &getDirectMP($self, $directory);
    
    if(defined($$fstypeOfAllMp{$directMP})){
        return $$fstypeOfAllMp{$directMP};
    }else{
        return "";
    }
}

#FUNCTION:
# return the index of a valid line in %r/%D/diraccesslist.%L
sub getNextValidLineIndex(){
    my $self = shift;
    my $contentRef = shift;
    my $startIndex = shift;
    my $endIndex = shift;
    if(!defined($startIndex)){
        $startIndex = 0;
    }
    if(!defined($endIndex)){
        $endIndex = scalar(@$contentRef)-1;
    }
    for(my $i = $startIndex; $i <= $endIndex; $i++){
        if($$contentRef[$i] =~ /^\s*[#;\s]/){
            #this line starts with # or ; or space
            next;
        }elsif($$contentRef[$i] =~ /^\s*$/){
            #this line is space line
            next;
        }else{
            return $i;
        }
    }
    return undef;
}

sub getShareSectionStartIndex(){
    my $self = shift;
    my $shareName = shift;
    my $contentRef = shift;
    my $lines = scalar(@$contentRef);
    for(my $i = 0; $i < $lines; $i++){
        if($$contentRef[$i] =~ /^share:(.+)/){
            if(lc($1) eq lc($shareName)){
                return $i;
            }
        }
    }
    return undef;
}

sub getShareSectionEndIndex(){
    my $self = shift;
    my $contentRef = shift;
    my $startIndex = shift;
    my $lines = scalar(@$contentRef);
    for(my $i = $startIndex+1; $i < $lines; $i++){
        if($$contentRef[$i] =~ /^share:.+/){
            return ($i-1);
        }
    }
    return ($lines-1);
}


sub getDirSectionStartIndex(){
    my $self = shift;
    my $dir = shift;
    my $contentRef = shift;
    my $startIndex = shift;
    my $endIndex = shift;
    for(my $i = $startIndex; $i <= $endIndex; $i++){
        if($$contentRef[$i] =~ /^dir:(.+)/){
            if(lc($1) eq lc($dir)){
                return $i;
            }
        }
    }
    return undef;
}

sub getDirSectionEndIndex(){
    my $self = shift;
    my $contentRef = shift;
    my $startIndex = shift;
    my $endIndex = shift;
    for(my $i = $startIndex+1; $i <= $endIndex; $i++){
        if($$contentRef[$i] =~ /^dir:.+/){
            return ($i-1);
        }
    }
    return $endIndex;
}

sub getAllMountingMP(){
    my $self = shift;
    my $mountingContentRef = shift;
    my @content;
    if(defined($mountingContentRef)){
        @content = @$mountingContentRef;
    }else{
        @content = `/bin/mount`;
    }
    
    my %mountingMpInfo;
    foreach(@content){
        if(/^\s*\S+\s+on\s+(\S+)\s+/){
            $mountingMpInfo{$1} = "";
        }
    }
    return \%mountingMpInfo;
}

sub getExportGroup() {
    shift;
    my($groupNo, $domainName, $computerName) = @_;
    if(!defined($groupNo) || !defined($domainName) || !defined($computerName)) {
        return undef;
    }
    my $path = "/etc/group${groupNo}/nas_cifs/DEFAULT/virtual_servers";
    my @fileContent = `cat $path 2>/dev/null`;
    foreach (@fileContent) {
        if($_ =~ /^\s*(\S+)\s+\Q$domainName\E\s+\Q$computerName\E\s*$/) {
            return $1;
        }
    }
    return undef;
}

use NS::USERDBCommon;

sub getExpGroupEncoding() {
    my $self = shift;
    my($groupNo, $domainName, $computerName) = @_;
    my $userdbCommon = new NS::USERDBCommon;
    if(!defined($groupNo) || !defined($domainName) || !defined($computerName)) {
        return undef;
    }
    my $exportGroup = &getExportGroup($self, $groupNo, $domainName, $computerName);
    if(!defined($exportGroup)) {
        return undef;
    }
    my $expGroupEncoding = $userdbCommon->getExpgrpCodePage($groupNo, $exportGroup);
    return $expGroupEncoding;
}

sub getAllShareInfo(){
    my $self = shift;
    my $contentRef = shift;
    my @shareList;
    my @shareSectionIndexs;
    my $lines = scalar(@$contentRef);
    my %shareName;
    
    for(my $lineIndex = 0; $lineIndex < $lines; $lineIndex++){
        my $line = @$contentRef[$lineIndex];
        if ($line =~ /^\s*\[(.*)\]\s*$/i ) {
            my $section = $1;
            $section =~ s/^\s+|\s+$//g;
            if(&isShareSection($self, $section) == 1){
                if(exists($shareName{$section}) == 0) {
                    push(@shareList, $section);
                    push(@shareSectionIndexs, $lineIndex);
                    $shareName{$section} = "";
                }
            }
        }
    }
    return (\@shareList,\@shareSectionIndexs);
}

#FUNCTION:
#    check each node, judge whether direct hosting can be set
#PARAM:
#    $self
#    $groupNumber
#RETURN:
#    undef : check one node failed 
#        0 : self node can NOT set
#        1 : friend node can NOT set
#      yes : direct hosting can be set
sub canSetDirectHosting() {
    my ($self, $groupNumber) = @_;
    my $canSetDHScriptPath = "/home/nsadmin/bin/cifs_canSetDirectHosting.pl";
    my $canSetDH0 = `$canSetDHScriptPath $groupNumber 2>/dev/null`;
    if ($? == 0) {
        defined($canSetDH0) or $canSetDH0 = "";
        chomp($canSetDH0);
        if($canSetDH0 eq "yes") {
        #need check friend node if it is cluster
            $groupNumber = 1 - $groupNumber;
            my $friendIP = $comm->getFriendIP();
            if(defined($friendIP)) {
                #is cluster
                `/home/nsadmin/bin/cluster_checkStatus.pl 2>/dev/null`;
                if($? == 0) {
                    #cluster is in normal status
                    my ($exitCode, $canSetDH1) = $comm->rshCmdWithSTDOUT("$canSetDHScriptPath $groupNumber", $friendIP);
                    if(defined($exitCode) && ($exitCode == 0)) {
                        defined($$canSetDH1[0]) or $$canSetDH1[0] = "";
                        chomp($$canSetDH1[0]);
                        if($$canSetDH1[0] eq "no") {
                            return "1";
                        }
                    } else {
                        return undef;
                    }
                } else {
                    #cluster is in reduce status, group0 & group1 are on one node.
                    my $canSetDH1 = `$canSetDHScriptPath $groupNumber 2>/dev/null`;
                    if($? == 0) {
                        defined($canSetDH1) or $canSetDH1 = "";
                        chomp($canSetDH1);
                        if($canSetDH1 eq "no") {
                            return "1";
                        }
                    } else {
                        return undef;
                    }
                }
            }
        } else {
            return "0";
        }
    } else {
        return undef;
    }
    return "yes";
}

sub getDirectHosting(){
    my ($self, $groupNumber, $domainName, $computerName) = @_;
    my $fileName = &getSmbFileName($self, $groupNumber, $domainName, $computerName);
    if(! -f $fileName) {
        return "no";
    }
    my $fileContent = &getSmbContent($self, $groupNumber, $domainName, $computerName);
    my $directHosting = $confCommon->getKeyValue("smb ports", "global", $fileContent);
    defined($directHosting) or $directHosting = "";
    if($directHosting =~ /^445$/ || $directHosting =~ /^445\s/ || $directHosting =~ /\s445$/ || $directHosting =~ /\s445\s/) {
        return "yes";
    } else {
        return "no";
    }
}

sub getShareType() {
    my($self, $shareName, $section) = @_;
    my $backup = $confCommon->getKeyValue("backup exclusive share", $shareName, $section);
    defined($backup) or $backup = "";
    if($backup =~ /^yes$/i) {
        return "backup";
    } else {
        my $realtimeScan = $confCommon->getKeyValue("virus scan exclusive share", $shareName, $section);
        defined($realtimeScan) or $realtimeScan = "";
        if($realtimeScan =~ /^yes$/i) {
            return "realtime_scan";
        }
    }
    return "normal";
}

#FUNCTION:
#    judge if two scalar is the same by ignoring case
#    notice that this function returns "yes/no" instead of boolean
#PARAM:
#    $self
#    $arg1
#    $arg2
#RETURN:
#      yes : they are the same
#      no  : others
sub equalsIgnoreCase(){
    my ($self, $arg1, $arg2) = @_;
    if(!defined $arg1 || !defined $arg2){
        return "no";
    }
    if($arg1 =~ /^\Q$arg2\E$/i){
        return "yes";
    }else{
        return "no";
    };
}

#FUNCTION:
#    judge the final scan mode, according to "virus scan mode" in global section
#    and "no scan" in share section.
#PARAM:
#    $self
#    $noScan
#    $virusScanMode
#RETURN:
#      yes : the final scan mode for current share is active
#      no  : the virus scan for current share is forbidden
sub getFinalAntiVirus(){
    my($self, $noScan, $virusScanMode) = @_;
    defined $noScan or $noScan = "";
    defined $virusScanMode or $virusScanMode = "";
    if($self->equalsIgnoreCase($noScan, "yes") eq "no" && $self->equalsIgnoreCase($virusScanMode, "yes") eq "yes"){
        return "yes";
    }else{
        return "no";
    }
}


#FUNCTION:
#    collect unused interfaces from $allInterfaces
#PARAM:
#    $self
#    $group                : current group number 0|1
#    $allInterfaces        : a string who represents all interfaces (in the form of IP address)
#                            splited by space (' ')
#    $allInterfacesLabel   : a string who represents all interface labels (in the form of IP address(label))
#                            splited by space (' ')
#    $currentInterfaces    : a string who represents all interfaces current export group is using 
#                            splited by space (' ')
#RETURN:
#    when one parameter($group):
#                  return an array contains all unused interfacs in the form of IP address.
#    when three parameters($group, $allInterfaces, allInterfacesLabel):
#                  return an array who has two elements.
#                  The form is the same as ($allInterfaces, $allInterfacesLabel).
#    when four parameters($group, $allInterfaces, allInterfacesLabel, $currentInterfaces):
#                  simular as the case "three parameters", besides following process:
#                  check whether $allInterfaces contains some of the $currentInterfaces.
#                  yes -- add these interfaces and corresponding labels
#                         to remaining interfaces and remaining interfaces(label) separately 
#                         and return them.
#                  no  -- the same as the case "three parameters".
sub getUnusedInterfaces(){
    my $numOfArgs = scalar(@_) - 1;
    my ($self, $group, $allInterfaces, $allInterfacesLabel, $currentInterfaces) = @_;
    if(not defined $allInterfaces){
        ($allInterfaces, $allInterfacesLabel) = &getAllInterfaces($self);
    }
    my @interfaces = split(/\s+/, $allInterfaces);
    my %hashset = &getUsedIpSet($self, $group);
    if(not %hashset){
        if($numOfArgs == 1){
            return @interfaces;
        }else{
            return ($allInterfaces, $allInterfacesLabel);
        }
    }
    my (@tmpInter, $remainingInterfaces);
    foreach (@interfaces){
        my $curInterface = &trimSpace($_);
        if(!exists($hashset{$curInterface})){
            push @tmpInter,$_;
        }
    }
    if($numOfArgs == 1){
        return @tmpInter;
    }
    my (@tmpLabel, $remainingInterfacesLabel);
    my @interfacesLabel = split(/\s+/, $allInterfacesLabel);
    foreach (@interfacesLabel){
        if(/^\D*([\d]{1,3}\.[\d]{1,3}\.[\d]{1,3}\.[\d]{1,3})\s*\(\S+?\).*$/ && !exists($hashset{$1})){
            push @tmpLabel,$_;
        }
    }
    $remainingInterfaces = join(' ', @tmpInter);
    $remainingInterfacesLabel = join(' ', @tmpLabel);
    if($numOfArgs == 3){
        return ($remainingInterfaces, $remainingInterfacesLabel);
    }
    foreach (split(/\s+/, $currentInterfaces)){
	    if((" ".$allInterfaces." ") =~ /\s\Q$_\E\s/){
	        my ($intfclabel) = (" ".$allInterfacesLabel." ") =~ /\s(\Q$_\E\(\S+?\))\s/;
	        last unless defined $intfclabel;
	        $remainingInterfaces = $remainingInterfaces eq "" ? $_ : "${remainingInterfaces} $_";
	        $remainingInterfacesLabel = 
	            $remainingInterfacesLabel eq "" ? $intfclabel : "${remainingInterfacesLabel} $intfclabel";
	    }
	}
	return ($remainingInterfaces, $remainingInterfacesLabel);
}


#FUNCTION:
#    collect used interfaces
#PARAM:
#    $self
#    $group    : current group number 0|1
#RETURN:
#    a hash set who contains all used interfaces (in the form of IP address)
#
sub getUsedIpSet(){
    my ($self, $group) = @_;
    my $vsFile = &getVsFileName($self, $group);
    if(not -f $vsFile){
        return ();
    }
    my @vsContent = `cat ${vsFile} 2>/dev/null`;
    my %tmpSet = ();
    foreach (@vsContent){
        if(/^\s*\/export\/\S+\s+(\S+)\s+(\S+)\s*$/){
            my ($domainName, $computerName) = ($1, $2);
            my $fileName = &getSmbFileName($self, $group, $domainName, $computerName);
            if(!-f $fileName){
                next;
            }
            my $smbContent = &getSmbContent($self, $group, $domainName, $computerName);
            defined($smbContent) or $smbContent = [];
            my $currentInterfaces = $confCommon->getKeyValue("interfaces", "global", $smbContent);
            defined($currentInterfaces) or $currentInterfaces = "";
            $currentInterfaces = &trimSpace($currentInterfaces);
            foreach (split(/\s+/, $currentInterfaces)){
                $tmpSet{$_} = 1;
            }
        }
    }
    return %tmpSet;
}
#Function:
#    get the file permission in Octonary number form
#Arguments:
#    mode String : string mode of file permission
#return:
#    Octonary number String : numeric mode of file permission

sub getNumericPermission() {
    my ( $self, $modeStr ) = @_;
    if ( $modeStr !~ /^[\-r][\-w][\-xsS][\-r][\-w][\-xsS][\-r][\-w][\-xtT]$/ ) {
        return undef;
    }
    my @modeCharArray = split( //, $modeStr );
    my @numArray;
    my $firstNum = 0;
    for ( my $outIndex = 0 ; $outIndex < 3 ; $outIndex++ ) {
        my $tmpInt = 0;
        for ( my $inIndex = 0 ; $inIndex < 3 ; $inIndex++ ) {
            my $longIndex = $outIndex * 3 + $inIndex;
            if ( $modeCharArray[$longIndex] =~ /[rwxst]/ ) {
                $tmpInt = $tmpInt + 2**( 2 - $inIndex );
            }
            if ( $inIndex == 2 ) {
                if ( $modeCharArray[$longIndex] =~ /[stST]/ ) {
                    $firstNum = $firstNum + 2**( 2 - $outIndex );
                }
            }
        }
        $numArray[ $outIndex + 1 ] = $tmpInt;
    }
    $numArray[0] = $firstNum;
    return join( "", @numArray );
}


#Function:
#    check the path is NFS share or not
#Arguments:
#    groupNo: 0 or 1
#    directoryPath : the full the directory path
#    fsType:sxfs or sxfsfw
#    mp:/export/qim/vol
#return:
#    "yes" : is NFS share
#    "no"  : is not NFS share
sub checkNFSShare() {
    my ( $self, $groupNo, $directoryPath, $fsType, $mp) = @_;
    $directoryPath =~ s/\/*$/\//;
    $directoryPath =~ s/\/+/\//g;
    my $nfsCommon     = new NS::NFSCommon;
    my $exFileContent = $nfsCommon->openFile("/etc/group${groupNo}/exports");
    if ( !defined($exFileContent) ) {
        return undef;
    }

    foreach (@$exFileContent) {
        if ( /^\s*$/ || /^\s*#/ ) {
            next;
        }
         if(/^\s*(\S+)\s+/){
            if($1=~/[\200-\377]/){
                next;
            }
        }

        if (/^\s*(\S+)\s+[^\s\(\)]+\(\s*[^\(\)]*\s*\)\s*$/ || 
            /^\s*(\S+)\s+([^\s\(\)]+\([^\(\)]*\)\s+)+[^\s\(\)]+\([^\(\)]*\)\s*$/ ) {
            my $tmpPath=$1."/";
            if($fsType == 1 ){
               if (index($tmpPath,$directoryPath)==0) {
                return "yes";
               }
            } elsif ($fsType == 0){
               if ((index($tmpPath,$mp)==0) && ($tmpPath =~ /^\Q${directoryPath}\E/io)) {
                      return "yes";
                }
            }
        }
    }
    return "no";
}


sub getDirAccessShareSection(){
    my $self = shift;
    my $contentRef = shift;
    my $startIndex = shift;
    my $lines = scalar(@$contentRef);
    my $startShare;
    my $endShare = $lines-1;
    my $shareName;
    my $i;
    my @shareInfoArray = ();
    for($i = $startIndex; $i < $lines; $i++){
        if($$contentRef[$i] =~ /^share:(.+)/){
            my $tmpShareName = $1;
            my $tmpIndex = &getNextValidLineIndex($self,$contentRef, $i+1, $endShare);
            if(!defined($tmpIndex)){
                next;
            }
            if($$contentRef[$tmpIndex] !~ /^dir:(.+)/){
                next;
            }
            $startShare = $i;
            $shareName = $tmpShareName;
            last;
        }
    }
    if($i>=$lines){
        return @shareInfoArray;
    }
    for($i = $startShare+1; $i < $lines; $i++){
        if($$contentRef[$i] =~ /^share:.+/){
            $endShare = $i-1;
            last;
        }
    }
    push(@shareInfoArray,$startShare);
    push(@shareInfoArray,$endShare);
    push(@shareInfoArray,$shareName);
    return @shareInfoArray;
}
sub getDirAccessArray(){
	my $self = shift;
    my $fileContent = shift;
    my $startShare = shift;
    my $endShare = shift;
	my $tmpIndex = $startShare+1;
    my $tmpDir;
    my @dirInfo=();
    
    while(1){
        $tmpIndex = &getNextValidLineIndex($self,$fileContent, $tmpIndex, $endShare);
        if(defined($tmpIndex)){
            if($$fileContent[$tmpIndex]=~/^dir:(.+)/){
                #the line such as [dir:xxxxxxxxxxxxx]
                $tmpDir = $1;
                $tmpIndex = &getNextValidLineIndex($self,$fileContent, $tmpIndex+1, $endShare);
                if(defined($tmpIndex)){
                    if($$fileContent[$tmpIndex]=~/^allow:(.*)/){
                        #the line such as [allow:]
                        $tmpIndex = &getNextValidLineIndex($self,$fileContent, $tmpIndex+1, $endShare);
                        if(defined($tmpIndex)){
                            if($$fileContent[$tmpIndex]=~/^deny:(.*)/){
                                #the line such as [deny:]
                                my $testIndex = &getNextValidLineIndex($self,$fileContent, $tmpIndex+1, $endShare);
                                if(defined($testIndex)){
                                    #the next line is a valid line
                                    if($$fileContent[$testIndex]!~/^dir:/){
                                        #the next line is not a new dir entry
                                        $tmpIndex++;
                                        next;
                                    }
                                }
                                push(@dirInfo,$tmpDir);
                                $tmpIndex++;
                            }else{
                                $tmpIndex++;
                                next;# because can not match "deny" ,find next entry;
                            }
                        }else{
                            last;# can not find new valid line
                        }
                    }else{
                        $tmpIndex++;
                        next;# because can not match "allow" ,find next entry;
                    }
                }else{
                    last; # can not find new valid line
                }
            }else{
                $tmpIndex++;# because can not match "dir" ,find next entry;
                next;
            }
        }else{
            last; #  can not find new valid line
        }
    }

return \@dirInfo;
}

sub compactPath4Win(){
	my $self = shift;
	my $path = shift;
	$path =~ s/[ ]+\//\//g;
    $path =~ s/[ ]+$//g;
    $path =~ s/\/+/\//g;
	return $path;
	
}

use constant GLOBALSECTION => 'global';
sub deleteLogKeyValue(){
    my $content = shift;
    
    my @tmpContent = ();
    foreach(@$content){
        if(/^\s*alog\s+/i){
            next;
        }
        push @tmpContent, $_;
    }
    @$content = @tmpContent;
}

sub initGlobal4ScheduleScan(){
    shift;
    my $smbContent=shift;
    
    my $smbGlobalValueRef=$confCommon->getSectionValue(&GLOBALSECTION, $smbContent); 
    my $tempSchedConf = [];
    if(defined($smbGlobalValueRef)){
        $confCommon->setSectionValue($smbGlobalValueRef, &GLOBALSECTION, $tempSchedConf)
    }else{
        return undef;
    }
    
    &deleteLogKeyValue($tempSchedConf);
    
    my @deleteList = ( "invalid users", "hosts deny", "dir access list file" ); #these keys need be deleted
    foreach my $key (@deleteList){
        $confCommon->deleteKey($key, &GLOBALSECTION, $tempSchedConf);
    }
    if($confCommon->hasKey("oplocks",&GLOBALSECTION, $tempSchedConf)){
        $confCommon->setKeyValue("oplocks","no",&GLOBALSECTION, $tempSchedConf);
    }
    $confCommon->setKeyValue("virus scan mode","no", &GLOBALSECTION, $tempSchedConf);
    
    return $confCommon->getSectionValue(&GLOBALSECTION, $tempSchedConf);
}


#Function:
#    according to the smb.conf(CIFS), update the global section of the shedule scan smb.conf
#Arguments:
#    $smbContent   : reference to the CIFS content array
#    $schedContent : reference to the schedule scan content array
#return:
#    none
sub updateScheduleGlobal(){
    my($self, $smbContent, $schedContent) = @_;
    
    my %SchedSpecialList = ( 'interfaces' => undef, 'valid users' => undef, 'hosts allow' => undef );
    # these keys need be set for schedule scan

    my $newSchedGlobal = &initGlobal4ScheduleScan($self, $smbContent);
    if(!defined($newSchedGlobal)){
        return;
    }
    foreach my $key (keys(%SchedSpecialList)){
        my $value = $confCommon->getKeyValue($key, &GLOBALSECTION, $schedContent);
        $SchedSpecialList{$key} = $value;
    }
    $confCommon->setSectionValue($newSchedGlobal, &GLOBALSECTION, $schedContent);
    foreach my $key (keys(%SchedSpecialList)){
        my $value = $SchedSpecialList{$key};
        if(defined($value) && $value ne ""){
            $confCommon->setKeyValue($key, $value, &GLOBALSECTION, $schedContent);
        }else{
            $confCommon->deleteKey($key, &GLOBALSECTION, $schedContent);
        };
    }
}


#Function:
#    initialize a new SHARE section, 
#Arguments:
#    $smbContent   : reference to the CIFS content array
#    $schedContent : reference to the schedule scan content array
#return:
#    none
sub initShare4ScheduleScan(){
    my ($self, $shareName, $smbContent) = @_;
    
    my $shareSection = $confCommon->getSectionValue($shareName,$smbContent);
    my $tempSchedConf = [];
    if(defined($shareSection)){
        $confCommon->setSectionValue($shareSection, $shareName, $tempSchedConf);
    }else{
        return undef;
    }
    
    &deleteLogKeyValue($tempSchedConf);
    
    my @deleteList = (
        'comment', 'veto files', 'backup exclusive share', 'no scan', 'dir access control', 
        'valid users', 'invalid users', 'hosts allow', 'hosts deny'
    );# these keys need to be deleted
    foreach my $key (@deleteList){
        $confCommon->deleteKey($key, $shareName, $tempSchedConf);
    }
    $confCommon->setKeyValue('oplocks', 'no', $shareName, $tempSchedConf);
    
    return $confCommon->getSectionValue($shareName, $tempSchedConf);
}

#Function:
#    according to the smb.conf(CIFS), update the global section of the shedule scan smb.conf
#Arguments:
#    $smbContent   : reference to the CIFS content array
#    $schedContent : reference to the schedule scan content array
#return:
#    none
sub updateScheduleShareSection(){
    my ($self, $shareName, $smbContent, $schedContent) = @_;

    if($confCommon->hasSection($shareName, $schedContent)){
        my $newSchedShare = &initShare4ScheduleScan($self, $shareName, $smbContent);
        if(!defined($newSchedShare)){
            return;
        }
        $confCommon->setSectionValue($newSchedShare, $shareName, $schedContent);
    }
}

1;