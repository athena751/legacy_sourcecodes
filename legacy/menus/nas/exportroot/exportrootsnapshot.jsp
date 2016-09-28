<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

 <!-- "@(#) $Id: exportrootsnapshot.jsp,v 1.2304 2007/05/30 09:51:32 liy Exp $" -->
 

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page buffer="32kb" %>
<%@ page language="java" import="java.util.*
                    ,com.nec.sydney.beans.snapshot.Snapshot4nsviewBean
                    ,com.nec.sydney.beans.base.AbstractJSPBean
                    ,com.nec.sydney.atom.admin.snapshot.*
                    ,com.nec.sydney.atom.admin.base.*" %>
<%@ page import="com.nec.sydney.framework.*" %>
<%@ page import="com.nec.nsgui.taglib.nssorttab.*"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ taglib uri="taglib-sorttable" prefix="nssorttab" %>
<jsp:useBean id="snapshotBean" class="com.nec.sydney.beans.snapshot.Snapshot4nsviewBean" scope="page"/>
<%AbstractJSPBean _abstractJSPBean =snapshotBean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>

<%
    Vector scheduleList = snapshotBean.getScheduleList();
%>

<html>
<head>
<title><nsgui:message key="nas_exportroot/exportroot/h2_schedule"/></title>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=EUC-JP">
<%@include file="../../../menu/common/meta.jsp" %>
</head>

<body onload="displayAlert();">
<h1 class="popup"><nsgui:message key="nas_exportroot/exportroot/h1"/></h1>
<h2 class="popup"><nsgui:message key="nas_exportroot/exportroot/h2_schedule"/>[<%=snapshotBean.getMountPoint()%>]</h2>
<form name="ScheduleList" method="post" >
    <%if(scheduleList == null || scheduleList.isEmpty()){%>       
        <p><nsgui:message key="nas_snapshot/snapschedule/msg_noschedule"/></p>
    <%}else{%>       
        <nssorttab:table tablemodel="<%=new ListSTModel(scheduleList)%>" id="scheduleTable" table="BORDER=1" sortonload="name">
            <nssorttab:column name="scheduleName" th="com.nec.sydney.beans.snapshot.SnapshotTHeaderRender" 
		                                          td="com.nec.sydney.beans.snapshot.SnapshotTDataRender" sortable="yes">
		        <nsgui:message key="nas_snapshot/snapshow/th_name" />
	        </nssorttab:column>
	        <nssorttab:column name="generation" th="com.nec.sydney.beans.snapshot.SnapshotTHeaderRender" 
		                                        td="STDataRender"
		        comparator="com.nec.nsgui.taglib.nssorttab.NumberStringComparator">
		        <nsgui:message key="nas_snapshot/snapschedule/th_gen" />
	        </nssorttab:column>
	        <nssorttab:column name="time" th="com.nec.sydney.beans.snapshot.SnapshotTHeaderRender" 
		                                  td="com.nec.sydney.beans.snapshot.SnapshotTDataRender">
		        <nsgui:message key="nas_snapshot/snapschedule/th_method" />
	        </nssorttab:column>
	        <nssorttab:column name="deleteGeneration" th="com.nec.sydney.beans.snapshot.SnapshotTHeaderRender" 
		                                              td="com.nec.sydney.beans.snapshot.SnapshotTDataRender"
		        comparator="com.nec.nsgui.taglib.nssorttab.NumberStringComparator">
		        <nsgui:message key="nas_snapshot/snapschedule/th_deleteGen" />
	        </nssorttab:column>
	        <nssorttab:column name="deleteTime" th="com.nec.sydney.beans.snapshot.SnapshotTHeaderRender"
		                                        td="com.nec.sydney.beans.snapshot.SnapshotTDataRender">
		        <nsgui:message key="nas_snapshot/snapschedule/th_method" />
	        </nssorttab:column>                 
        </nssorttab:table>
    <%}//end of else%>  
<br>
<hr>
<br>
<center>
<input type="button" value="<nsgui:message key="common/button/close"/>" onclick="window.close();">
</center>
</form>
</body>
</html>