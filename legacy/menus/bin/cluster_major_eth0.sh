#!/bin/sh
#
#       Copyright (c) 2003-2008 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: cluster_major_eth0.sh,v 1.2308 2008/03/12 02:18:22 zhangjun Exp $"

args=`getopt 'i:' $*`
if [ $? != 0 ]; then
        exit 0;
fi

URLADDR=""
FIP_ADDR=""

for opt in $args
do
        case $opt in
        -i)     URLADDR=$2;     shift 2;;
        esac
done
if [ $# != 0 ]; then
        exit 0
fi

#add by zhangjun:NV7400NS is single node
sn=`/opt/nec/nsadmin/bin/nsgui_isSingleNVRAM.sh`
if [ $? -ne 0 ]; then
    exit 0 #checknode error
fi
if [ "x$sn" = "x0" ]; then
    exit 0 #I am single NVRAM model.
fi
#end of: add by zhangjun

IFCFG_BOND0=/etc/sysconfig/network-scripts/ifcfg-bond0
NASCONF=/etc/nascluster.conf

if [ ! -f $IFCFG_BOND0 ]; then
		# single node.
        exit 0
fi

. $IFCFG_BOND0

`/home/nsadmin/bin/getMachineType.sh`
TYPE=$?
### not need to consider ipsan case
###if [ "x$TYPE" = "x100" ]; then
###        GUI_GROUP=0
###else
        GUI_GROUP=2
###fi
FIP0_NODE=`/home/nsadmin/bin/cluster_group_which_node.sh $GUI_GROUP`

# get FIPADDR

if [ "x$FIP0_NODE" = "x" ]; then
        exit 0
fi

# FIP is at this node.
if [ "x$IPADDR" = "x$FIP0_NODE" ]; then
        exit 0
else
        . $NASCONF
	# noting URLADDR
	if [ "x$URLADDR" = "x" ]; then
		echo $FIPADDR
		exit 1
	fi
	# type mp 
        if [ "x$GUI_GROUP" = "x100" ]; then
                echo $FIPADDR
                exit 1
        fi
	# type nas and type eth
        if [ "x$IPADDR" = "x$URLADDR" ]; then
        # the request is from management network!
                echo $FIPADDR
                exit 1
        fi
        
    # Get two node's service network's nic's information.
    MYIPINFOS=`/home/nsadmin/bin/nic_getnicbaseinfo.pl -s | sed 's/\/[[:digit:]]*//' | awk '{print $3" "$4;}'`;
    FRIENDIP=`/home/nsadmin/bin/getMyFriend.sh`;
    if [ "x$FRIENDIP" != "x" ]; then
	    FRIENDIPINFOS=`ping -c 1 -w 2  $FRIENDIP >& /dev/null && \
	        sudo -u nsgui rsh $FRIENDIP sudo /home/nsadmin/bin/nic_getnicbaseinfo.pl -s | \
	        sed 's/\/[[:digit:]]*//' | awk '{print $3" "$4;}'`;
	fi
	
    # check whether FIP and group0,group1 are in different node.
        GROUP1NODE=`/home/nsadmin/bin/cluster_group_which_node.sh 1`
        GROUP0NODE=`/home/nsadmin/bin/cluster_group_which_node.sh 0`
        if [ "x$GROUP1NODE" = "x$GROUP0NODE" -a "x$GROUP0NODE" != "x" \
             -a  "x$FIP0_NODE" != "x$GROUP0NODE" ]; then 
        	FIND1=`echo $MYIPINFOS | grep "^$URLADDR[[:space:]]"`;
        	FIND2=`echo $FRIENDIPINFOS | grep "^$URLADDR[[:space:]]"`;
        	if [ "x$FIND1" != "x" -o "x$FIND2" != "x" ]; then 
        		echo $FIPADDR
        		exit 2
        	fi
        fi
        
	# type nas and type toe
	#  the specified URL IP is service nic's ip. so it is necessary to get the other node's service nic's IP.
	# if the other node has no service ip or the service ip is not in the same network with URL ip,output FIP.
	    BROD=`echo "$MYIPINFOS" | awk -v ip=$URLADDR '{if ($1 == ip){ print $2}}' | sed -n '1p'`;
	    if [ "x$FRIENDIPINFOS" != "x" ] ; then
	    	checkflag=`echo "$FRIENDIPINFOS" | awk -v brod=$BROD '{if ($2 == brod){ print $1}}'| sed -n '1p'`
	    fi
		if [ "x$checkflag" = "x" ]; then
			echo $FIPADDR;
		else
			echo $checkflag;
		fi
        exit 1
fi
