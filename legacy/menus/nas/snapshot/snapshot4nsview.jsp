<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: snapshot4nsview.jsp,v 1.3 2008/02/29 11:55:44 liy Exp $" -->

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
    Vector snapshotList = snapshotBean.getSnapshotList();
    Vector scheduleList = snapshotBean.getScheduleList();
%>

<HTML>
<HEAD>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=EUC-JP">
<script src="../common/general.js"></script>
<script language="JavaScript">
    function onBack() {
        if( !isSubmitted() ){
            return false;
        }
        setSubmitted();
    	lockMenu();
        window.location="<%=response.encodeURL("../common/mountpoint.jsp?nextAction=Snapshot")%>";
    }

    function reloadPage(){
        if( !isSubmitted() ){
            return false;
        }
        setSubmitted();
        document.forms[0].submit();         
    }    
</script>
<jsp:include page="../../common/wait.jsp" />
</HEAD>
<BODY onUnload="unLockMenu();">
 <h1 class="title"><nsgui:message key="nas_snapshot/common/h1"/></h1>
 <form name="snap" method="post" action="snapshot4nsview.jsp"> 
 <input type="button" name="back" value="<nsgui:message key="common/button/back"/>" onclick="onBack();" >
 <input type="button" name="refresh" value="<nsgui:message key="common/button/reload"/>" onclick="reloadPage()">
 <input type="hidden" name="exportRoot" value="<%=snapshotBean.getExportGroup()%>"/>
 <input type="hidden" name="mountPoint" value="<%=snapshotBean.getMountPoint()%>"/>
 <input type="hidden" name="hexMountPoint" value="<%=snapshotBean.getHexMountPoint()%>"/>
 <h2 class="title"><nsgui:message key="nas_snapshot/snapshow/h2_mp"/>[<%=snapshotBean.getExportGroup() + snapshotBean.getMountPoint()%>]</h2>
 <h3 class="title"><nsgui:message key="nas_snapshot/snapschedule/h3_schedule"/></h3>
    <%if(scheduleList == null || scheduleList.isEmpty()){%>       
        <p><nsgui:message key="nas_snapshot/snapschedule/msg_noschedule"/></p>
    <%}else{%>       
        <nssorttab:table tablemodel="<%=new ListSTModel(scheduleList)%>" id="scheduleTable"
                table="BORDER=1" sortonload="name">
            <nssorttab:column name="scheduleName" 
		
		th="com.nec.sydney.beans.snapshot.SnapshotTHeaderRender" 
		td="com.nec.sydney.beans.snapshot.SnapshotTDataRender"
		sortable="yes">
		<nsgui:message key="nas_snapshot/snapshow/th_name" />
	</nssorttab:column>
	<nssorttab:column name="generation"
		th="com.nec.sydney.beans.snapshot.SnapshotTHeaderRender" 
		td="STDataRender"
		comparator="com.nec.nsgui.taglib.nssorttab.NumberStringComparator">
		<nsgui:message key="nas_snapshot/snapschedule/th_gen" />
	</nssorttab:column>
	<nssorttab:column name="time"
		th="com.nec.sydney.beans.snapshot.SnapshotTHeaderRender" 
		td="com.nec.sydney.beans.snapshot.SnapshotTDataRender">
		<nsgui:message key="nas_snapshot/snapschedule/th_method" />
	</nssorttab:column>
	<nssorttab:column name="deleteGeneration"
		th="com.nec.sydney.beans.snapshot.SnapshotTHeaderRender" 
		td="com.nec.sydney.beans.snapshot.SnapshotTDataRender"
		comparator="com.nec.nsgui.taglib.nssorttab.NumberStringComparator">
		<nsgui:message key="nas_snapshot/snapschedule/th_deleteGen" />
	</nssorttab:column>
	<nssorttab:column name="deleteTime"
		th="com.nec.sydney.beans.snapshot.SnapshotTHeaderRender"
		td="com.nec.sydney.beans.snapshot.SnapshotTDataRender">
		<nsgui:message key="nas_snapshot/snapschedule/th_method" />
	</nssorttab:column>                      
        </nssorttab:table>
    <%}//end of else%>  
 <h3 class="title"><nsgui:message key="nas_snapshot/snapshow/h3_list"/></h3>
    <%if(snapshotList == null || snapshotList.isEmpty()){%>       
        <p><nsgui:message key="nas_snapshot/snapshow/msg_nosnap"/></p>
    <%}else{%>       
        <nssorttab:table tablemodel="<%=new ListSTModel(snapshotList)%>" id="snapshotTable"
                table="BORDER=1" titleTrNum="1" sortonload="name">
            <nssorttab:column name="name" th="STHeaderRender"
                                              td="STDataRender"
                                              sortable="yes">
                    <nsgui:message key="nas_snapshot/snapshow/th_name"/>
            </nssorttab:column>
            <nssorttab:column name="dateTime" th="STHeaderRender"
                                              td="STDataRender"
                                              sortable="yes">
                    <nsgui:message key="nas_snapshot/snapshow/th_date"/>
            </nssorttab:column>
            <nssorttab:column name="status" th="STHeaderRender"
                                            td="com.nec.sydney.beans.snapshot.SnapStatusTDataRender"
                                            sortable="yes">
                    <nsgui:message key="nas_snapshot/snapshow/th_status"/>
            </nssorttab:column>
        </nssorttab:table>
    <%}//end of else%> 
 </form>
</BODY>
</HTML>
