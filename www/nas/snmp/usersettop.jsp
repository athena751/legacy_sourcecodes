<!--
        Copyright (c) 2005-2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: usersettop.jsp,v 1.2 2006/02/20 00:40:27 zhangjun Exp $" -->

<%@ page import="com.nec.nsgui.action.snmp.SnmpActionConst" %>
<%@ page contentType="text/html;charset=UTF-8"%>

<%@ taglib uri="struts-html"    prefix="html" %>
<%@ taglib uri="struts-bean"    prefix="bean" %>
<%@ taglib uri="struts-logic"   prefix="logic"%>
<%@ taglib uri="struts-nested"  prefix="nested"%>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror"%>

<html>
<head>
    <%@include file="../../common/head.jsp" %>
    <script language="JavaScript" src="../common/common.js"></script>
    <script language="JavaScript" src="../common/validation.js"></script>
    <script language="JavaScript" src="snmpcommon.js"></script>
    <script language="JavaScript">
        var buttonEnable = 0;
        <bean:define id="validUser" value="<%=SnmpActionConst.validUser%>" type="java.lang.String"/>
        <bean:define id="validPasswd" value="<%=SnmpActionConst.validPasswd%>" type="java.lang.String"/>
        <bean:define id="validPassphrase" value="<%=SnmpActionConst.validPassphrase%>" type="java.lang.String"/>
        <bean:define id="operate" name="userForm" property="operate"/>

        function init(){
            <logic:equal name="operate" value="add">
                document.forms[0].elements["userInfo.user"].focus();
                setHelpAnchor('system_snmp_8');
            </logic:equal>
            <logic:equal name="operate" value="modify">
                onInitiation();
                setHelpAnchor('system_snmp_9');
            </logic:equal>
            buttonEnable = 1;
            if( (window.parent.bottomframe.document)
                    &&(window.parent.bottomframe.document.forms[0]) ){
                window.parent.bottomframe.changeButtonStatus();
            }
        }
        function onBack() {
            if (isSubmitted()){
                return false;
            }
            setSubmitted();
            parent.location = "userListFrame.do";
            return true;
        }
        function onInitiation(){
            <logic:equal name="operate" value="modify">
                document.forms[0].passwordMode.checked=0;
                document.forms[0].passphraseMode.checked=0;
                disablePassword();
                disablePassphrase();
            </logic:equal>
        }
        function checkUserName() {
            document.forms[0].elements["userInfo.user"].value=gInputTrim(document.forms[0].elements["userInfo.user"].value);
            //if(document.forms[0].elements["userInfo.user"].value == "nsadmin"){
            //    return false;
            //}
            var invalidSet = /[^a-zA-Z0-9~`!@#$%^&*()_+=|{}\[\];:?\/><,.-]/g;
            return isValid(document.forms[0].elements["userInfo.user"].value,invalidSet,30,1);
        }
        
        function checkPassword(input_value) {
            var invalidSet = /[^a-zA-Z0-9~`!@#$%^&*()_+=|{}\[\]:;?\/<>,.-]/g;
            return isValid(input_value,invalidSet,32,8);
        }
        
        function checkPassphrase(input_value) {
            var invalidSet = /[^a-zA-Z0-9~`!@#$%^&*() _+=|}{\[\]:;?\/,<>.-]/g;
            return isValid(input_value,invalidSet,980,8);
        }
        function addProcess(){
            if(!checkUserName()){
                alert('<bean:message key="common.alert.failed" bundle="common"/>' + "\r\n"
                        + '<bean:message key="snmp.user.alert.invalid_userName" arg0="<%=validUser%>"/>');
                return false;
            }
            if(!checkPassword(document.forms[0].elements["userInfo.password"].value)){
                alert('<bean:message key="common.alert.failed" bundle="common"/>' + "\r\n"
                        + '<bean:message key="snmp.user.alert.invalid_password" arg0="<%=validPasswd%>"/>');
                return false;
            }
            if(document.forms[0].elements["userInfo.password"].value != document.forms[0]._passwordConfirm.value){
                alert('<bean:message key="common.alert.failed" bundle="common"/>' + "\r\n"
                        + '<bean:message key="snmp.user.alert.password_not_same"/>');
                return false;
            }
            if(document.forms[0].elements["userInfo.passphrase"].value != ""){
                if(!checkPassphrase(document.forms[0].elements["userInfo.passphrase"].value)){
                    alert('<bean:message key="common.alert.failed" bundle="common"/>' + "\r\n"
                            + '<bean:message key="snmp.user.alert.invalid_passphrase" arg0="<%=validPassphrase%>"/>');
                    return false;
                }
                if(document.forms[0].elements["userInfo.passphrase"].value != document.forms[0]._passphraseConfirm.value){
                    alert('<bean:message key="common.alert.failed" bundle="common"/>' + "\r\n"
                            + '<bean:message key="snmp.user.alert.passphrase_not_same"/>');
                    return false;
                }
            }
            if(confirm('<bean:message key="common.confirm" bundle="common"/>\r\n'
                        +'<bean:message key="common.confirm.action" bundle="common"/>'
                        + '<bean:message key="common.button.submit" bundle="common"/>')){
                
                document.forms[0].operation.value = "add";
                return true;
            }
            return false;
        }
        function modifyProcess(){
            if(document.forms[0].passwordMode.checked){
                if(!checkPassword(document.forms[0]._password_text.value)){
                    alert('<bean:message key="common.alert.failed" bundle="common"/>' + "\r\n"
                            + '<bean:message key="snmp.user.alert.invalid_password" arg0="<%=validPasswd%>"/>');
                    return false;
                }
                if(document.forms[0]._password_text.value != document.forms[0]._passwordConfirm.value){
                    alert('<bean:message key="common.alert.failed" bundle="common"/>' + "\r\n"
                            + '<bean:message key="snmp.user.alert.password_not_same"/>');
                    return false;
                }
                document.forms[0].elements["userInfo.password"].value = document.forms[0]._password_text.value;
            }else{
                document.forms[0].elements["userInfo.password"].value = "";
            }
            
            if(document.forms[0].passphraseMode.checked){
                if(!checkPassphrase(document.forms[0]._passphrase_text.value)){
                    alert('<bean:message key="common.alert.failed" bundle="common"/>' + "\r\n"
                            + '<bean:message key="snmp.user.alert.invalid_passphrase" arg0="<%=validPassphrase%>"/>');
                    return false;
                }
                if(document.forms[0]._passphrase_text.value != document.forms[0]._passphraseConfirm.value){
                    alert('<bean:message key="common.alert.failed" bundle="common"/>' + "\r\n"
                            + '<bean:message key="snmp.user.alert.passphrase_not_same"/>');
                    return false;
                }
                document.forms[0].elements["userInfo.passphrase"].value = document.forms[0]._passphrase_text.value;
            }else{
                document.forms[0].elements["userInfo.passphrase"].value = "";
            }
            var input_passphrase = document.forms[0].elements["userInfo.passphrase"].value;
            var input_password = document.forms[0].elements["userInfo.password"].value;
            var confirmMSG ;
            if(input_password == "" && input_passphrase == ""){
                confirmMSG = '<bean:message key="snmp.user.confirm.no_password_passphrase"/>';
            }else if(input_password == ""){
                confirmMSG = '<bean:message key="snmp.user.confirm.no_password"/>';
            }else if(input_passphrase == ""){
                confirmMSG = '<bean:message key="snmp.user.confirm.no_passphrase"/>';
            }else{
                confirmMSG = '<bean:message key="common.confirm" bundle="common"/>'
            }
            confirmMSG = confirmMSG + '\r\n'
                        + '<bean:message key="common.confirm.action" bundle="common"/>'
                        + '<bean:message key="common.button.submit" bundle="common"/>';
            if(confirm(confirmMSG)){
                document.forms[0].operation.value="modify";
                return true;
            }
            return false;
        }
        function submitProcess() {
            if (isSubmitted()){
                return false;
            } 
            <logic:equal name="operate" value="add">
                if(addProcess()){
                    setSubmitted();
                    return true;
                }else{
                    return false;
                }
            </logic:equal>
            <logic:equal name="operate" value="modify">
                if(modifyProcess()){
                    setSubmitted();
                    return true;
                }else{
                    return false;
                }
            </logic:equal>
        }
        <logic:equal name="operate" value="modify">
            function disablePassword(){
                document.forms[0]._password_text.disabled=true;
                document.forms[0]._passwordConfirm.disabled=true;
            }
            function enablePassword(){
                document.forms[0]._password_text.disabled=false;
                document.forms[0]._passwordConfirm.disabled=false;
            }
            function disablePassphrase(){
                document.forms[0]._passphrase_text.disabled=true;
                document.forms[0]._passphraseConfirm.disabled=true;
            }
            function enablePassphrase(){
                document.forms[0]._passphrase_text.disabled=false;
                document.forms[0]._passphraseConfirm.disabled=false;
            }
            function clickPassword(){
                if(document.forms[0].passwordMode.checked){
                    enablePassword();
                }else{
                    disablePassword();
                }
            }
            function clickPassphrase(){
                if(document.forms[0].passphraseMode.checked){
                    enablePassphrase();
                }else{
                    disablePassphrase();
                }
            }
        </logic:equal>
    </script>
</head>

<body onload="displayAlert();init();" onUnload="closeDetailErrorWin();">

<html:form action="user.do" target="_parent">
<html:hidden property="operate"/>

<nested:nest property="userInfo">

<input type="button" name="back"  value="<bean:message bundle="common" key="common.button.back"/>" 
        onclick="onBack()">
<displayerror:error h1_key="snmp.common.h1"/>

<logic:equal name="operate" value="add">
    <h3 class="title"> <bean:message key="snmp.user.h3.adduser"/> </h3>
    <input type="hidden" name="operation" value="add"/>
    
    <table border="1" class="Vertical">
        <tr>
            <th><bean:message key="snmp.user.th_userName"/></th>
            <td>
                <nested:text property="user" size="50" maxlength="30"/>
            </td>
        </tr>
        <tr>
            <th>
                <bean:message key="snmp.user.th_authProtocol"/>
            </th>
            <td>
                <nested:radio property="authProtocol" value="SHA" styleId="sha"/>
                <label for="sha">
                    <bean:message key="snmp.user.radio.sha"/>
                </label> &nbsp;
                <nested:radio property="authProtocol" value="MD5" styleId="md5"/>
                <label for="md5">
                    <bean:message key="snmp.user.radio.md5"/>
                </label>
            </td>
        </tr>
        <tr>
            <th>
                <bean:message key="snmp.user.th_password"/>
            </th>
            <td>
                <table border="0">
                    <tr>
                        <td>
                            <bean:message key="snmp.user.th_password"/>
                        </td>
                        <td>
                            <nested:password property="password" value="" size="50"  maxlength="32"/>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <bean:message key="snmp.user.th_passwordConfirm"/>
                        </td>
                        <td>
                            <input type="password" name="_passwordConfirm" value="" size="50" maxlength="32"/>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <th><bean:message key="snmp.user.th_privProtocol"/></th>
            <td>
                <nested:radio property="privProtocol" value="DES" styleId="des"/>
                <label for="des">
                    <bean:message key="snmp.user.radio.des"/>
                </label>
            </td>
        </tr>
        <tr>
            <th><bean:message key="snmp.user.th_passphrase"/></th>
            <td>
                <table border="0">
                    <tr>
                        <td>
                            <bean:message key="snmp.user.th_passphrase"/>
                        </td>
                        <td>
                            <nested:password property="passphrase" value="" size="50" maxlength="980"/>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <bean:message key="snmp.user.th_passphraseConfirm"/>
                        </td>
                        <td>
                            <input type="password" name="_passphraseConfirm" value="" size="50" maxlength="980"/>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <br>
</logic:equal>

<logic:equal name="operate" value="modify">
    <h3 class="title">
        <bean:message key="snmp.user.h3.modifyuser"/>
    </h3>
    <input type="hidden" name="operation" value="modify"/>
    
    <table border="1" class="Vertical">
        <tr>
            <th><bean:message key="snmp.user.th_userName"/></th>
            <td>
                <bean:write name="userForm" property="userInfo.user"/>
                <nested:hidden property="user"/>
            </td>
        </tr>
        <tr>
            <th><bean:message key="snmp.user.th_authProtocol"/></th>
            <td>
                <nested:radio property="authProtocol" value="SHA" styleId="sha" />
                <label for="sha">
                    <bean:message key="snmp.user.radio.sha"/>
                </label> &nbsp;
                <nested:radio property="authProtocol" value="MD5" styleId="md5" />
                <label for="md5">
                    <bean:message key="snmp.user.radio.md5"/>
                </label>
            </td>
        </tr>
        
        <tr>
            <th>
                <bean:message key="snmp.user.th_password"/>
            </th>
            <td>
                <table border="0">
                    <tr>
                        <td colspan="2">
                            <input type="checkbox" name="passwordMode" id="passwordMode1" 
                                    value="change" onclick="clickPassword()"/>
                            <label for="passwordMode1">
                                <bean:message key="snmp.user.th_password_change"/>
                            </label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <bean:message key="snmp.user.th_password"/>
                        </td>
                        <td>
                            <input type="password" name="_password_text" value="" size="50"  maxlength="32"
                                    onfocus="if (this.disabled) this.blur();" />
                            <nested:hidden property="password" value=""/>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <bean:message key="snmp.user.th_passwordConfirm"/>
                        </td>
                        <td>
                            <input type="password" name="_passwordConfirm" value="" size="50"
                                    maxlength="32" onfocus="if (this.disabled) this.blur();"/>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        
        <tr>
            <th><bean:message key="snmp.user.th_privProtocol"/></th>
            <td>
                <nested:radio property="privProtocol" value="DES" styleId="des"/>
                <label for="des">
                    <bean:message key="snmp.user.radio.des"/>
                </label>
            </td>
        </tr>

        <tr>
            <th><bean:message key="snmp.user.th_passphrase"/></th>
            <td>
                <table border="0">
                    <tr>
                        <td colspan="2">
                            <input type="checkbox" name="passphraseMode" id="passphraseMode1" 
                                    value="change" onclick="clickPassphrase()" />
                            <label for="passphraseMode1"><bean:message key="snmp.user.th_passphrase_change"/></label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <bean:message key="snmp.user.th_passphrase"/>
                        </td>
                        <td>
                            <input type="password" name="_passphrase_text" value="" size="50"
                                    maxlength="980" onfocus="if (this.disabled) this.blur();"/>
                            <nested:hidden property="passphrase" value=""/>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <bean:message key="snmp.user.th_passphraseConfirm"/>
                        </td>
                        <td>
                            <input type="password" name="_passphraseConfirm" value="" size="50"
                             maxlength="980" onfocus="if (this.disabled) this.blur();"/>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <br>
</logic:equal>

</nested:nest>
</html:form>
</body>
</html>