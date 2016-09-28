<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: communitylisttop.jsp,v 1.5 2007/09/11 07:34:48 lil Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %> 
<%@ page import="com.nec.nsgui.taglib.nssorttab.*"%>
<%@ page import="java.util.*"%>
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
            
            <logic:present name="selectedCom" scope="session">
                <bean:define id="selectedComNanme" name="selectedCom" scope="session" toScope="request"/>
                <%NSActionUtil.setSessionAttribute( request,"selectedCom",null );%>
            </logic:present> 

            <logic:equal name="SESSION_SNMP_NAMECHANGEFAILED" value="true" scope="session" >
                <%NSActionUtil.setSessionAttribute( request,SnmpActionConst.SESSION_SNMP_NAMECHANGEFAILED,null );%>
                var confirmMsg = '<bean:message key="snmp.community.confirm.forceDelete"/>';
                if(confirm(confirmMsg)){
                    document.forms[0].action="community.do?operation=delete&isForced=true";
                    document.forms[0].submit();
                    setSubmitted();
                }
            </logic:equal>

            <logic:notPresent name="recoveryFlag" scope="request">
                <logic:notEmpty name="communityList" scope="request">
                    stateFlag=1; 
                    if(parent.frames[1].loaded){
                        parent.frames[1].document.forms[0].modifyCommunity.disabled=false;
                        parent.frames[1].document.forms[0].deleteCommunity.disabled=false;
                    }
                </logic:notEmpty>
            </logic:notPresent> 
            
            <logic:present name="recoveryFlag" scope="request">
                document.forms[0].addCommunity.disabled=true;
            </logic:present> 
        }
        function setSelectedComValue() {
            <logic:notEmpty name="communityList" scope="request">
	            document.forms[0].selectedCom.value = getCheckedRadioValue(document.forms[0].communityRadio);
            </logic:notEmpty>
        }
        function onAdd(){
            if (isSubmitted()){
                return false;
            }
            if(document.forms[0].communityRadio){
                if(parseInt(document.forms[0].allSourceNo.value)>=parseInt(document.forms[0].commMax.value)){
                    alert('<bean:message key="snmp.snmplist.community.alert.exceeded" arg0="\'+document.forms[0].commMax.value+\'"/>');
                    return false;
                }
            }
            setSubmitted();
            document.forms[0].selectedCom.value = "";
            document.forms[0].action="community.do?operation=displaySetFrame";
            document.forms[0].submit();
            return true;
        }
        function onRefresh() {
		    if(isSubmitted()){
		        return false;
		    }
		    setSubmitted();
		    window.parent.location="<html:rewrite page='/communityListFrame.do'/>";
		    return true;
	   }
    </script>
</head>

<body onload="init();displayAlert();setHelpAnchor('system_snmp_3');" onUnload="closeDetailErrorWin()">
<displayerror:error h1_key="snmp.common.h1"/>

<html:form action="community.do" target="_parent">

<html:hidden property="selectedCom"/>
<html:hidden property="allSourceNo"/>
<html:hidden property="allCommunity"/>
<html:hidden property="commMax"/>
<html:button property="refreshInfo" onclick="return onRefresh();">
    <bean:message key="common.button.reload" bundle="common"/>
</html:button>&nbsp;&nbsp;&nbsp;&nbsp;
<html:button property="addCommunity" onclick="return onAdd();">
    <bean:message key="common.button.add2" bundle="common"/>
</html:button> <br><br>

<logic:empty name="communityList" scope="request">
    <bean:message key="snmp.snmplist.community.nocommunity"/>
</logic:empty>

<logic:notEmpty name="communityList" scope="request">  
    <bean:define id="communityList" name="communityList" type="java.util.ArrayList" scope="request"/>  

    <nssorttab:table  tablemodel="<%=new ListSTModel((AbstractList)communityList)%>" 
                      id="list1"
                      table="border=1"   
                      sortonload="communityName:ascend" >
                      
            <nssorttab:column name="communityRadio" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.snmp.SnmpComTRadioRender"
                              sortable="no">
            </nssorttab:column>
            
            <nssorttab:column name="communityName" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.snmp.SnmpComTDataRender"
                              sortable="yes">
                <bean:message key="snmp.community.th_communityname"/>
            </nssorttab:column>
    
            <nssorttab:column name="clientoption" 
                              th="com.nec.nsgui.action.snmp.SnmpSrcTHeaderRender" 
                              td="com.nec.nsgui.action.snmp.SnmpSrcTDataRender"
                              sortable="no">
                <bean:message key="snmp.community.th_source"/>,
                <bean:message key="snmp.community.readLabel"/>,
                <bean:message key="snmp.community.writeLabel"/>,
                <bean:message key="snmp.community.th_trap"/>,
                <bean:message key="snmp.community.th_snmpversion" />
            </nssorttab:column>
    </nssorttab:table>
</logic:notEmpty>

</html:form>

</body>
</html>