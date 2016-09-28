<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nicbondtop.jsp,v 1.5 2007/09/12 07:04:37 fengmh Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="struts-bean" prefix="bean"%>
<%@ taglib uri="struts-html" prefix="html"%>
<%@ taglib uri="struts-logic" prefix="logic"%>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror"%>

<html>
<head>
<%@include file="../../common/head.jsp"%>
<html:base />
<script language="JavaScript" src="<%=request.getContextPath()%>/common/common.js"></script>
<script language="JavaScript" src="<%=request.getContextPath()%>/common/validation.js"></script>
<script language="javascript">

    function loadBottomFrame(){
        if (window.parent && window.parent.nicbondbottomframe){
            window.parent.nicbondbottomframe.location = "<%=request.getContextPath()%>/nic/bondShowBottom.do";
        }
    }
    
    function displayOldValue(){
    
        var selectedNics = document.forms[0].elements["bondInfo.selectedIFs"].value;
        var availObj = document.forms[0].elements["canSelect"];
        var selectedObj = document.forms[0].elements["selectedNic"];
        var primaryObj = document.forms[0].elements["bondInfo.primaryIF"];
        if (selectedNics != ""){
            var arr = selectedNics.split(",");
            for (var i = 0; i< arr.length; i++){
                for (var j = 0; j < availObj.length; j++){
                    if (arr[i] == availObj.options[j].value){
                        var obj = availObj.options[j];
                        addObj4Select(selectedObj,obj);
                        addObj4Select(primaryObj,obj);
                        availObj.remove(j);
                        break;
                    }
                }
            }
            var primary = document.forms[0].elements["primary"].value;
            var modeObj = document.forms[0].elements["bondInfo.mode"];
            if ( primary != "" && modeObj[0].checked){
                primaryObj.value = primary;
            }
        }
    
    }
    
    function init(){
        loadBottomFrame();
        <logic:equal name="havAvailableNic4Bond" value="true">
        displayOldValue();
        decidePrimaryStatus();
        
        var availObj = document.forms[0].elements["canSelect"];
        if (availObj.length > 0){
            availObj.selectedIndex = 0;
        }
        
        decideButtonStatus();
        </logic:equal>
        return;
    }
    
    function onSelectType(isAB){
        var primaryObj = document.forms[0].elements["bondInfo.primaryIF"];
        if (isAB){
            primaryObj.disabled = false;
        }else{
            primaryObj.disabled = true;
        }
    }
    
    function decidePrimaryStatus(){
        var modeObj = document.forms[0].elements["bondInfo.mode"];
        var primaryObj = document.forms[0].elements["bondInfo.primaryIF"];
        if (modeObj[0].checked){
            primaryObj.disabled = 0;
        }else{
            primaryObj.disabled = 1;
        }
    }
    
    function decideButtonStatus(){
        var addButton = document.forms[0].elements["add"];
        var delButton = document.forms[0].elements["del"];
        if ( document.forms[0].elements["canSelect"].selectedIndex  >= 0){
            addButton.disabled = false;
        }else{
            addButton.disabled = true;
        }
        if ( document.forms[0].elements["selectedNic"].selectedIndex  >= 0){
            delButton.disabled = false;
        }else{
            delButton.disabled = true;
        }
    }
    
    function onAdd(){
        var availObj = document.forms[0].elements["canSelect"];
        var selectedObj = document.forms[0].elements["selectedNic"];
        var primaryObj = document.forms[0].elements["bondInfo.primaryIF"];
        var selectId = availObj.selectedIndex;
        if (selectId >= 0){
            var obj = availObj.options[selectId];
            addObj4Select(selectedObj,obj);
            addObj4Select(primaryObj,obj);
            availObj.remove(selectId);
            selectId = selectId > (availObj.length - 1 ) ? (availObj.length - 1 ) : selectId;
            if (selectId >= 0  ){
                availObj.selectedIndex = selectId ;
            }
        }
        decideButtonStatus();
    }
    
    function addObj4Select (selectObj,optionObj) {
        selectObj.options.length ++;
        var oOption = selectObj.options[selectObj.options.length - 1];  
        oOption.text = optionObj.text;
        oOption.value = optionObj.value;
    }
    
    function onDel(){
        var availObj = document.forms[0].elements["canSelect"];
        var selectedObj = document.forms[0].elements["selectedNic"];
        var primaryObj = document.forms[0].elements["bondInfo.primaryIF"];
        var selectId = selectedObj.selectedIndex;
        if (selectId >= 0){
            var obj = selectedObj.options[selectId];
            addObj4Select(availObj,obj);
            
            selectedObj.remove(selectId);
            selectId = selectId > (selectedObj.length - 1 ) ? (selectedObj.length - 1 ) : selectId;
            if (selectId >= 0  ){
                selectedObj.selectedIndex = selectId ;
            }
            for (var i=0; i < primaryObj.length; i++){
                if (primaryObj.options[i].value ==  obj.value){
                    if (primaryObj.value == obj.value){
                        primaryObj.value = "";
                    }
                    primaryObj.remove(i);
                    break;
                }
            }
        }
        decideButtonStatus();
        return false;
    }
    
    function onSubmitSetting(){
        if (isSubmitted()){
            return;
        }
        var selectedObj = document.forms[0].elements["selectedNic"];
        var intervalObj = document.forms[0].elements["bondInfo.interval"];
        var selectId = selectedObj.selectedIndex;
        
        if (selectedObj.length < 2){
            alert("<bean:message key="nic.bond.noNics"/>");
            return ;
        }
        
        var nics = "";
        var has_te = false;
        var has_notTe = false;
        for ( var i = 0; i< selectedObj.length ; i++){
            if(selectedObj.options[i].value.match(/^te/)) {
                has_te = true;
            } else {
                has_notTe = true;
            }
            if (nics == ""){
                nics = selectedObj.options[i].value;
            }else{
                nics += "," + selectedObj.options[i].value;
            }
        }
        if(has_te && has_notTe) {
            alert("<bean:message key="nic.bond.te_ge_mix"/>");
            return false;
        }
        
        intervalObj.value = trim(intervalObj.value);
        if (!isValidDigit(intervalObj.value,100,120000)){
            alert("<bean:message key="nic.bond.invalidInterval"/>");
            intervalObj.focus();
            return ;
        }
        intervalObj.value = parseInt(intervalObj.value,10);
        
        document.forms[0].elements["bondInfo.selectedIFs"].value = nics;
        
        var msg="<bean:message key="common.confirm" bundle="common"/>" +"\r\n"+
          "<bean:message key="common.confirm.action" bundle="common"/>"+ 
          "<bean:message key="common.button.submit" bundle="common"/>" ;   
        if(confirm(msg)){
           setSubmitted(); 
           document.forms[0].submit();
        }
    }   
    
   <logic:equal name="from4bond" value="vlan" scope="session">
    function onBack(){
        if (isSubmitted()){
            return;
        }
        setSubmitted();     
            parent.location = "<%=request.getContextPath()%>/nic/nicVlan.do";
    } 
    </logic:equal>
     
</script>
</head>
<body onload="init();setHelpAnchor('s_network_4');">
<logic:equal name="from4bond" value="vlan" scope="session">
    <html:button property="backBtn" onclick="onBack();">
       <bean:message key="common.button.back" bundle="common"/>
    </html:button>
    <br><br>
 </logic:equal>
 <displayerror:error h1_key="nic.h1.servicenetwork"/>
<logic:equal name="havAvailableNic4Bond" value="true">
<html:form action="bondSet.do" onsubmit="return false;" target="_parent">    
    <nested:nest property="bondInfo">
        <nested:hidden property="selectedIFs"/>
        <input type="hidden" name="bondInfo.bondName" value="<bean:write name="bondName" scope="session"/>">
        <input type="hidden" name="from" value="<bean:write name="from4bond" scope="session"/>">
        <input type="hidden" name="primary" value="<nested:write property='primaryIF'/>">
        <table nowrap border="1" class="Vertical">
            <tr>
                <th><bean:message key="nic.bond.name"/></th>
                <td><bean:write name="bondName" scope="session"/></td>
            </tr>
            <tr>
                <th><bean:message key="nic.bond.mode"/></th>
                <td>
                    <nested:radio property="mode" value="active-backup" styleId="modeAB" onclick="onSelectType(true)"/>
                    <label for="modeAB"><bean:message key="nic.bond.mode.AB"/></label> 
                    
                    <nested:radio property="mode" value="balance-alb" styleId="modeBA" onclick="onSelectType(false)"/>
                    <label for="modeBA"><bean:message key="nic.bond.mode.BA"/></label>
                    
                    <nested:radio property="mode" value="802.3ad" styleId="modeLA" onclick="onSelectType(false)"/>
                    <label for="modeLA"><bean:message key="nic.bond.mode.LA"/></label>
                </td>
            </tr>
            <tr>
                <th><bean:message key="nic.bond.member"/></th>
                <td>
                    <table border=0>
                        <tr>
                            <td><bean:message key="nic.bond.available"/></td>
                            <td>&nbsp;</td>
                            <td><bean:message key="nic.bond.selected"/></td>
                        </tr>
                        <tr>
                            <td>
                                <html:select size="4" style="width:180" property="canSelect" ondblclick="onAdd()" onchange="decideButtonStatus()">
                                    <html:options name="nics4create" labelName="nics4Show"/>
                                </html:select>
                            </td>
                            <td align="center">
                                <input type="button" name="add" onclick="onAdd()" ondblclick="onAdd()"
                                    value="<bean:message key="nic.bond.add"/>" >
                                <br><br>
                                <input type="button" name="del" onclick="return onDel()" ondblclick="onDel()"
                                    value="<bean:message key="nic.bond.del"/>" >
                            </td>
                            <td><select size="4" style="width:180" name="selectedNic" ondblclick="onDel()" onchange="decideButtonStatus()"></select></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <th><bean:message key="nic.bond.primary"/></th>
                <td>
                    <nested:select property="primaryIF" >
                        <option value="">
                            <bean:message key="nic.bond.notspecify"/>
                        </option>
                    </nested:select>
                </td>
            </tr>
            <tr>
                <th><bean:message key="nic.bond.interval"/></th>
                <td>
                    <nested:text property="interval" maxlength="6" size="6"/>
                    <bean:message key="nic.bond.msecond"/>
                </td>
            </tr>
        </table>
  </nested:nest>    
</html:form>
    </logic:equal>
    <logic:notEqual name="havAvailableNic4Bond" value="true" >
          <bean:message key="nic.bond.no_available_interface" />      
    </logic:notEqual>
</body>
</html>
