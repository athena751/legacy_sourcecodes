<!--
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: originallist4nsview.jsp,v 1.3 2008/05/28 05:07:25 liy Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.taglib.nssorttab.ListSTModel" %>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>
<%@ taglib uri="/WEB-INF/tld/nssorttab.tld" prefix="nssorttab" %>
<html>
<head>
 <%@include file="../../common/head.jsp" %>
 <%@include file="originalcommon.jsp" %>  
<script language="JavaScript" src="../common/common.js"></script>
</head>

<body onload="setHelpAnchor('replication_1');">
<html:form action="originalAction.do" >
    
    <html:button property="reloadBtn" onclick="return back2List();">
        <bean:message key="common.button.reload" bundle="common"/>
    </html:button>
    
    <br>
    <displayerror:error h1_key="replicate.h1"/>
    <br>
    
    <logic:empty name="oriList" scope="request">
        <bean:message key="original.info.nooriginal"/>
    </logic:empty> 
    
    <logic:notEmpty name="oriList" scope="request">
              
        <bean:define id="oriList" name="oriList" type="java.util.ArrayList"/>
        <nssorttab:table tablemodel="<%=new ListSTModel((java.util.ArrayList)oriList)%>" id="originalListTable" table="border=\"1\"" sortonload="filesetName">
            <nssorttab:column name="filesetName" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                            td="com.nec.nsgui.action.replication.STDataRender4Original"
                                            sortable="yes">
                    <bean:message key="replication.info.filesetname"/>
            </nssorttab:column>
            
            <nssorttab:column name="bandWidth" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                            td="com.nec.nsgui.action.replication.STDataRender4Original"
                                            sortable="no">
                    <bean:message key="original.list.th.bandwidth"/>
            </nssorttab:column>
            
            <nssorttab:column name="transInterface" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                            td="com.nec.nsgui.action.replication.STDataRender4Original"
                                            sortable="no">
                    <bean:message key="replication.info.interface"/>
            </nssorttab:column>
            
            
            <nssorttab:column name="connectionAvailable" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                            td="com.nec.nsgui.taglib.nssorttab.STCheckedImageDataRender"
                                            sortable="no">
                    <bean:message key="original.list.th.connection"/>
            </nssorttab:column>

            
            <nssorttab:column name="replicaHost" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                            td="com.nec.nsgui.action.replication.STDataRender4Original"
                                            sortable="no">
                    <bean:message key="original.list.th.replicahost"/>
            </nssorttab:column>
            
            <nssorttab:column name="mountPoint" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                            td="com.nec.nsgui.taglib.nssorttab.STDataRender"
                                            sortable="yes">
                    <bean:message key="replication.info.mountpoint"/>
            </nssorttab:column>
            <nssorttab:column name="checkPoint" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                            td="com.nec.nsgui.action.replication.STDataRender4Original"
                                            sortable="no">
					<bean:message key="original.list.th.checkpoint"/>
            </nssorttab:column>
        </nssorttab:table>        
            
  </logic:notEmpty> 


</html:form>
</body>
</html>



