/*
 *      Copyright (c) 2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.csar;

public class CsarConst {
    private static final String cvsid = "@(#) $Id: CsarConst.java,v 1.4 2008/04/24 01:13:42 fengmh Exp $"; 
    public static final String SCRIPT_CSAR_LOG_GET_ONE = "/bin/csar_getLogForOneWithTimeout.pl";
    public static final String SCRIPT_CSAR_LOG_GET_BOTH = "/bin/csar_getLogForBothWithTimeout.pl";
    public static final String SCRIPT_CSAR_GET_FIP_NODE = "/bin/cluster_getMyNodeNumber.pl";
    
    public static final String TRACE_LOG_MESSAGE_OTHERNODE_0 = "The collection of analysis information has failed. Maybe the node is not running.";
    public static final String TRACE_LOG_MESSAGE_OTHERNODE_1 = "The collection of analysis information has failed, because it is being edited.";
    public static final String TRACE_LOG_MESSAGE_OTHERNODE_2 = "The collection of analysis information has failed, because there is no enough available space.";
    public static final String TRACE_LOG_MESSAGE_OTHERNODE_4 = "The creation of md5sum file has failed.";
    public static final String TRACE_LOG_MESSAGE_OTHERNODE_5 = "The archive of analysis information collected has failed, because there is no enough available space.";
    public static final String TRACE_LOG_MESSAGE_OTHERNODE_6 = "The archive of analysis information collected has failed.";
    public static final String TRACE_LOG_MESSAGE_OTHERNODE_7 = "Cannot copy the analysis information because of the possibility that the node is not running.";
    public static final String TRACE_LOG_MESSAGE_OTHERNODE_8 = "It has failed to copy analysis information, because there is no enough available space.";
    public static final String TRACE_LOG_MESSAGE_OTHERNODE_9 = "It has failed to copy analysis information.";
    public static final String TRACE_LOG_MESSAGE_OTHERNODE_A = "Succeed to get log in this node.";
    public static final String TRACE_LOG_MESSAGE_OTHERNODE_B = "Failed to archive the analysis information on both nodes because there is not enough space on the disk.";
    public static final String TRACE_LOG_MESSAGE_OTHERNODE_C = "Failed to archive the analysis information on both nodes.";
    public static final String TRACE_LOG_MESSAGE_OTHERNODE_D = "Succeed to get log in this node.";
    
    public static final String TRACE_LOG_MESSAGE_MAINNODE_0 = "The collection of analysis information has failed, because it is being edited.";
    public static final String TRACE_LOG_MESSAGE_MAINNODE_1 = "The collection of analysis information has failed, because there is no enough available space.";
    public static final String TRACE_LOG_MESSAGE_MAINNODE_3 = "The creation of md5sum file has failed.";
    public static final String TRACE_LOG_MESSAGE_MAINNODE_4 = "The archive of analysis information collected has failed, because there is no enough available space.";
    public static final String TRACE_LOG_MESSAGE_MAINNODE_5 = "The archive of analysis information collected has failed.";
    public static final String TRACE_LOG_MESSAGE_MAINNODE_6 = "Succeed to get log in this node.";
    public static final String TRACE_LOG_MESSAGE_MAINNODE_7 = "Failed to archive the analysis information on both nodes because there is not enough space on the disk.";
    public static final String TRACE_LOG_MESSAGE_MAINNODE_8 = "Failed to archive the analysis information on both nodes.";
    public static final String TRACE_LOG_MESSAGE_MAINNODE_9 = "Failed to archive the analysis information on both nodes because there is not enough space on the disk."; 
    public static final String TRACE_LOG_MESSAGE_MAINNODE_A = "Failed to archive the analysis information on both nodes.";
    public static final String TRACE_LOG_MESSAGE_MAINNODE_NOTICEFILE_FAIL = "Failed to get FIP node host name because of the failure of '/bin/hostname -s '.";
    
}