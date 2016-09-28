#!/bin/sh
#       Copyright (c) 2005 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) nsgui_services.sh,v 1.3 2005/01/26 07:14:42 kanai Exp"
usage() 
{
        echo "$0 type"  1>& 2
}
if [ $# -ne 1 ];then
   usage
   exit 1
fi
if [ $1 = "communities" ];then
    sudo /home/nsadmin/bin/nsgui_iptables2.sh -L INPUT -nv  |  awk  '{if($6~/^bond0$/ && $11~/(dpt:161|dpt:162)/ && $8!~/0\.0\.0\.0\/0/) {printf("%s %s %s %s\n",$3,$4,$8,$11);}}' |sort
elif [ $1 = "users" ];then
    sudo /home/nsadmin/bin/nsgui_iptables2.sh -L INPUT -nv  |  awk  '{if($6~/^bond0$/ && $11~/(dpt:161|dpt:162)/ && $8~/0\.0\.0\.0\/0/) {printf("%s %s %s %s\n",$3,$4,$8,$11);}}' |sort
elif [ $1 = "all" ];then
    sudo /home/nsadmin/bin/nsgui_iptables2.sh -L INPUT -nv  |  awk  '{if($6~/^bond0$/ && $11~/(dpt:161|dpt:162)/) {printf("%s %s %s %s\n",$3,$4,$8,$11);}}' |sort
elif [ $1 = "system" ];then
    :
else
    usage
    exit 1
fi

exit 0