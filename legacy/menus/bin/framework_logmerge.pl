#! /usr/bin/perl
#
#       Copyright (c) 2001-2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#
# Function:  
#           merge the same type log files to a single 
#           file that is to be the object of command 
#           logrotate.
#
# Parameter: 
#       none;
#
# return value: 
#       0: the log files has been successfully merged.
# "@(#) $Id: framework_logmerge.pl,v 1.2304 2006/11/30 05:47:59 xingh Exp $"
if (!(-t 0)){
    $SIG{"INT"}="IGNORE";
    $SIG{"HUP"}="IGNORE";
    $SIG{"QUIT"}="IGNORE";
    $SIG{"TTIN"}="IGNORE";
    $SIG{"TTOU"}="IGNORE";
    $SIG{"TSTP"}="IGNORE";
}

my $logPath = "/var/log/nsgui/tomcat/";
my @filePrefix = ("localhost_admin_log","localhost_log","localhost_access_log","nsadmin");
my $rotationSubfix = "rotate";

if (!(-d "$logPath")){
    exit 0;
}
my @allFiles = `ls -t -1 $logPath`;          #sort by modification time
my %latest_skip=map { $_ => 0}  @filePrefix; #added by xh
foreach  (@allFiles) {
    my $currentFile = $_;
    $currentFile =~ s/\s*//g;
    if ((-f "$logPath$currentFile") && (-w "$logPath$currentFile")){
        my $i = 0;
        for ($i=0;$i<scalar(@filePrefix);$i++){
            my $currentPrefix = $filePrefix[$i];
            if ($currentFile =~ /^${currentPrefix}\.\d{4}-\d{2}-\d{2}(\.\d{2})*\.\w+$/){
                 if( $latest_skip{$currentPrefix} == 0){ #skip latest file being openned by tomcat
                     $latest_skip{$currentPrefix} = 1;   #
                     next;                               #
                 }


                  system("cat ${logPath}$currentFile | /opt/nec/nsadmin/bin/nsgui_syncwrite -a ${logPath}${currentPrefix}\.${rotationSubfix}");
                  if ($? == 0) {
                         system("rm -f ${logPath}$currentFile");
                   }
                   #maybe there are more files should be merged ,so 
                   #the following line is commented
                   #last;
            	}
            }
	}
}
exit 0;
