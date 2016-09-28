#!/bin/sh
#       Copyright (c) 2005-2006 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: snmp_applyIptablesofFriNode.sh,v 1.6 2006/02/20 00:39:00 zhangjun Exp $"
usage() 
{
        echo "$0 friendIP type"  1>& 2
}
if [ $# -ne 1 -a $# -ne 2 ]; then
    usage
    exit 1
fi

TYPE_ALL="all"
TYPE_COMMUNITIES="communities"
TYPE_USERS="users"
TYPE_SYSTEM="system"

if [ "x$2" = "x$TYPE_ALL" -o "x$2" = "x$TYPE_COMMUNITIES" ]; then
    iptablesinfo=`sudo /home/nsadmin/bin/snmp_getSNMPIPTablesInfo.sh communities`
    if [ "x$iptablesinfo" != "x" ]; then
        sudo /home/nsadmin/bin/nsgui_iptables2.sh -L INPUT -nv  |  awk  '{if($6~/^bond0$/ && $11~/(dpt:161|dpt:162)/ && $8!~/0\.0\.0\.0\/0/) printf "-D INPUT -p %s  --source  %s --dport %s  -i %s -j ACCEPT\n",$4,$8,$11,$6}' | sed 's/dpt://'  |xargs -n 12  sudo /home/nsadmin/bin/nsgui_iptables2.sh
        if [ $? != 0 ]; then
                exit 1
        fi
    fi
fi


if [ "x$2" = "x$TYPE_ALL" -o "x$2" = "x$TYPE_USERS" ]; then
    iptablesinfo=`sudo /home/nsadmin/bin/snmp_getSNMPIPTablesInfo.sh users`
    if [ "x$iptablesinfo" != "x" ]; then
        sudo /home/nsadmin/bin/nsgui_iptables2.sh -L INPUT -nv  |  awk  '{if($6~/^bond0$/ && $11~/(dpt:161|dpt:162)/ && $8~/0\.0\.0\.0\/0/) printf "-D INPUT -p %s  --dport %s  -i %s -j ACCEPT\n",$4,$11,$6}' | sed 's/dpt://'  |xargs -n 10  sudo /home/nsadmin/bin/nsgui_iptables2.sh
        if [ $? != 0 ]; then
            exit 1
        fi
    fi
fi


if [ "x$2" = "x$TYPE_ALL" -o "x$2" = "x$TYPE_COMMUNITIES" ]; then
    iptablesinfo=`sudo -u nsgui /usr/bin/rsh $1 'sudo /home/nsadmin/bin/snmp_getSNMPIPTablesInfo.sh communities'`
    if [ "x$iptablesinfo" != "x" ]; then
        sudo -u nsgui /usr/bin/rsh $1 'sudo /home/nsadmin/bin/nsgui_iptables2.sh -L INPUT -nv'|  awk  '{if($6~/^bond0$/ && $11~/(dpt:161|dpt:162)/ && $8!~/0\.0\.0\.0\/0/) printf "-A INPUT -p %s  --source  %s --dport %s  -i %s -j ACCEPT\n",$4,$8,$11,$6}' | sed 's/dpt://' |xargs -n 12  sudo /home/nsadmin/bin/nsgui_iptables2.sh
        if [ $? != 0 ]; then
                exit 1
        fi
    fi
fi


if [ "x$2" = "x$TYPE_ALL" -o "x$2" = "x$TYPE_USERS" ]; then
    iptablesinfo=`sudo -u nsgui /usr/bin/rsh $1 'sudo /home/nsadmin/bin/snmp_getSNMPIPTablesInfo.sh users'`
    if [ "x$iptablesinfo" != "x" ]; then
        sudo -u nsgui /usr/bin/rsh $1 'sudo /home/nsadmin/bin/nsgui_iptables2.sh -L INPUT -nv'|  awk  '{if($6~/^bond0$/ && $11~/(dpt:161|dpt:162)/ && $8~/0\.0\.0\.0\/0/) printf "-A INPUT -p %s --dport %s  -i %s -j ACCEPT\n",$4,$11,$6}' | sed 's/dpt://' |xargs -n 10  sudo /home/nsadmin/bin/nsgui_iptables2.sh
        if [ $? != 0 ]; then
            exit 1
        fi
    fi
fi