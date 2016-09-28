<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: systemsettop.jsp,v 1.3 2005/12/16 10:44:01 cuihw Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.nec.nsgui.action.snmp.SnmpActionConst"%>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ page import="com.nec.nsgui.model.biz.base.ClusterUtil"%>

<%@ taglib uri="struts-html"        prefix="html" %>
<%@ taglib uri="struts-bean"        prefix="bean" %>
<%@ taglib uri="struts-logic"       prefix="logic"%>
<%@ taglib uri="struts-nested"      prefix="nested"%>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror"%>

<html>
<head>
    <%@include file="../../common/head.jsp" %>
    <script language="JavaScript" src="../common/common.js"></script>
    <script language="JavaScript" src="../common/validation.js"></script>
    <script language="JavaScript">
        var buttonEnable = 0;
        <bean:define id="validContactLocation4Alert" value="<%=SnmpActionConst.validContactLocation4Alert%>" type="java.lang.String"/>
        
        function init(){
            <logic:notPresent name="recoveryFlag" scope="request">
                document.forms[0].elements["systemInfo.contact"].focus();
                buttonEnable = 1;
            </logic:notPresent>
            <logic:present name="recoveryFlag" scope="request">
                document.forms[0].elements["systemInfo.contact"].disabled = true;
                document.forms[0].elements["systemInfo.location"].disabled = true;
            </logic:present>
            
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
            
            if( (window.parent.bottomframe.document)
                    &&(window.parent.bottomframe.document.forms[0]) ){
                window.parent.bottomframe.changeButtonStatus();
            }
        }
        function submitModify(){
            if(isSubmitted() ){
                return false;
            }
            if(!checkSysInfo()){
                return false;
            }
            if(!confirm('<bean:message key="common.confirm" bundle="common"/>\r\n'+
                        '<bean:message key="common.confirm.action" bundle="common"/>'+
                        '<bean:message key="common.button.submit" bundle="common"/>')){
                return false;
            }
            setSubmitted();
            return true;
        }
        function checkSysInfo(){
            document.forms[0].elements["systemInfo.contact"].value = gInputTrim(document.forms[0].elements["systemInfo.contact"].value);
            document.forms[0].elements["systemInfo.location"].value = gInputTrim(document.forms[0].elements["systemInfo.location"].value);
            if(document.forms[0].elements["systemInfo.contact"].value== "" 
                    || (!isPrint(document.forms[0].elements["systemInfo.contact"].value)) ){
                alert('<bean:message key="common.alert.failed" bundle="common"/>\r\n'
                    +'<bean:message key="snmp.sysinfo.alert.invalidContact" arg0="<%=validContactLocation4Alert%>"/>');
                return false;
            }else if(document.forms[0].elements["systemInfo.location"].value== "" 
                    || (!isPrint(document.forms[0].elements["systemInfo.location"].value))){
                alert('<bean:message key="common.alert.failed" bundle="common"/>\r\n'
                    +'<bean:message key="snmp.sysinfo.alert.invalidLocation" arg0="<%=validContactLocation4Alert%>"/>');
                return false;
            }
            return true;
        }
        function onRefresh() {
            if(isSubmitted()){
                return false;
            }
            setSubmitted();
            window.parent.location="<html:rewrite page='/systemSetFrame.do'/>";
            return true;
       }
    </script>
</head>

<body onload="init();displayAlert();setHelpAnchor('system_snmp_2');" onUnload="closeDetailErrorWin();">
<displayerror:error h1_key="snmp.common.h1"/>

<html:form action="system.do?operation=modify" target="_parent">
  <html:button property="refreshInfo" onclick="return onRefresh();">
     <bean:message key="common.button.reload" bundle="common"/>
  </html:button><br><br>
    
    <nested:nest property="systemInfo">
    <table border="1" class="Vertical">
        <tr>
            <th>
                <bean:message key="snmp.sysinfo.th_contact"/>
            </th>
            <td>
                <nested:text property="contact" size="50" maxlength="255"/>
            </td>
        </tr>
        <tr>
            <th>
                <bean:message key="snmp.sysinfo.th_location"/>
            </th>
            <td>
                <nested:text property="location" size="50" maxlength="255"/>
            </td>
        </tr>
    </table><br>
    </nested:nest>
</html:form>

</body>
</html>