<!--
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: communitysettop.jsp,v 1.11 2008/09/27 01:16:58 lil Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.nec.nsgui.action.snmp.SnmpActionConst"%>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>

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
    <script language="JavaScript">
        <bean:define id="validChar" value="<%=SnmpActionConst.validCommunity%>" type="java.lang.String"/>
        <bean:define id="operate" name="communityForm" property="operate"/>
        var buttonEnable = 0;
        
        function init(){
            setHelp();
            document.forms[1].sourceList.options.length = 0;
            
            var str = gInputTrim(document.forms[0].elements["communityInfo.sourceList"].value);
            if( str!="" ){
                var tmpArray = new Array();
                tmpArray = str.split("\n");
                var options = document.forms[1].sourceList.options;
                for (var index=0 ; index<tmpArray.length; index++) {
                    options.length++;
                    var optionValue = gInputTrim(tmpArray[index]);
                    options[index].value = optionValue;
                    options[index].text = getOptionText(optionValue);
                }
                buttonEnable = 1;
                selectOneItem(0,true);
                document.forms[1].editItem.disabled = false;
                document.forms[1].deleteItem.disabled = false;
            }else{
                document.forms[1].addItem.disabled = true;
                document.forms[1].editItem.disabled = true;
                document.forms[1].deleteItem.disabled = true;
                document.forms[1].upItem.disabled = true;
                document.forms[1].downItem.disabled = true;
                document.forms[1].read.checked = true;
                document.forms[1].write.checked = false;
                document.forms[1].trap.checked = false;
                document.forms[1].snmpversionv1.checked=true;
                document.forms[1].snmpversionv2c.checked=false;
                buttonEnable = 0;
            }
            
            <logic:equal name="operate" value="add">
                document.forms[0].elements["communityInfo.communityName"].focus();
            </logic:equal>
            <logic:equal name="operate" value="modify">
                document.forms[1].elements["sourcetext"].focus();
            </logic:equal>
                        
            if( (window.parent.bottomframe.document)
                    &&(window.parent.bottomframe.document.forms[0]) ){
                window.parent.bottomframe.changeButtonStatus();
            }
            displayAlert();
            <logic:equal name="SESSION_SNMP_NAMECHANGEFAILED" value="true">
                <%NSActionUtil.setSessionAttribute( request,SnmpActionConst.SESSION_SNMP_NAMECHANGEFAILED,null );%>
                var confirmMsg = '<bean:message key="snmp.community.confirm.forceModify"/>';
                if(confirm(confirmMsg)){
                    document.forms[0].elements["forceModify"].value="true";
                    document.forms[0].submit();
                    setSubmitted();
                }
            </logic:equal>
        }
        function setHelp(){
            <logic:equal name="operate" value="add">
                setHelpAnchor('system_snmp_4');
            </logic:equal>
            <logic:equal name="operate" value="modify">
                setHelpAnchor('system_snmp_5');
            </logic:equal>
        }
        function onBack(){
            if (isSubmitted()){
                return false;
            }
            setSubmitted();
            parent.location="communityListFrame.do";
            return true;
        }
        function onChangeSource(){
            document.forms[1].addItem.disabled = true;
            if(document.forms[1].sourcetext.value != ""){
                document.forms[1].addItem.disabled = false;
            }
        }
        function onAddItem(){
            document.forms[1].sourcetext.value = gInputTrim(document.forms[1].sourcetext.value);
            var communitySource = document.forms[1].sourcetext.value;
            var options = document.forms[1].sourceList.options;
            var trapChecked = document.forms[1].trap.checked;
           	var checkSourceResult= checkSource(communitySource, trapChecked);
            if(checkSourceResult == 1){
  			     alert('<bean:message key ="snmp.community.alert.invalidTrapDestination"/>');
       			 return false;
            }else if (checkSourceResult == -1){
            	  alert('<bean:message key ="snmp.community.alert.invalidSource"/>');
            	  return false;
            }else if( parseInt(document.forms[0].allSourceNo.value) >= parseInt(document.forms[0].commMax.value) ){
                alert('<bean:message key="snmp.snmplist.community.alert.exceeded" arg0="\'+document.forms[0].commMax.value+\'"/>');
                return false;
            }else if(document.forms[1].snmpversionv1.checked == false&& document.forms[1].snmpversionv2c.checked == false ){
            	alert('<bean:message key="snmp.community.alert.versionNoChecked"/>');
            	return false;      	
            }else{    
                if(options.length == 0){
                    document.forms[1].deleteItem.disabled = false;
                    document.forms[1].editItem.disabled = false;
                    parent.bottomframe.document.forms[0].set.disabled = false;
                }
                options.length++;
                var optionValue = getOptionValue();
                options[options.length-1].value = optionValue;
                options[options.length-1].text = getOptionText(optionValue);
                selectOneItem(options.length-1,false);
                document.forms[0].allSourceNo.value = parseInt(document.forms[0].allSourceNo.value) + 1;
                return true;
            }
        }
        function onEditItem(){
            document.forms[1].sourcetext.value = gInputTrim(document.forms[1].sourcetext.value);
            var communitySource = document.forms[1].sourcetext.value;
            var trapChecked = document.forms[1].trap.checked;
            var checkSourceResult = checkSource(communitySource, trapChecked);         
            if(checkSourceResult == 1){
  			     alert('<bean:message key="snmp.community.alert.invalidTrapDestination"/>');
       			 return false;
            }else if (checkSourceResult == -1){
            	  alert('<bean:message key="snmp.community.alert.invalidSource"/>');
            	  return false;
			}else if(document.forms[1].snmpversionv1.checked == false&& document.forms[1].snmpversionv2c.checked == false ){
            	alert('<bean:message key="snmp.community.alert.versionNoChecked"/>');
            	return false;
            	
            }else{
                var options = document.forms[1].sourceList.options;
                var index = options.selectedIndex;
                var optionValue = getOptionValue();
                options[index].value = optionValue;
                options[index].text = getOptionText(optionValue);
                selectOneItem(index,false);
                return true;
            }
        }
        function onDeleteItem(){
            var options = document.forms[1].sourceList.options;
            var index = options.selectedIndex;
            var lastIndex = index;
            for(; index < options.length-1; index++){
                options[index].value = options[index+1].value;
                options[index].text = options[index+1].text;
            }
            document.forms[0].allSourceNo.value = parseInt(document.forms[0].allSourceNo.value) - 1;
            options.length--;
            if(options.length == 0){
                document.forms[1].deleteItem.disabled = true;
                document.forms[1].editItem.disabled = true;
                parent.bottomframe.document.forms[0].set.disabled = true;
                return;
            }
            if(lastIndex == options.length && lastIndex != 0){
                selectOneItem(lastIndex-1,true);
            }else{
                selectOneItem(lastIndex,true);
            }
        }
        function onUpItem(){
            var options = document.forms[1].sourceList.options;
            var index = options.selectedIndex;
            swapItem(options[index],options[index-1]);
            selectOneItem(index-1,false);
        }
        function onDownItem(){
            var options = document.forms[1].sourceList.options;
            var index = options.selectedIndex;
            swapItem(options[index],options[index+1]);
            selectOneItem(index+1,false);
        }
        function swapItem(item1,item2){
            var value = item1.value;
            var text = item1.text;
            item1.value = item2.value;
            item1.text = item2.text;
            item2.value = value;
            item2.text = text;
        }
        function getOptionValue(){
            var readValue = "false";
            var writeValue = "false";
            var trapValue = "false";
            var snmpVersion = "v1";
           
   	        var communitySource = document.forms[1].sourcetext.value;
   	        var tmpArrs = communitySource.match(/^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$/);
   	        if(tmpArrs != null && tmpArrs.length == 5){
   	            tmpArrs.shift();
   	            for(var idx = 0; idx < 4; idx++){
   	                tmpArrs[idx] = tmpArrs[idx].replace(/^0{1,2}(\d+)$/, "$1");
   	            }
   	            communitySource = tmpArrs.join(".");
   	            document.forms[1].sourcetext.value = communitySource;
   	        }
            if(document.forms[1].read.checked == true){
                readValue = "true";
            }
            if(document.forms[1].write.checked == true){
                writeValue = "true";
            }
            if(document.forms[1].trap.checked == true){
                trapValue = "true";
            }
           
            if(document.forms[1].snmpversionv2c.checked == true && document.forms[1].snmpversionv1.checked == false){
            	snmpVersion= "v2c";
            }
            if(document.forms[1].snmpversionv1.checked ==true && document.forms[1].snmpversionv2c.checked ==true){
            	snmpVersion= "v1,v2c"
            }
            var optionValue = communitySource+" "+readValue+" "+writeValue+" "+trapValue+" "+snmpVersion;            
            return optionValue;
        }
        function getOptionText(value){
            var tempArray = value.split(" ");
            var optionText = tempArray[0] + '(';
            if(tempArray[1] == "true" ){
                 optionText = optionText + "<bean:message key="snmp.community.option_read"/>"  +  " " ;
            }
            if(tempArray[2] == "true" ){  
                 optionText = optionText + "<bean:message key="snmp.community.option_write"/>" +  " ";
            }
            if(tempArray[3] == "true" ){
				 optionText = optionText + "<bean:message key="snmp.community.option_trap"/>" +  " ";
            }
            
  			optionText =  optionText +tempArray[4]+ ')';
            return optionText;
        }
        function selectOneItem(index,refresh){
            var options = document.forms[1].sourceList.options;
            options.selectedIndex = index;
            if(index == options.length-1){
                document.forms[1].downItem.disabled = true;
            }else{
                document.forms[1].downItem.disabled = false;
            }
            if(index == 0){
                document.forms[1].upItem.disabled = true;
            }else{
                document.forms[1].upItem.disabled = false;
            }
            if(refresh){
                refreshOptions();
            }
        }
        function refreshOptions(){
            var options = document.forms[1].sourceList.options;
            var tempArray = options[options.selectedIndex].value.split(" ");
            document.forms[1].sourcetext.value = tempArray[0];
            var readValue = tempArray[1];
            var writeValue = tempArray[2];
            var trapValue = tempArray[3];
            var snmpVersion = tempArray[4];
            
            if(readValue == "true"){
                document.forms[1].read.checked = true;
            }else {
             document.forms[1].read.checked = false;
            }
            if(writeValue == "true"){
                document.forms[1].write.checked = true;
            }else {
                document.forms[1].write.checked = false;
            }
            if(trapValue == "true"){
                document.forms[1].trap.checked = true;
            }else {
                document.forms[1].trap.checked = false;
            }
	        if(snmpVersion == "v1"){
            	document.forms[1].snmpversionv1.checked = true;
 				document.forms[1].snmpversionv2c.checked = false;
 			}else if(snmpVersion == "v2c"){
            	document.forms[1].snmpversionv2c.checked = true;
            	document.forms[1].snmpversionv1.checked = false;
            }else if(snmpVersion == "v1,v2c"){
                document.forms[1].snmpversionv1.checked = true;
            	document.forms[1].snmpversionv2c.checked = true;
          	}else{
            	document.forms[1].snmpversionv1.checked = false;
            	document.forms[1].snmpversionv2c.checked = false;
            }
      }
        function submitProcess(){
            if(isSubmitted()){
                return false;
            }
            if( document.forms[0].elements["operation"].value == "add" && (!checkCommunity()) ){
                return false;
            }
            var options = document.forms[1].sourceList.options;
            var tempListString = options[0].value;
            for(var index=1;index < options.length; index++){
                tempListString = tempListString + "\n" + options[index].value;
            }
            document.forms[0].elements["communityInfo.sourceList"].value = tempListString;
            var confirmMsg = '<bean:message key="common.confirm" bundle="common"/>\r\n'
                    +'<bean:message key="common.confirm.action" bundle="common"/>'
                    +'<bean:message key="common.button.submit" bundle="common"/>';
            if(!confirm(confirmMsg)){
                return false;
            }
            setSubmitted();
            return true;
        }
        function checkCommunity(){
            var allCommunity = document.forms[0].elements["allCommunity"].value;
            var invalidSet = /[^a-zA-Z0-9~`!@#$%^&*()_+=}\]|{\['\":;?\/>,<.\\-]/g;
            var tempArray = allCommunity.split(" ");
            var communityName = gInputTrim(document.forms[0].elements["communityInfo.communityName"].value);
            if(!isValid(communityName,invalidSet,26,1)){
                alert('<bean:message key="common.alert.failed" bundle="common"/>\r\n'
                        + '<bean:message key="snmp.community.alert.invalidCommunity" arg0="<%=validChar%>"/>');
                return false;
            }
            for (var index=0 ; index<tempArray.length; index++) {
                if( tempArray[index] == communityName ){
                    alert('<bean:message key="common.alert.failed" bundle="common"/>\r\n'
                            + '<bean:message key="snmp.community.alert.communityExist"/>');
                    return false;
                }
            }
            document.forms[0].elements["communityInfo.communityName"].value = communityName;
            return true;
        }
        
        function checkSource(sourceValue, trapChecked) {
            
            if(sourceValue == ""){
                return -1;
            }
            if(sourceValue.search(/[^a-zA-Z0-9.-]/g) == -1){  //match hostname and Ip Address
                if (sourceValue.charAt(0) == "."){
                    return -1;
                }else if (sourceValue == "default"){
                    return -1;
                }else{
                	return 0;
                }
                
            }else{
                if( sourceValue.search(/[^0-9.\/]/g) == -1 ){  //match network address 
                    if(trapChecked == false ){
                    	if( checkIPMask(sourceValue) ){
                        	if(sourceValue.indexOf("/") == -1){
                            	return 0;
                        	}else{
                            	if(checkIPMatchMask(sourceValue)){
                            		return 0;
                            	}else{
                            		return -1;
                            	}
                        	}
                    	}else{
                        	return -1;
                    	}
                  	}else{
                    	return 1;
                    }
                }
            }
            return -1;
        }               
        var pupUpWinName = null;
        function onNavigator(){
            if (pupUpWinName == null || pupUpWinName.closed){
                pupUpWinName = window.open("sourceListNavigator.do","selectSource_navigator",
                        "resizable=yes,toolbar=no,menubar=no,scrollbar=no,width=400,height=400");
                pupUpWinName.focus();
            }else{
                pupUpWinName.focus();
            }
        }
        function closePopupWin(){
            if (pupUpWinName != null && !pupUpWinName.closed){
                pupUpWinName.close();
            }
        }      
    </script>
</head>

<body onload="init();" onUnload="closeDetailErrorWin();closePopupWin();">

<input type="button" onclick="return onBack();" value='<bean:message key="common.button.back" bundle="common"/>'>

<displayerror:error h1_key="snmp.common.h1"/>

<logic:equal name="operate" value="add">
    <h3 class="title"> <bean:message key="snmp.community.h3.add"/> </h3>
</logic:equal>
<logic:equal name="operate" value="modify">
    <h3 class="title"> <bean:message key="snmp.community.h3.modify"/> </h3>
</logic:equal>

<html:form action="community.do" target="_parent" onsubmit="return false;">
    <html:hidden property="operate"/>
    <html:hidden property="forceModify" value="false"/>
    <html:hidden property="allSourceNo"/>
    <html:hidden property="allCommunity"/>
    <html:hidden property="commMax"/>
    <nested:nest property="communityInfo">
        <nested:hidden property="sourceList"/>
        <table border="1"  class="Vertical">
        <tr>
            <th>
                <bean:message key="snmp.community.th_communityname"/>
            </th>
            <td>
                <logic:equal name="operate" value="add">
                    <nested:text property="communityName" size="30" maxlength="26"/>
                    <input type="hidden" name="operation" value="add"/>
                </logic:equal>
                <logic:equal name="operate" value="modify">
                    <nested:hidden property="communityName"/>
                	<nested:write property="communityName"/>
                	<input type="hidden" name="operation" value="modify"/>
                </logic:equal>
            </td>
        </tr>
        </table><br>
    </nested:nest>
</html:form>

<form onsubmit="return false;">
<table><tr><td>
<table border="1"  class="Vertical">
    <tr>
        <th>
            <bean:message key="snmp.community.th_source"/>
        </th>
        <td>
            <input type="text" name="sourcetext"  size="30" maxlength="255" 
                    onchange="onChangeSource()" onkeyup="onChangeSource()" onblur="onChangeSource()" />
            <input type="button" name="dirButton" value='<bean:message key="common.button.browse2" bundle="common"/>'  onClick= "onNavigator()"/>
        </td>
    </tr>
    <tr>
        <th>
            <bean:message key="snmp.community.th_access"/>
        </th>
        <td>
            <input type="checkbox" name="read" id="readAccess" value="true"/>
            <label for="readAccess"><bean:message key="snmp.community.readLabel"/></label>&nbsp;
            <input type="checkbox" name="write" id="writeAccess" value="true"  />
            <label for="writeAccess"><bean:message key="snmp.community.writeLabel" /></label>&nbsp;
            
        </td>
    </tr>
    
    <tr>
    <th>
       	  <bean:message key="snmp.community.th_trap"/>
    </th>
    <td>
        <input type="checkbox" name="trap" id="notifyAccess" value="true"  />
        <label for="notifyAccess"><bean:message key="snmp.community.trapLabel" /></label><BR>
		[<FONT class="advice"><bean:message key="snmp.community.trapInstructionInfo" /></FONT>]
    </td>
    </tr>
    
    <tr>
    <th>
       <bean:message key="snmp.community.th_snmpversion"/>
    </th>
    <td>
       <input type="checkbox" name="snmpversionv1" value="v1" id="v1">
         <label for="v1"><bean:message key="snmp.community.snmpv1" /></label>
       <input type="checkbox" name="snmpversionv2c" value="v2c" id="v2c">
         <label for="v2c"><bean:message key="snmp.community.snmpv2c" /></label></td>
	</td>
    </tr>
</table>

<p>
<input type="button" name="addItem" value='&darr;<bean:message key="common.button.add" bundle="common"/>' 
        onclick="return onAddItem();">&nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" name="editItem" value='<bean:message key="common.button.modify" bundle="common"/>' 
        onclick="return onEditItem();">
<p>

<bean:message key="snmp.community.sourcelist"/>
<br>

<table>
    <tr>
        <td>
            <select name="sourceList" size=5 onchange="selectOneItem(document.forms[1].sourceList.options.selectedIndex,true);"/>
        </td>
    </tr>
</table>

<input type="button" name="deleteItem"  value='<bean:message key="common.button.delete" bundle="common"/>' 
        onclick="onDeleteItem()">&nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" name="upItem"      value='<bean:message key="snmp.community.buttom_up"/>'
        onclick="onUpItem()">
<input type="button" name="downItem"    value='<bean:message key="snmp.community.buttom_down"/>'
        onclick="onDownItem()">
</td></tr></table>
</form>

</body>
</html>