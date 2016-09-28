<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nicadmintop.jsp,v 1.5 2005/10/24 04:39:19 dengyp Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.taglib.nssorttab.*,java.util.*"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ taglib uri="taglib-sorttable" prefix="nssorttab" %>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror"%> 

<html>
<head>
<%@include file="../../common/head.jsp" %>  
<html:base/>
<script language="JavaScript" src="../../common/common.js"></script>
<script language="javascript">
var buttonEnable = 0;
function init(){ 
    <logic:notEmpty name="adminList">
         buttonEnable = 1;
         if(window.parent.frames[1]){
             if((window.parent.frames[1].document)
                    &&(window.parent.frames[1].document.forms[0]) ){
                window.parent.frames[1].changeButtonStatus();
            }    
         }
    </logic:notEmpty>
}

function onRefresh(){
    parent.location="/nsadmin/nic/adminList.do";
}

</script>
</head>
<body onload="displayAlert();init();setHelpAnchor('m_network_1');">         
    <form name="listForm" method="post">   
        <html:button property="refreshBtn" onclick="onRefresh();">
           <bean:message key="common.button.reload" bundle="common"/>
        </html:button><br><br>
        <displayerror:error h1_key="nic.h1.adminnetwork"/> 
        <logic:empty name="adminList" scope="request">
              <br><bean:message key="nic.admin.noadmininterface"/>
        </logic:empty>      
        <logic:notEmpty name="adminList">
               
         <bean:define id="adminList" name="adminList" scope="request"/>         
         <nssorttab:table  tablemodel="<%=new ListSTModel((Vector)adminList)%>" 
                      id="list1"
                      table="border=1"  >
            <nssorttab:column name="nicName" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.nic.STDataRender4Nic"
                              sortable="no">
               <bean:message key="nic.list.table.head.name"/>
            </nssorttab:column>
            
            <nssorttab:column name="status" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.nic.STDataRender4Nic"
                              sortable="no">
              <bean:message key="nic.list.table.head.status"/> 
            </nssorttab:column>          
            
            <nssorttab:column name="ipAddress" 
                              th="com.nec.nsgui.action.nic.STHeaderRender4IP"  
                              td="com.nec.nsgui.action.nic.STDataRender4Nic"
                              sortable="no"> 
            </nssorttab:column>
            
            <nssorttab:column name="gateway" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.nic.STDataRender4Nic"
                              sortable="no">
              <bean:message key="nic.list.table.head.gateway"/> 
            </nssorttab:column>            
            
            <nssorttab:column name="mtu" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.nic.STDataRender4Nic"
                              sortable="no">
              <bean:message key="nic.list.table.head.mtu"/> 
            </nssorttab:column>    
            
            <nssorttab:column name="mode" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.nic.STDataRender4Nic"
                              sortable="no">
              <bean:message key="nic.list.table.head.extension"/> 
            </nssorttab:column>
            
            <nssorttab:column name="construction" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.nic.STDataRender4Nic"
                              sortable="no">
             <bean:message key="nic.list.table.head.construction"/> 
            </nssorttab:column> 
            
         </nssorttab:table> 
       </logic:notEmpty>      
        </form>
</body>
</html>