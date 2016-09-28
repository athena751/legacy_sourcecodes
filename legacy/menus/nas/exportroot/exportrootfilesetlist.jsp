<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: exportrootfilesetlist.jsp,v 1.2308 2008/10/09 09:50:23 chenb Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" %>
<%@ page import="com.nec.sydney.beans.base.AbstractJSPBean
                    ,com.nec.sydney.atom.admin.base.*
                    ,com.nec.sydney.framework.*
                    ,java.util.*
                    ,org.apache.struts.Globals
                    ,com.nec.nsgui.model.entity.replication.*
                    ,com.nec.nsgui.action.replication.*" %>
<%@ page import="com.nec.nsgui.taglib.nssorttab.ListSTModel" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ taglib uri="/WEB-INF/tld/nssorttab.tld" prefix="nssorttab" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>

<!-- some other taglib should be specified here -->
<jsp:useBean id="bean" class="com.nec.sydney.beans.exportroot.EGFilesetListBean" scope="page"/>
<jsp:setProperty name="bean" property="*" />
<% AbstractJSPBean _abstractJSPBean = bean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>

<html>
<head>
<title>
<%
List filesetList = bean.getFilesetList();

boolean hasFileset = (filesetList== null || filesetList.isEmpty())? false:true;

String filesetType = bean.getFilesetType();
%>
<nsgui:message key="nas_exportroot/replication/h2_replica"/>
</title>

<%@include file="../../../menu/common/meta.jsp" %>
<!-- Meta which doesn't included in meta.jsp should be specified here -->

<script language="JavaScript">
</script>
<jsp:include page="../../../menu/common/wait.jsp" />
</head>


<body onload="displayAlert();">
<h1 class="popup"><nsgui:message key="nas_exportroot/exportroot/h1"/></h1>
<h2 class="popup">

<nsgui:message key="nas_exportroot/replication/h2_replica"/>
[<%=bean.getMountPoint()%>]

</h2>

<form name="FilesetList" method="post" >

<%if(!hasFileset){%>
    <br><nsgui:message key="nas_exportroot/replication/noexptvlm_msg"/>
    <br>
<%}else{
    String repliBundle = Globals.MESSAGES_KEY + "/replication";
    if(filesetType.equals("import")){%>
   
        <nssorttab:table tablemodel="<%=new ListSTModel((java.util.ArrayList)filesetList)%>" 
                         id="replicaList" 
                         table="border=1" 
                         sortonload="originalServer:ascend">
          
            <nssorttab:column name="originalServer"
                              th="STHeaderRender"
                              td="STDataRender"
                              sortable="no">
                <bean:message bundle="<%=repliBundle%>" key="replication.info.oriservername"/>
            </nssorttab:column>
            
            <nssorttab:column name="filesetName"
                              th="STHeaderRender"
                              td="STDataRender"
                              sortable="no">
                <bean:message bundle="<%=repliBundle%>" key="replication.info.filesetname"/>
            </nssorttab:column>            

            <nssorttab:column name="connected"
                              th="STHeaderRender"
                              td="com.nec.nsgui.action.replication.STDataRender4Replica"
                              sortable="no">
                <bean:message bundle="<%=repliBundle%>" key="replica.th.connected"/>
            </nssorttab:column>                              

            <nssorttab:column name="syncRate"
                              th="STHeaderRender"
                              td="com.nec.nsgui.action.replication.STDataRender4Replica"
                              sortable="no">
                <bean:message bundle="<%=repliBundle%>" key="replica.th.syncRate"/>
            </nssorttab:column>

            <nssorttab:column name="transInterface"
                              th="STHeaderRender"
                              td="com.nec.nsgui.action.replication.STDataRender4Replica"
                              sortable="no">
                <bean:message bundle="<%=repliBundle%>" key="replication.info.interface"/>
            </nssorttab:column>    

            <nssorttab:column name="replicationData"
                              th="STHeaderRender"
                              td="com.nec.nsgui.action.replication.STDataRender4Replica"
                              sortable="no">
                <bean:message bundle="<%=repliBundle%>" key="replication.info.replidata"/>
            </nssorttab:column>    
            
            <nssorttab:column name="mountPoint"
                              th="STHeaderRender"
                              td="STDataRender"
                              sortable="no">
                <bean:message bundle="<%=repliBundle%>" key="replication.info.mountpoint"/>
            </nssorttab:column>

            <nssorttab:column name="snapKeepLimit"
                              th="STHeaderRender"
                              td="com.nec.nsgui.action.replication.STDataRender4Replica"
                              sortable="no">
                <bean:message bundle="<%=repliBundle%>" key="replication.th.snapKeep"/>
            </nssorttab:column>                                                                                 

        </nssorttab:table>
    <%}else{// end if(filesetType.equals("import"))  %>
       
        <nssorttab:table tablemodel="<%=new ListSTModel((java.util.ArrayList)filesetList)%>" 
                         id="originalListTable" 
                         table="border=\"1\"" 
                         sortonload="filesetName">
            <nssorttab:column name="filesetName" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                            td="com.nec.nsgui.action.replication.STDataRender4Original"
                                            sortable="no">
                    <bean:message bundle="<%=repliBundle%>" key="replication.info.filesetname"/>
            </nssorttab:column>
            
            <nssorttab:column name="bandWidth" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                            td="com.nec.nsgui.action.replication.STDataRender4Original"
                                            sortable="no">
                    <bean:message bundle="<%=repliBundle%>" key="original.list.th.bandwidth"/>
            </nssorttab:column>
            
            <nssorttab:column name="transInterface" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                            td="com.nec.nsgui.action.replication.STDataRender4Original"
                                            sortable="no">
                    <bean:message bundle="<%=repliBundle%>" key="replication.info.interface"/>
            </nssorttab:column>
            
            
            <nssorttab:column name="connectionAvailable" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                            td="com.nec.nsgui.taglib.nssorttab.STCheckedImageDataRender"
                                            sortable="no">
                    <bean:message bundle="<%=repliBundle%>" key="original.list.th.connection"/>
            </nssorttab:column>

            
            <nssorttab:column name="replicaHost" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                            td="com.nec.nsgui.action.replication.STDataRender4Original"
                                            sortable="no">
                    <bean:message bundle="<%=repliBundle%>" key="original.list.th.replicahost"/>
            </nssorttab:column>
            
            <nssorttab:column name="mountPoint" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                            td="com.nec.nsgui.taglib.nssorttab.STDataRender"
                                            sortable="no">
                    <bean:message bundle="<%=repliBundle%>" key="replication.info.mountpoint"/>
            </nssorttab:column>
            <nssorttab:column name="checkPoint" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                            td="com.nec.nsgui.action.replication.STDataRender4Original"
                                            sortable="no">
					<bean:message bundle="<%=repliBundle%>" key="original.list.th.checkpoint"/>
            </nssorttab:column>            
        </nssorttab:table>        
       
    <%}// end if(filesetType.equals("import")) else{}%>

<%}//end if(!hasFileset) else{}%>


<br>
<hr>
<br>
<center>
    <input type="button" value="<nsgui:message key="common/button/close"/>"
                                                onclick="window.close();">
</center>
</form>
</body>
</html>
