<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: userlisttop.jsp,v 1.2 2005/10/25 08:16:53 cuihw Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %> 
<%@ page import="com.nec.nsgui.taglib.nssorttab.*,java.util.*"%>
<%@ page import="com.nec.nsgui.action.snmp.SnmpActionConst"%> 
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ page import="com.nec.nsgui.model.biz.base.ClusterUtil"%>

<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ taglib uri="taglib-sorttable" prefix="nssorttab" %>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror" %>

<html>
<head>
    <title><bean:message key="snmp.common.h1"/></title>
    <%@include file="../../common/head.jsp" %>
    <script language="JavaScript" src="../common/common.js"></script>
    <script language="javascript">
        var stateFlag = 0;
        function init() {
            <logic:equal name="SESSION_SNMP_PARTNERFAILED" value="true" scope="session">
                <%
                    int node = ClusterUtil.getInstance().getMyNodeNo();
                    int partnerNode = 1 - node;
                    String nodeNo = ( new Integer(node) ).toString();
                    String partnerNodeNo = ( new Integer(partnerNode) ).toString();
                %>
                alert('<bean:message key="snmp.alert.partnerNodeExecError" arg0="<%=nodeNo%>" arg1="<%=partnerNodeNo%>"/>');
                <%NSActionUtil.setSessionAttribute( request,SnmpActionConst.SESSION_SNMP_PARTNERFAILED,null );%>
            </logic:equal>
            <logic:notPresent name="recoveryFlag" scope="request">
                <logic:notEmpty name="userList" scope="request">
                    stateFlag=1; 
                    if(parent.frames[1].loaded){
                        parent.frames[1].document.forms[0].modifyUser.disabled=false;
                        parent.frames[1].document.forms[0].deleteUser.disabled=false;
                    }  
                </logic:notEmpty>
            </logic:notPresent>
            <logic:present name="recoveryFlag" scope="request">
                document.forms[0].addUser.disabled=true;
            </logic:present> 
        }
        function setSelectedUserValue() {
            <logic:notEmpty name="userList" scope="request">
	            document.forms[0].selectedUser.value = getCheckedRadioValue(document.forms[0].userRadio);
            </logic:notEmpty>
        }
        function onAdd(){
            if (isSubmitted()){
                return false;
            }
            if(document.forms[0].userRadio){
                if(document.forms[0].userRadio.length>=10){
                    alert("<bean:message key="snmp.snmplist.user.alert.morethan10" />");
                    return false;
                }
            }
            setSubmitted();
            document.forms[0].selectedUser.value = "";
            document.forms[0].action="user.do?operation=displaySetFrame";
            document.forms[0].submit();
            return true;
        }
        function onRefresh() {
            if(isSubmitted()){
                return false;
            }
            setSubmitted();
            window.parent.location="<html:rewrite page='/userListFrame.do'/>";
            return true;
       }
    </script>
</head>

<body onload="init();displayAlert();setHelpAnchor('system_snmp_7');" onUnload="closeDetailErrorWin()">
<displayerror:error h1_key="snmp.common.h1"/> 

<form method="post" target="_parent">

<input type="hidden" name="selectedUser" value=""/>
<html:button property="refreshInfo" onclick="return onRefresh();">
    <bean:message key="common.button.reload" bundle="common"/>
</html:button>&nbsp;&nbsp;&nbsp;&nbsp;

<html:button property="addUser" onclick="return onAdd();">
    <bean:message key="common.button.add2" bundle="common"/>
</html:button>
<br><br>

<logic:empty name="userList" scope="request">
    <bean:message key="snmp.snmplist.user.nouser"/>
</logic:empty>

<logic:notEmpty name="userList" scope="request">   
    <bean:define id="userList" name="userList" scope="request"/>
    
    <nssorttab:table  tablemodel="<%=new ListSTModel((AbstractList)userList)%>" 
                      id="list1"
                      table="border=1"   
                      sortonload="user:ascend" >
    
        <nssorttab:column name="userRadio" 
                          th="STHeaderRender" 
                          td="com.nec.nsgui.action.snmp.SnmpUserTRadioRender"
                          sortable="no">
        </nssorttab:column>
        
        <nssorttab:column name="user" 
                          th="STHeaderRender"
                          td="com.nec.nsgui.action.snmp.SnmpUserTNameRender"
                          sortable="yes">
            <bean:message key="snmp.user.th_userName"/>
        </nssorttab:column>
        
        <nssorttab:column name="authProtocol" 
                          th="STHeaderRender" 
                          td="STDataRender"
                          sortable="no">
            <bean:message key="snmp.user.th_authProtocol"/>
        </nssorttab:column> 
        
        <nssorttab:column name="privProtocol" 
                          th="STHeaderRender" 
                          td="STDataRender"
                          sortable="no">
            <bean:message key="snmp.user.th_privProtocol"/>
        </nssorttab:column>
    </nssorttab:table>
</logic:notEmpty>
</form>
</body>
</html>