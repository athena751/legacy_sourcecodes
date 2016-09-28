<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: volumelist.jsp,v 1.3 2005/12/01 01:59:08 zhangjun Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %> 
<%@ page import="com.nec.nsgui.taglib.nssorttab.*,com.nec.nsgui.action.base.*"%>
<%@ page import="java.util.*"%>

<%@ taglib uri="struts-bean"        prefix="bean" %>
<%@ taglib uri="struts-html"        prefix="html" %>
<%@ taglib uri="struts-logic"       prefix="logic" %>
<%@ taglib uri="taglib-sorttable"   prefix="nssorttab" %>

<html>
<head>
    <title><bean:message key="gfs.common.h1"/></title>
    <%@include file="../../common/head.jsp" %>
	<script language="JavaScript" src="../common/common.js"></script>
	<script language="javascript">
		var SORT_TYPE_NODE;
		function init(){
			<bean:define id="SORT_TYPE_NODE" name="SORT_TYPE_NODE" type="java.lang.String" scope="request"/>
			SORT_TYPE_NODE = "<%=SORT_TYPE_NODE%>";
		}
		function sortByVolumeName() {
		    if(isSubmitted()){
		        return false;
		    }
		    setSubmitted();
	        if(SORT_TYPE_NODE == "SORT_TYPE_VOLUME_UP"){
	            document.forms[0].action="volumeList.do?SORT_TYPE_NODE=SORT_TYPE_VOLUME_DOWN";
	        }else {
	            document.forms[0].action="volumeList.do?SORT_TYPE_NODE=SORT_TYPE_VOLUME_UP";
	        }
		    document.forms[0].submit();
		    return true;
		}
		function sortByMountPoint() {
		    if(isSubmitted()){
		        return false;
		    }
		    setSubmitted();
	        if(SORT_TYPE_NODE == "SORT_TYPE_MOUNTPOINT_UP"){
	            document.forms[0].action="volumeList.do?SORT_TYPE_NODE=SORT_TYPE_MOUNTPOINT_DOWN";
	        }else {
	            document.forms[0].action="volumeList.do?SORT_TYPE_NODE=SORT_TYPE_MOUNTPOINT_UP";
	        }
		    document.forms[0].submit();
		    return true;
		}
		function onRefresh() {
		    if(isSubmitted()){
		        return false;
		    }
		    setSubmitted();
		    window.location="<html:rewrite page='/volumeList.do'/>";
		    return true;
		}
	</script>
</head>

<body onload="init();">

<html:button property="reload" onclick="return onRefresh()">
    <bean:message key="common.button.reload" bundle="common"/>
</html:button>
<h3 class="title"><bean:message key="gfs.volumelist.h3"/></h3>

<form method="post">
    <logic:empty name="SESSION_GFS_VOLUMELIST" scope="request">
        <bean:message key="gfs.volumelist.novolumes"/>
    </logic:empty>
    
    <logic:notEmpty name="SESSION_GFS_VOLUMELIST" scope="request">  
        <html:button property="volumeNameSort" onclick="return sortByVolumeName()">
           <bean:message key="gfs.button.oderbyvolumename"/>
        </html:button>&nbsp;&nbsp;
        <html:button property="mountPointaSort" onclick="return sortByMountPoint()">
           <bean:message key="gfs.button.oderbymountpoint"/>
        </html:button><br>
        
        <logic:iterate id="volume" name="SESSION_GFS_VOLUMELIST" indexId="indexId">
        <br>
        <bean:define id="mountPoint"  name="volume" property="volumeMountPoint" type="java.lang.String"/>
        <bean:define id="volumeName"  name="volume" property="volumeName" type="java.lang.String"/>
        <b>
        <bean:message key="gfs.volumelist.volumename"/><%=NSActionUtil.sanitize(volumeName,true)%>(<bean:write name="volume" property="volumeSize"/><logic:notEqual name="volume" property="volumeSize" value="--" ><bean:message key="gfs.volumelist.novolumes.sizeunit"/></logic:notEqual>)<br>
        <bean:message key="gfs.volumelist.mountpoint"/><%=NSActionUtil.sanitize(mountPoint,true)%>
        </b>
        <br><br>
        <bean:define id="List" value="List" type="java.lang.String"/> 
        <bean:define id="deviceList" name="volume" property="deviceList"/>
        <nssorttab:table  tablemodel="<%=new ListSTModel((AbstractList)deviceList)%>" 
                          id="<%=List+indexId%>"
                          table="border=1"   
                          sortonload="deviceName:ascend" >
                    <nssorttab:column name="deviceName" 
                                      th="STHeaderRender" 
                                      td="STDataRender"
                                      sortable="yes">
                        <bean:message key="gfs.volumelist.th_devicename"/>
                    </nssorttab:column>
                    <nssorttab:column name="deviceLun" 
                                      th="STHeaderRender" 
                                      td="com.nec.nsgui.action.gfs.GfsTData4VolumeListRender"
                                      comparator="com.nec.nsgui.action.gfs.GfsStringtoFloatComparator"
                                      sortable="yes">
                        <bean:message key="gfs.volumelist.th_lun"/>
                    </nssorttab:column>
                    <nssorttab:column name="deviceWwnn" 
                                      th="STHeaderRender" 
                                      td="com.nec.nsgui.action.gfs.GfsTData4VolumeListRender"
                                      sortable="yes">
                        <bean:message key="gfs.volumelist.th_wwnn"/>
                    </nssorttab:column>
                    <nssorttab:column name="deviceSize" 
                                      th="STHeaderRender" 
                                      td="com.nec.nsgui.action.gfs.GfsTData4VolumeListRender"
                                      comparator="com.nec.nsgui.action.gfs.GfsStringtoFloatComparator"
                                      sortable="yes">
                        <bean:message key="gfs.volumelist.th_capacity"/>
                    </nssorttab:column>
                    <nssorttab:column name="gfsType" 
                                      th="STHeaderRender" 
                                      td="com.nec.nsgui.action.gfs.GfsTData4VolumeListRender"
                                      sortable="no">
                        <bean:message key="gfs.volumelist.th_gfsauto"/>
                    </nssorttab:column>
                    <nssorttab:column name="serialNo" 
                                      th="STHeaderRender" 
                                      td="com.nec.nsgui.action.gfs.GfsTData4VolumeListRender"
                                      sortable="yes">
                        <bean:message key="gfs.volumelist.th_serialno"/>
                    </nssorttab:column>
        </nssorttab:table>
        </logic:iterate>
    </logic:notEmpty>      
</form>
</body>
</html>