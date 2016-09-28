#!/usr/bin/perl 
#
#       Copyright (c) 2001-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: APICommon.pm,v 1.16 2008/05/09 02:56:22 chenbc Exp $"

package NS::APICommon;
use strict;
use NS::ConstForAPI;
use NS::CIFSCommon;
use NS::CodeConvert;
use NS::NsguiCommon;

sub new(){
     my $this = {};     # Create an anonymous hash, and #self points to it.
     bless $this;         # Connect the hash to the package update.
     return $this;         # Return the reference to the hash.
}
sub error(){
    my $self = shift;
    return $$self{ERROR};
}

my $const       = new NS::ConstForAPI;
my $cifscommon  = new NS::CIFSCommon;
my $comm        = new NS::NsguiCommon;

# Function: get the exportroot and codepage from file /etc/group[0|1]/exgrps.
# Parameter: etcPath such as "/etc/group0/"
# Return: if normal,codepage
#         if error, undef
sub getExportGroupInfo(){
    ### 1.check parameters
    my $self = shift;
    if (@_!=1){
        $$self{ERROR} = join("",("The parameters' number is wrong in perl module:"
                                    ,__FILE__," line:",__LINE__,".\n"));
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
        $$self{ERROR} = join("",("File [${confFile}] can not be opened in perl module:"
                                    ,__FILE__," line:",__LINE__,".\n"));
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
# Function: get mountpoint and lvm from file /etc/group[0|1]/cfstab 
# Parameter: 1.etcPath such as "/etc/group0/"
#            2.hex of mountpoint
# Return: if normal,array(lvm,mp,lvm1,mp1,...)
#         if error, undef
sub getMPAndSubMPInfo(){
    ### 1.check whether parameters from command line is valid
    my $self = shift;
    if(scalar(@_)!=2){
        $$self{ERROR} = join("",("The parameters' number is wrong in perl module:"
                                    ,__FILE__," line:",__LINE__,".\n"));
        return undef;
    }
    ### 2.initialize the variables
    my ($etcPath,$mountpoint)   = @_;
    my $confFile    = "${etcPath}cfstab";
    my @result;
    ### 3.open file and get the mountpoint and LVM
    if(open(CONF,$confFile)){
        foreach(<CONF>){
            if(/^\s*#/ || /^\s*$/){
                next;
            }
            if(/^\s*\/dev\/(\S+)\/\S+\s+(\Q${mountpoint}\E\/\S+|\Q${mountpoint}\E)\s+/){
                push (@result,($1,$2));
            }
        }
        close(CONF);
        return \@result;
    }else{
        $$self{ERROR} = join("",("File [${confFile}] can not be opened in perl module:"
                                    ,__FILE__," line:",__LINE__,".\n"));
        return undef;
    }
}
# Function: get security from file /etc/group[0|1]/nas_cifs/DEFAULT/{ntdomain}/smb.conf.{netbios} 
# Parameter: 1.etcPath such as "/etc/group0/"
#            2.ntdomain string
#            3.netbios string
# Return: if normal,security
#         if error, undef
sub getSecurity(){
    ### 1.check whether parameters from command line is valid
    my $self = shift;
    if(scalar(@_)!=3){
        $$self{ERROR} = join("",("The parameters' number is wrong in perl module:"
                                    ,__FILE__," line:",__LINE__,".\n"));
        return undef;
    }
    ### 2.initialize the variables
    my ($etcPath,$ntdomain,$netbios) = @_;
    my $confFile    = $cifscommon->getSmbOrVsName($etcPath,$const->STRING_DEFAULT,$ntdomain,$netbios,0);
    my ($security,$userSecurity);
    my $globalFlag = 0;
    my $hasGlobalFlag = 0;
    ### 3.open file and get the security
    if(open(CONF,$confFile)){
        my $securityKey = &addSpacke2String($self,$const->STRING_SECURITY);
        my $guiKey = join("\\s*",&addSpacke2String($self,"Made by GUI")
                                ,"\\(",&addSpacke2String($self,"Don't touch this comment"),"\\.","\\)");
        my $interfacesKey = &addSpacke2String($self,"interfaces");
        my $aclKey = &addSpacke2String($self,"nt acl support");
        foreach(<CONF>){
            if(/^\s*$/){
                next;
            }
            if(/^\s*\[\s*global\s*\]\s*$/i){
                $globalFlag = 1;
                next;
            }
            if($globalFlag){    
                if(/^\s*$securityKey\s*=\s*(\S+)\s*$/i){
                    $security = lc($1);
                }
                if(/^\s*#\s*$guiKey\s*$/i
                        ||/^\s*$interfacesKey\s*=\s*(\S+)\s*/i
                        ||/^\s*$aclKey\s*=\s*(\S+)\s*/i){
                    $hasGlobalFlag = 1;
                }    
                if(/^\s*#user\s+database\s+type\s*=\s*(\S+)\s*$/i){
                    $userSecurity = lc($1);
                }
            }
            if($globalFlag && /^\s*\[\s*\S+\s*\]\s*$/i){
                last;
            }
        }
        close(CONF);
        if($security eq $const->STRING_USER){
            return $hasGlobalFlag?$userSecurity:undef;
        }
        return $hasGlobalFlag?$security:undef;
    }else{
        $$self{ERROR} = join("",("File [${confFile}] can not be opened in perl module:"
                                    ,__FILE__," line:",__LINE__,".\n"));
        return undef;
    }
}
# Function: add space sign between each characters 
# Parameter: string that need to be insert space sign like "abc"
# Return: string that has been insert space sign like "a\s*b\s*c"
sub addSpacke2String(){
    my $self = shift;
    if(scalar(@_)!=1){
        $$self{ERROR} = join("",("The parameters' number is wrong in perl module:"
                                    ,__FILE__," line:",__LINE__,".\n"));
        return undef;
    }
    my $inputString = shift;
    my @tmpStrings = split(/\s+/,$inputString);
    if(scalar(@tmpStrings)>1){
        my @result;
        foreach(@tmpStrings){
            push(@result,join("\\s*",split(//,$_)));
        }
        return join("\\s*",@result);    
    }
    return join("\\s*",split(//,$inputString));
}
# Function: get domain and server from file /etc/yp.conf 
# Parameter: none
# Return: if normal,server string like "server1 server2 ..."
#         if error, undef
sub getNisDomainServer(){
    ### 1.check whether parameters from command line is valid
    my $self = shift;
    if(scalar(@_)!=0){
        $$self{ERROR} = join("",("The parameters' number is wrong in perl module:"
                                    ,__FILE__," line:",__LINE__,".\n"));
        return undef;
    }
    ### 2.initialize the variables
    my (@fileContent,%result);
    ### 3.open the file
    if(open(CONF,$const->YP_CONF_FILE)){
        @fileContent = <CONF>;
    }else{
        $$self{ERROR} = join("",("File [",$const->YP_CONF_FILE,"] can not be opened in perl module:"
                                    ,__FILE__," line:",__LINE__,".\n"));
        return undef;
    }
    ### 4.loop for the file and find domain and servers
    foreach(@fileContent){
        if(/^\s*#/ || /^\s*$/ || /#\s*FTP\s*-/i){
            next;
        }
        if(/^\s*domain\s+(\S+)\s+server\s+(\S+)\s*/){
            if(defined($result{$1})){
                $result{$1} = $result{$1}." $2";
            }else{
                $result{$1} = $2;
            }
        }
    }
    close(CONF);
    return \%result;
}
# Function: get NTdomain and netbios from file /etc/group[0|1]/nas_cifs/DEFAULT/virtual_servers 
# Parameter: etcPath such as "/etc/group0/"
# Return: if normal,Hash(key--exportgroup value--Hash(key--ntdomain,value--netbios))
#         if error, undef
sub getALLLocalDomainAndNetbios(){
    ### 1.check whether parameters from command line is valid
    my $self = shift;
    if(scalar(@_)!=1){
        $$self{ERROR} = join("",("The parameters' number is wrong in perl module:"
                                    ,__FILE__," line:",__LINE__,".\n"));
        return undef;
    }
    ### 2.initialize the variables
    my $etcPath = shift;
    my $confFile = $cifscommon->getSmbOrVsName($etcPath,$const->STRING_DEFAULT,0);
    my %result;
    ### 3.open file and get the domain and server
    if(!(-f $confFile)){
        return \%result;
    }
    if(open(CONF,$confFile)){
        my @fileContent = <CONF>;
        my $vsContent = $comm->getVSContent(\@fileContent);
        foreach(@$vsContent){
            if(/^\s*#/ || /^\s*$/){
                next;
            }
            if(/^\s*(\S+)\s+(\S+)\s+(.+)\s*$/){
                $result{$1} = [$2,$3];
            }elsif(/^\s*(\S+)\s+(\S+)\s*$/){
                $result{$1} = [$2,""];
            }
        }
        close(CONF);
        return \%result;
    }else{
        $$self{ERROR} = join("",("File can not be opened in perl module:"
                                    ,__FILE__," line:",__LINE__,".\n"));
        return undef;
    }
}
# Function: get smbpasswd file's path 
# Parameter: 1.etcPath such as "/etc/group0/"
#            2.NTDomain string
#            3.Netbios string
# Return: if normal,smbpasswd path string or ""
#         if error, undef
sub getSmbpasswdPath(){
    ### 1.check whether parameters from command line is valid
    my $self = shift;
    if(scalar(@_)!=3){
        $$self{ERROR} = join("",("The parameters' number is wrong in perl module:"
                                    ,__FILE__," line:",__LINE__,".\n"));
        return undef;
    }
    my ($etcPath,$ntdomain,$netbios) = @_;
    my $globalFlag = 0;
    if(open(CONF,$cifscommon->getSmbOrVsName($etcPath,$const->STRING_DEFAULT,$ntdomain,$netbios,0))){
        my $key = &addSpacke2String($self,$const->STRING_SMB_PASSWD_FILE);
        foreach(<CONF>){
            if(/^\s*#/ || /^\s*$/){
                next;
            }
            if(/^\s*\[\s*global\s*\]\s*$/i){
                $globalFlag = 1;
                next;
            }
            if($globalFlag){    
                if(/^\s*(?i:${key})\s*=\s*%r\/%D\/smbpasswd\s*$/){
                    return "${etcPath}nas_cifs/DEFAULT/${ntdomain}/smbpasswd";
                }elsif(/^\s*(?i:${key})\s*=\s*%r\/%D\/smbpasswd\.%L\s*$/){
                    return "${etcPath}nas_cifs/DEFAULT/${ntdomain}/smbpasswd.${netbios}";
                }
            }
            if($globalFlag && /^\s*\[\s*\S+\s*\]\s*$/i){
                last;
            }
        }
        close(CONF);
        return "";
    }else{
        $$self{ERROR} = join("",("File can not be opened in perl module:"
                                    ,__FILE__," line:",__LINE__,".\n"));
        return undef;
    }
}


#Wrote by hetao start:
# Function: run ims_Auth command , and get the result in to Hash        
# parameters:                                                                           
#           $grpPath    -   the group path like /etc/group[0|1]/        
# return:                                                               
#           reference of result hash which contains output of command   
#           key     -   mount point                                     
#           value   -   region                                          
sub getImsAuthResult(){
    #check whether parameters from command line is valid
    my $self            = shift; 
    if(scalar(@_) != 1){
        $$self{ERROR} = join("",("The parameters' number is wrong in perl module:"
                                    ,__FILE__," line:",__LINE__,".\n"));
        return undef;
    }
    
    #get the group path:
    my $grpPath         = shift;
    my $imsAuthCmd      = $const->IMS_AUTH_CMD.$grpPath.$const->IMS_FILE; 
                            #IMS_AUTH_CMD  = "ims_auth -Lv -c "
                            #IMS_FILE      = "ims.conf"
    my @result          =`$imsAuthCmd`;
    if( $? ){
        $$self{ERROR} = join("",("run ims_auth command error in perl module:"
                                    ,__FILE__," line:",__LINE__,".\n"));
        return undef;
    } 
    shift(@result);
    pop(@result);
    my %authHash;
    foreach(@result){
        if(/^(\S+)\s+(\S+)\s*$/){   
                            #match all like "/export/nas/katou nis:nas-0";
            $authHash{$1} = $2;
        }
    }
    
    return \%authHash;   
}
# Function: run ims_Native command , and get the result in to Hash      
# parameters:                                                                           
#           $grpPath    -   the group path like /etc/group[0|1]/        
# return:                                                               
#           reference of result hash which contains output of command   
#           key         -   "win" | "unix"                              
#           value       -   reference of sub hash                       
#           subkey      -   network or ntdomain                         
#           subvalue    -   region                                      
sub getImsNativeResult(){
    #check whether parameters from command line is valid
    my $self            = shift; 
    if(scalar(@_) != 1){
        $$self{ERROR} = join("",("The parameters' number is wrong in perl module:"
                                    ,__FILE__," line:",__LINE__,".\n"));
        return undef;
    }
    #get the group path:
    my $grpPath         = shift;
    my $imsNativeCmd    = $const->IMS_NATIVE_CMD.$grpPath.$const->IMS_FILE; 
                            #IMS_NATIVE_CMD    = "ims_native -Lv -c "
                            #IMS_FILE          = "ims.conf"
    my @result          =`$imsNativeCmd`;
    if( $? ){
        $$self{ERROR} = join("",("run ims_native command error in perl module:"
                                    ,__FILE__," line:",__LINE__,".\n"));
        return undef;
    } 
    shift(@result);
    pop(@result);
    my (%nativeHash, %unixNativeHash, %winNativeHash);
    foreach(@result){
        if(/^NS=(\S+)\/\s+(\S+)\s*$/){
            $winNativeHash{$1} = $2;
        }elsif(/^NS=\/(\S*)\s+(\S+)\s*$/){
            my $network;
            if(!defined($1) || $1 eq ""){
                $network = "*";
            }else{
                $network = $1;
            }
            my $region = $2;
            if($network =~ /^\s*\d+\.\d+\.\d+\.\d+\s*$/ || $network eq "*"){
                $unixNativeHash{$network} = $region;
            }else{
                $unixNativeHash{$network."."} = $region;
            }
        }
    }
    $nativeHash{"win"}  = \%winNativeHash;
    $nativeHash{"unix"} = \%unixNativeHash;
    return \%nativeHash;
}
# Function: run ims_Domain command , and get the result in to Hash      
# parameters:                                                                           
#           $grpPath    -   the group path like /etc/group[0|1]/        
# return:                                                               
#           reference of result hash which contains output of command   
#           key         -   "win" | "unix" | "both"                     
#           value       -   reference of sub hash                       
#           subkey      -   region                                      
#           subvalue    -   reference of sub array                      
#           subarray    -   attribute array                             
sub getImsDomainResult(){
    #check whether parameters from command line is valid
    my $self            = shift; 
    if(scalar(@_) != 1){
        $$self{ERROR} = join("",("The parameters' number is wrong in perl module:"
                                    ,__FILE__," line:",__LINE__,".\n"));
        return undef;
    }
    #get the group path:
    my $grpPath         = shift;
    my $imsDomainCmd    = $const->IMS_DOMAIN_CMD.$grpPath.$const->IMS_FILE; 
                            #IMS_DOMAIN_CMD    = "ims_domain -Lv -c "
                            #IMS_FILE          = "ims.conf"
    my @result          =`$imsDomainCmd`;
    if( $? ){
        $$self{ERROR} = join("",("run ims_domain command error in perl module:"
                                    ,__FILE__," line:",__LINE__,".\n"));
        return undef;
    }
    
    #get the region type hash
    my $regionTypeRef = &getKindOfDomainRegions($self, $grpPath);
    if(!defined($regionTypeRef)){
        return undef;
    }
    
    shift(@result);
    pop(@result);
    my (%winHash, %unixHash, %bothHash, %resultHash);
    foreach(@result){
	 my @element    = split(/\s+/,$_);
	 my $region     = $element[0];
         my @attr;
	 my $j          = -1;
	 my $size       = scalar(@element);
	 if($size > 1 && ($element[1] eq "-" || $element[1] eq "+" || $element[1] eq "*")){
	       next;
	 }
	 for(my $i = 1; $i < $size; $i++){
	    if($element[$i] =~ /^\S+=(\S*)/){
	        $j++;
		$attr[$j]   = $1;
	    }else{
		$attr[$j]   = join(" ",$attr[$j],$element[$i]);
	    }
	} 
	if( $region =~ /^shr/ || $region =~ /^dmc/ || $region =~ /^ads/ ){
	    $bothHash{$region} = \@attr;
	}elsif(defined($$regionTypeRef{$region})){
            if($$regionTypeRef{$region} eq "win"){
        	$winHash{$region}  = \@attr;
    	    }else{
    	        $unixHash{$region} = \@attr;
    	    }
    	}
    }
    $resultHash{"win"}  = \%winHash;
    $resultHash{"unix"} = \%unixHash;
    $resultHash{"both"} = \%bothHash;
    return \%resultHash;
}

#added by hetao @2004-01-09 start:
sub getImsNativeResultByOptype(){
    my $self            = shift; 
    if(scalar(@_) != 2){
        $$self{ERROR} = join("",("The parameters' number is wrong in perl module:"
                                    ,__FILE__," line:",__LINE__,".\n"));
        return undef;
    }
    #get the group path:
    my $grpPath         = shift;
    my $kind            = shift;
    my $hash2hash       = &getImsNativeResult($self,$grpPath);
    if(!defined($hash2hash)){
        $$self{ERROR} = join("",("Can't get ims native result in perl module:"
                                    ,__FILE__," line:",__LINE__,".\n"));
        return undef;
    }
    return $$hash2hash{$kind};
}
#added by hetao @2004-01-09 end;

#added by hetao @2003-12-28 start
sub getNativeRegionType(){
    my $self            = shift; 
    if(scalar(@_) != 1){
        $$self{ERROR} = join("",("The parameters' number is wrong in perl module:"
                                    ,__FILE__," line:",__LINE__,".\n"));
        return undef;
    }
    #get the group path:
    my $grpPath         = shift;
    my $nativeRetRef    = &getImsNativeResult($self, $grpPath);
    if(!defined($nativeRetRef)){
        return undef;
    }
    my %regionHash;
    my @nativeKinds     = keys(%$nativeRetRef);
    foreach(@nativeKinds){
        my %ntDomainHash   = %{$$nativeRetRef{$_}};
        my @ntDomainOrNetworks   = keys(%ntDomainHash);
        for(my $i = 0; $i < @ntDomainOrNetworks; $i++){
            $regionHash{$ntDomainHash{$ntDomainOrNetworks[$i]}}=[$ntDomainOrNetworks[$i],$_];
        }
    }
    return \%regionHash;
    
}
sub getImsNativeDomainResult(){
    my $self            = shift; 
    if(scalar(@_) != 1){
        $$self{ERROR} = join("",("The parameters' number is wrong in perl module:"
                                    ,__FILE__," line:",__LINE__,".\n"));
        return undef;
    }
    #get the group path:
    my $grpPath         = shift;
    my (%result,%winHash,%unixHash,%bothHash);
    my $domainRetRef    = &getImsDomainResult($self, $grpPath); 
    my $nativeRetRef    = &getNativeRegionType($self, $grpPath);
    if(!defined($nativeRetRef)||!defined($domainRetRef)){
        return undef;
    }
    my @domainKinds     = keys(%$domainRetRef);
    foreach(@domainKinds){
        my %domainHash     = %{$$domainRetRef{$_}};
        my @regions        = keys(%domainHash);
        for(my $i = 0 ;$i < @regions; $i++){
            my $ntdomainAndTypeRef = $$nativeRetRef{$regions[$i]};
            if(!defined($ntdomainAndTypeRef)){
                next;
            }
            my @ntdomainAndType    = @{$ntdomainAndTypeRef};   
            if($_ ne "both"){
                if($ntdomainAndType[1] eq "win"){
                    $winHash{$regions[$i]} = $domainHash{$regions[$i]};
                }else{
                    $unixHash{$regions[$i]} = $domainHash{$regions[$i]};
                }
            }else{
               $bothHash{$regions[$i]} = $domainHash{$regions[$i]};
            }
        }
    }
    $result{"both"} = \%bothHash;
    $result{"win"} = \%winHash;
    $result{"unix"} = \%unixHash;
    return \%result;
}
#added by hetao @2003-12-28 end

# Function: change "hash->\hash" to "hash"                              
# parameters:                                                                           
#           $hashRef    -   the reference of "hash->\hash"              
# return:                                                               
#           reference of hash                                           
#           key         -   key of sub "hash->\hash"                    
#           value       -   value of sub "hash->\hash"                  
sub changeImsResult(){
    #check whether parameters from command line is valid
    my $self            = shift; 
    if(scalar(@_) != 1){
        $$self{ERROR} = join("",("The parameters' number is wrong in perl module:"
                                    ,__FILE__," line:",__LINE__,".\n"));
        return undef;
    }
    #get the group path:
    my $hashRef         = shift;
    my @typeKeys        = keys(%$hashRef);
    my @retArr;
    foreach(@typeKeys){
        my @tmpArr     = %{$$hashRef{$_}};
        push(@retArr,@tmpArr);
    }
    my %resultHash = @retArr;
    return \%resultHash;
}
# Function: run ims_native command and get the result hash              
# parameters:   none                                                                           
# return:                                                               
#           reference of hash                                           
#           key         -   network or ntdomain                         
#           value       -   region                                      
sub changeImsNativeResult(){
    #check whether parameters from command line is valid
    my $self            = shift; 
    if(scalar(@_) != 1){
        $$self{ERROR} = join("",("The parameters' number is wrong in perl module:"
                                    ,__FILE__," line:",__LINE__,".\n"));
        return undef;
    }
    my $grpPath         = shift;
    #run the command and get "hash->\hash" format result
    my $hash2hash       = &getImsNativeResult($self,$grpPath);
    if(!defined($hash2hash)){
        $$self{ERROR} = join("",("Can't get ims native result in perl module:"
                                    ,__FILE__," line:",__LINE__,".\n"));
        return undef;
    }
    #convert the "hash->\hash" format to hash format;
    return &changeImsResult($self,$hash2hash);
}

# Function: run ims_domain command and get the result hash              
# parameters:   none                                                                        
# return:                                                               
#           reference of hash                                           
#           key         -   region                                      
#           value       -   reference of attributes array               
sub changeImsDomainResult(){
    #check whether parameters from command line is valid
    my $self            = shift; 
    if(scalar(@_) != 1){
        $$self{ERROR} = join("",("The parameters' number is wrong in perl module:"
                                    ,__FILE__," line:",__LINE__,".\n"));
        return undef;
    }
    my $grpPath         = shift;
    #run the command and get "hash->\hash" format result
    my $hash2hash       = &getImsDomainResult($self,$grpPath);
    if(!defined($hash2hash)){
        $$self{ERROR} = join("",("Can't get ims domain result in perl module:"
                                    ,__FILE__," line:",__LINE__,".\n"));
        return undef;
    }
    #convert the "hash->\hash" format to hash format;
    return &changeImsResult($self,$hash2hash);
}
#Wrote by hetao end;

#liuhy add 
#Funtion:      set native domain info for specified ntdomain/network or all ntdomain/network getton from ims_native
#Parameters
    #EtcGroupPath	
    #NTDomainOrNetwork: may be ignored
#Returns:
    #succeed  
         #Hash key = kind value=native information hash(key = region,value = other info array's reference)
         #for example: %resultHash = {"NISDomain"=>{"nis:.0-0"=>["/etc/group","/etc/passwd"]}}
    #undef if failed
sub fillNativeDomainInfo(){
    my $self = shift;
    my $paramLen = @_;
    if($paramLen != 2 && $paramLen != 3){
        $$self{ERROR} = "The number of parameters is wrong";
        return undef;
    }
    my ($EtcGroupPath,$kind,$NTDomainOrNetwork) = @_;
    my $nativeRetRef = &getImsNativeResultByOptype($self,$EtcGroupPath,$kind);
    if(!defined($nativeRetRef)){
        return undef;
    }
    my %nativeRet = %{$nativeRetRef};
    my @NTDomainOrNetworkArr = keys(%nativeRet);
    if(scalar(@NTDomainOrNetworkArr) == 0 
        || (defined($NTDomainOrNetwork)&&!defined($nativeRet{$NTDomainOrNetwork}))){
        return {};
    }
    if(defined($NTDomainOrNetwork)){
        @NTDomainOrNetworkArr = ($NTDomainOrNetwork);
    }
    my $nativeInfoHashRef = &ClassifyDomainFilterAttr($self,$EtcGroupPath,"native");
    if(!defined($nativeInfoHashRef)){
        return undef;
    }
    my %nativeInfoHash = %{$nativeInfoHashRef};
    my @kinds = keys(%nativeInfoHash);
    if(scalar(@kinds) == 0){
        return {};
    }
    my %resultHash;
    foreach(@NTDomainOrNetworkArr){
        OUTER: for(my $i = 0; $i < @kinds; $i++){
            my @regions = keys(%{$nativeInfoHash{$kinds[$i]}});
            for(my $j = 0; $j < @regions; $j++){
                if(!defined($nativeRet{$_})){
                    last OUTER;
                }
                if($regions[$j] eq $nativeRet{$_}){
                    $resultHash{$kinds[$i]}{$regions[$j]} = $nativeInfoHash{$kinds[$i]}{$regions[$j]};
                    delete($nativeInfoHash{$kinds[$i]}{$regions[$j]});
                    if($kinds[$i] eq "ADSDomain"){
                        my @NTDomainName = split(/\+/,$_);
                        my $path = $EtcGroupPath."nas_cifs/DEFAULT/".$NTDomainName[0]."/";
                        unshift(@{$resultHash{$kinds[$i]}{$regions[$j]}},$_,@{&getAdsDomainAndServer($self,$path)});
                    }else{
                        unshift(@{$resultHash{$kinds[$i]}{$regions[$j]}},$_);
                    }
                    last OUTER;
                }
            }    
        }            
    }
    return \%resultHash;
    
}

#Funtion:      set auth domain info for specified mountpoint
#Parameters
    #EtcGroupPath	
    #mpArrRef:   mountpoint array's reference
#Returns:
    #succeed  
         #Hash key = kind value=auth information hash(key = region,value = other info array's reference)
         #for example: %resultHash = {"NISDomain"=>{"nis:eucgroup-0"=>["/etc/group","/etc/passwd"]}}
    #undef if failed
sub fillAuthDomainInfoByMp(){
    my $self = shift;
    if(scalar(@_) != 2){
        $$self{ERROR} = "The number of parameters is wrong";
        return undef;
    }
    my ($EtcGroupPath,$mpArrRef) = @_;
    #get result of command "ims_auth"
    my $authRetRef = &getImsAuthResult($self,$EtcGroupPath);
    if(!defined($authRetRef)){
        return undef;
    }
    my %authRet = %{$authRetRef};
    if(scalar(keys(%authRet)) == 0){
        return {};
    }
    #make hash key = mp,value= exportGroup
    my %mpExGrpHash; #key = mp,value= exportGroup
    foreach(@$mpArrRef){
        my @exportPart = split(/\//,$_);
        $mpExGrpHash{$_} = "/$exportPart[1]/$exportPart[2]";
    }
    #get auth info from ims_domain
    my $authInfoHashRef = &ClassifyDomainFilterAttr($self,$EtcGroupPath,"auth");
    if(!defined($authInfoHashRef)){
        return undef;   
    }
    my %authInfoHash = %{$authInfoHashRef};
    if(scalar(keys(%authInfoHash)) == 0){
        return {};
    }
    #get all localdomain  and netbios information
    my $localDomainNetbiosInfoRef = &getALLLocalDomainAndNetbios($self,$EtcGroupPath);
    if(!defined($localDomainNetbiosInfoRef)){
        return undef;   
    }
    my %localDomainNetbiosInfo = %{$localDomainNetbiosInfoRef};
    my %resultHash;
    my @kinds = keys(%authInfoHash);
    my $codeConvert = new NS::CodeConvert();
    foreach(@$mpArrRef){
        OUTER:for(my $i = 0; $i < @kinds; $i++){
            my @regions = keys(%{$authInfoHash{$kinds[$i]}});
            for(my $j = 0; $j < @regions; $j++){
                if(!defined($authRet{$_})){
                    last OUTER;
                }
                if($authRet{$_} eq $regions[$j]){
                    my @tmpInfo = @{$authInfoHash{$kinds[$i]}{$regions[$j]}};
                    my $localDomainNetbios = $localDomainNetbiosInfo{$mpExGrpHash{$_}};
                    my $NTDomain = $$localDomainNetbios[0];
                    if(!defined($NTDomain)){
                        $NTDomain = "";
                    }elsif($$localDomainNetbios[1] ne ""){
                        $NTDomain .= "+$$localDomainNetbios[1]";       
                    }
                    if($kinds[$i] eq "SHRDomain"){
                        my $path = &getSmbpasswdPath($self,$EtcGroupPath,$$localDomainNetbios[0],$$localDomainNetbios[1]);  
                        push(@{$resultHash{$kinds[$i]}},$regions[$j],
                            $codeConvert->str2hex($_), $NTDomain,$path,@tmpInfo);
                    }elsif($kinds[$i] eq "ADSDomain"){
                        my @NTDomainName = split(/\+/,$NTDomain);
                        my $path = $EtcGroupPath."nas_cifs/DEFAULT/".$NTDomainName[0]."/";
                        push(@{$resultHash{$kinds[$i]}},$regions[$j],
                            $codeConvert->str2hex($_), $NTDomain,@{&getAdsDomainAndServer($self,$path)},@tmpInfo);
                    }else{
                        push(@{$resultHash{$kinds[$i]}},$regions[$j],
                               $codeConvert->str2hex($_), $NTDomain,@tmpInfo);
                    }
                    last OUTER;
                }   #end of if 
            }#end of for
        }#end of for            
    }
    return \%resultHash;
}

#Funtion:      set auth domain info for exportgroup and kind and return
#Parameters
    #EtcGroupPath	
    #exportGroup
    #kind: 
#Returns:
    #succeed:
        #1.Specified kind's info is not found: return ""
        #2.found
         #Hash key = kind value=auth information hash(key = region,value = other info array's reference)
         #for example: %resultHash = {"NISDomain"=>{"nis:eucgroup-0"=>["/etc/group","/etc/passwd"]}}
    #failed: undef
sub fillAuthDomainInfoByExGrpKind(){
    my $self = shift;
    if(scalar(@_) != 3){
        $$self{ERROR} = "The number of parameters is wrong";
        return undef;
    }
    my ($EtcGroupPath, $exportGroup, $kind) = @_;
    
    #get suffix of exportGroup
    my @exportPart = split(/\//,$exportGroup);
    my $ExGrpSuffix = $exportPart[2];
    
    #get auth info from ims_domain
    my $authInfoHashRef= &ClassifyDomainFilterAttr($self,$EtcGroupPath,"auth");
    if(!defined($authInfoHashRef)){
        return undef;
    }
    my %authInfoHash = %{$authInfoHashRef};
    if(scalar(keys(%authInfoHash)) ==0 || !defined($authInfoHash{$kind})){
        return "";
    }
    #get all localdomain  and netbios information
    my %resultHash;
    my $localDomainNetbiosInfoRef = &getALLLocalDomainAndNetbios($self,$EtcGroupPath);
    if(!defined($localDomainNetbiosInfoRef)){
        return undef;
    }
    my %localDomainNetbiosInfo= %{$localDomainNetbiosInfoRef};
    my @regions = keys(%{$authInfoHash{$kind}});
    foreach(@regions){
        if(/^\s*[^:]+:${ExGrpSuffix}-\d+\s*$/){
            $resultHash{$kind}{$_}=$authInfoHash{$kind}{$_};
            my $localDomainNetbios = $localDomainNetbiosInfo{$exportGroup};
            my $NTDomain = $$localDomainNetbios[0]; 
            if(!defined($NTDomain)){
                $NTDomain = "";
            }elsif($$localDomainNetbios[1] ne ""){
                $NTDomain .= "+$$localDomainNetbios[1]";       
            } 
            if($kind eq "SHRDomain"){
                my $path = &getSmbpasswdPath($self,$EtcGroupPath,$$localDomainNetbios[0],$$localDomainNetbios[1]);   
                unshift(@{$resultHash{$kind}{$_}},"", $NTDomain,$path);
            }elsif($kind eq "ADSDomain"){
                my @NTDomainName = split(/\+/,$NTDomain);
                if($NTDomain eq ""){
                    $NTDomainName[0] = "";
                }
                my $path = $EtcGroupPath."nas_cifs/DEFAULT/".$NTDomainName[0]."/";
                unshift(@{$resultHash{$kind}{$_}},"", $NTDomain,@{&getAdsDomainAndServer($self,$path)});
            }else{
                unshift(@{$resultHash{$kind}{$_}},"", $NTDomain);
            }
        }
    }
    return \%resultHash;
}

#Funtion:    set domain info for all kind(filter useless attribute,set necessary attribute)
#Parameters
    #EtcGroupPath
    #getNativeOrAuth: sign whether get native info or auth info
#Returns:
    #succeed  
         #reference of result hash(key=kind,value=hash--key=region,value=info)
    #undef if failed
sub ClassifyDomainFilterAttr(){
    my $self = shift;
    if(scalar(@_) !=2 ){
        $$self{ERROR} = "The number of parameters is wrong.";
        return undef;
    }
    my ($EtcGroupPath,$getNativeOrAuth) = @_;
    my $imsDomainRetRef;
    if($getNativeOrAuth eq "native"){
        $imsDomainRetRef = &getImsNativeDomainResult($self,$EtcGroupPath); 
    }else{
        $imsDomainRetRef = &getImsDomainResult($self,$EtcGroupPath);
    }
    if(!defined($imsDomainRetRef)){
        return undef;
    }
    my (%infoHash,$shrRegionPrefix, $dmcRegionPrefix,$adsRegionPrefix);
    if($getNativeOrAuth eq "native"){
        $shrRegionPrefix = "shr:\\.";  #$kind eq "NativeSHRDomain" 
        $dmcRegionPrefix = "dmc:\\.";  #$kind eq "NativeDMCDomain"
        $adsRegionPrefix = "ads:\\.";  #$kind eq "NativeDMCDomain"
    }else{
        $shrRegionPrefix = "shr:[^\\.]";  #$kind eq "AuthSHRDomain" 
        $dmcRegionPrefix = "dmc:[^\\.]";  #$kind eq "AuthDMCDomain"
        $adsRegionPrefix = "ads:[^\\.]";  #$kind eq "NativeDMCDomain"
    }
    my $domainRetHashRef = $$imsDomainRetRef{"both"};
    if(defined($domainRetHashRef) && scalar(keys(%$domainRetHashRef)) > 0){
        my @regions = keys(%$domainRetHashRef);
        foreach(@regions){
            if(/^\s*${shrRegionPrefix}/){
                if(($getNativeOrAuth eq "native") && /^\s*${shrRegionPrefix}(httpd|ftp)/){
                }else{
                    $infoHash{"SHRDomain"}{$_} = [];   
                }
             }elsif(/^\s*${dmcRegionPrefix}/){
                    $infoHash{"DMCDomain"}{$_} = []; 
             }elsif(/^\s*${adsRegionPrefix}/){
                    $infoHash{"ADSDomain"}{$_} = []; 
             }
        }
    }
    $domainRetHashRef = $$imsDomainRetRef{"win"};
    if(defined($domainRetHashRef) && scalar(keys(%$domainRetHashRef)) > 0){
        &setWinUnixDomainInfo($self,"4Win",$domainRetHashRef,\%infoHash,$getNativeOrAuth);
    }
    $domainRetHashRef = $$imsDomainRetRef{"unix"};
    if(defined($domainRetHashRef) && scalar(keys(%$domainRetHashRef)) > 0){
        &setWinUnixDomainInfo($self,"",$domainRetHashRef,\%infoHash,$getNativeOrAuth);
    }
    return(\%infoHash);
}

#Funtion:   set domain info for PWD,NIS,LDUP(filter useless attribute,set necessary attribute)
#Parameters
    #fsSign: "4Win" or ""	
    #domainRetHashRef:reference of ims_domain's result hash
    #infoHashRef:     reference of result hash(key=kind,value=hash--key=region,value=info)
    #getNativeOrAuth: sign whether get native info or auth info. value:native/auth
#Returns:
    #succeed  
    #undef if failed
sub setWinUnixDomainInfo(){
    my $self = shift;
    if(scalar(@_) != 4){
        $$self{ERROR} = "The number of parameters is wrong.";
        return undef;
    }
    my ($fsSign, $domainRetHashRef, $infoHashRef,$getNativeOrAuth) = @_;
    my $nisInfo = &getNisDomainServer($self);
    if(!defined($nisInfo)){
        return undef;
    }
    my ($nisRegionPrefix, $pwdRegionPrefix, $lduRegionPrefix);
    if($getNativeOrAuth eq "native"){
        $nisRegionPrefix = "nis:\\.";  #$kind eq "NativeNISDomain" or "NativeNISDomain4Win"
        $pwdRegionPrefix = "pwd:\\.";  #$kind eq "NativePWDDomain" or "NativePWDDomain4Win"
        $lduRegionPrefix = "ldu:\\.";  #$kind eq "NativeLDAPUDomain" or "NativeLDAPUDomain4Win"
    }else{
        $nisRegionPrefix = "nis:[^\\.]";  #$kind eq "AuthNISDomain" or "AuthNISDomain4Win"
        $pwdRegionPrefix = "pwd:[^\\.]";  #$kind eq "AuthPWDDomain" or "AuthPWDDomain4Win"
        $lduRegionPrefix = "ldu:[^\\.]";  #$kind eq "AuthLDAPUDomain" or "AuthLDAPUDomain4Win"
    }
    my %domainRetHash = %$domainRetHashRef;
    my @regions = keys(%domainRetHash);
    foreach(@regions){
        if(/^\s*${nisRegionPrefix}/){
            my $nisDomain = ${$domainRetHash{$_}}[0];
            my $nisServer = $$nisInfo{$nisDomain};
            $$infoHashRef{"NISDomain${fsSign}"}{$_} = [$nisDomain,$nisServer];   
         }elsif(/^\s*${pwdRegionPrefix}/){
            $$infoHashRef{"PWDDomain${fsSign}"}{$_} = [${$domainRetHash{$_}}[0],${$domainRetHash{$_}}[1]]; 
         }elsif(/^\s*${lduRegionPrefix}/){
            $$infoHashRef{"LDAPUDomain${fsSign}"}{$_} = []; 
         }
    }
}

#Funtion: print out domain info
#Parameters
    #infoHashRef:     reference of result hash(key=kind,value=hash--key=region,value=info)
    #kind: 
#Returns:
    #succeed  
    #undef if failed
sub printDomainInfo(){
    my $self = shift;
    if(scalar(@_) != 2){
        $$self{ERROR} = "The number of parameters is wrong.";
        return undef;
    }
    my ($infoHashRef, $kind) = @_;
    my %infoHash = %{$infoHashRef};
    print "[$kind]\n";
    my @regions = keys(%{$infoHash{$kind}});
    for(my $i = 0; $i < @regions; $i++){
        print "${regions[$i]}\n";
        my @infos = @{$infoHash{$kind}{$regions[$i]}};
        for(my $j = 0; $j < @infos; $j++){
            print "${infos[$j]}\n";
        }
    }
}



#added by hetao start:
#function: divide the region into unix and windows
#parameters:
    #grouppath 
#return:
    #succeed  
         #reference of result hash(key=region,value=kind--"win"|"unix")
    #undef if failed
sub getKindOfDomainRegions(){
    #check whether parameters from command line is valid
    my $self            = shift; 
    if(scalar(@_) != 1){
        $$self{ERROR} = join("",("The parameters' number is wrong in perl module:"
                                    ,__FILE__," line:",__LINE__,".\n"));
        return undef;
    }
    #get the group path;
    my $grpPath         = shift;
    my $imsFilePath     = $grpPath.$const->IMS_FILE;
    my @fileContent;
    if(open(CONF,$imsFilePath)){
        @fileContent = <CONF>;
        close(CONF);
    }else{
        $$self{ERROR} = join("",("File [",$imsFilePath,"] can not be opened in perl module:"
                                    ,__FILE__," line:",__LINE__,".\n"));
        return undef;
    }
    my %regionHash;
    foreach(@fileContent){
        if(/^\s*#/ || /^\s*$/){
            next;
        }
        if(/^\s*d\s+(\S+)\s+/){
            my $region = $1;
            if(/\s+\-o\s+sidprefix=S(-\d+)+\s*(#[^#]*)?$/){
                $regionHash{$region} = "win";
            }else{
                $regionHash{$region} = "unix";
            }
        }
    }
    return \%regionHash;
}

sub getAdsDomainAndServer(){
    my $self = shift;
    use NS::MAPDCommon;

    if(scalar(@_)!=1){
        print STDERR "The parameters' number of perl script(",__FILE__,") is wrong!\n";
        return ["",""];
    }
    my $path = shift;
    my $MC = new NS::MAPDCommon;
    my ($dnsDomain, $kdcServer) = $MC->getADSConf($path);
    if (defined($dnsDomain) && defined($kdcServer)) {
        return [$dnsDomain,$kdcServer];
    }
    return ["",""];
}

1;                