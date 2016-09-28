<!--
        Copyright (c) 2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: niclinkdownconfigtop.jsp,v 1.4 2007/08/28 01:30:57 wanghui Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror"%>

<html:html>
<head>
<%@include file="../../common/head.jsp"%>  
<script language="JavaScript" src="../common/common.js"></script>
<script language="javascript">
var buttonEnable = 0;
var invalidIF="";
 
function onRefresh(){    
    if(isSubmitted()){
        return false;
    }
    setSubmitted();
    window.parent.location="linkdownConfigFrame.do";       
}

function init(){       
    enableSet();   
    initIF();  
    decideButtonStatus();
    changeTakeoverStauts(); 
    displayAlert(); 
    if(invalidIF != ""){        
        alert("<bean:message key="nic.linkdown.ignoreIF.invalidIF"/>" + 
              "\r\n" + invalidIF);       
        return;
    }        
    return;
}

function enableSet() {
    buttonEnable = 1;     
    if(window.parent.frames[1].document && window.parent.frames[1].document.forms[0]) {
        window.parent.frames[1].enableBottomButton();
    }
}

function changeTakeoverStauts(){
    if(document.forms[0].elements["takeOver"].checked == "0") {
        document.forms[0].elements["bondall"].disabled = true;
        document.forms[0].elements["bondeach"].disabled = true;
        document.forms[0].elements["checkInterval"].disabled = true;
        document.forms[0].elements["monitoredIF"].disabled = true;
        document.forms[0].elements["ignoredIF"].disabled = true;
        document.forms[0].elements["add"].disabled = true;
        document.forms[0].elements["del"].disabled = true;

    } else {
        document.forms[0].elements["bondDown"].disabled = false;
        document.forms[0].elements["bondall"].disabled = false;
        document.forms[0].elements["bondeach"].disabled = false;
        document.forms[0].elements["checkInterval"].disabled = false;
        document.forms[0].elements["monitoredIF"].disabled = false;
        document.forms[0].elements["ignoredIF"].disabled = false;
        decideButtonStatus();
    }
}

function initIF(){
    var ignoredStr = document.forms[0].elements["ignoreList"].value;
    var ignoreArray = ignoredStr.split(",");
    var interfaces = "<bean:write name='interfaces'/>";
    var interfaceArray = interfaces.split(",");
    var ipAddress = "<bean:write name='ipAddress'/>";
    var ipArray = ipAddress.split(",");
    var ignoredObj = document.forms[0].elements["ignoredIF"];
    var monitoredObj = document.forms[0].elements["monitoredIF"];
    var find = false;
    if(ignoredStr != null && ignoredStr != ""){
        for(var i = 0; i< ignoreArray.length ; i++){
            var oOption = document.createElement("OPTION");
            find = false;        
            for(var j = 0; j< interfaceArray.length ; j++){
                if(ignoreArray[i] == interfaceArray[j]){
                    oOption.value = interfaceArray[j];
                    oOption.text = interfaceArray[j]+"("+ipArray[j]+")";     
                    interfaceArray[j] = "-1";           
                    find = true;
                    break;
                }
            }   
            if(!find){
                oOption.value = ignoreArray[i] + "#";
                oOption.text = ignoreArray[i]+"(--)";
                if (invalidIF == ""){
                    invalidIF = ignoreArray[i];
                }else{
                    invalidIF = invalidIF + "," + ignoreArray[i];
                } 
            } 
            addObj2Select(ignoredObj,oOption);           
        }   
        if (ignoredObj.length > 0){
            ignoredObj.selectedIndex = 0;
        }
    } 
    for(var i = 0; i< interfaceArray.length ; i++){
        if(interfaceArray[i] != "-1"){
            var oOption = document.createElement("OPTION");
            oOption.text=interfaceArray[i]+"("+ipArray[i]+")";
            oOption.value=interfaceArray[i];
            addObj2Select(monitoredObj, oOption);
        }
    }
    if (monitoredObj.length > 0){
        monitoredObj.selectedIndex = 0;
    }
}

function checkIgnoredIF(){
    invalidIF="";    
    var ignoredObj = document.forms[0].elements["ignoredIF"];
    for(var i = 0; i< ignoredObj.length ; i++){       
        if(ignoredObj.options[i].value.search(/#/) != -1){
            if (invalidIF == ""){
                invalidIF = ignoredObj.options[i].value;
            }else{
                invalidIF = invalidIF + "," + ignoredObj.options[i].value;
            }
        }
    }    
    invalidIF = invalidIF.replace(/#/g, "");
    if(invalidIF != ""){
        return false;
    }    
    return true;
}

function decideButtonStatus(){
    var addButton = document.forms[0].elements["add"];
    var delButton = document.forms[0].elements["del"];
    if ( document.forms[0].elements["monitoredIF"].length  > 0){
        addButton.disabled = false;
    }else{
        addButton.disabled = true;
    }
    if ( document.forms[0].elements["ignoredIF"].length  > 0){
        delButton.disabled = false;
    }else{
        delButton.disabled = true;
    }
}
function selectFirstIF(selectobj){
    if(selectobj.length > 0 && selectobj.selectedIndex < 0){
        selectobj.selectedIndex = 0;
    }
    return;
}
function onAdd(){
    var monitoredObj = document.forms[0].elements["monitoredIF"];
    var ignoredObj = document.forms[0].elements["ignoredIF"];
    var selectId = monitoredObj.selectedIndex;
    if(monitoredObj.options.length == 1) {
        alert("<bean:message key="nic.linkdown.interfaces.addRefuse"/>");
        return;
    }
    if (selectId >= 0){
        var obj = monitoredObj.options[selectId];
        addObj2Select(ignoredObj,obj);        
        monitoredObj.remove(selectId);
        selectId = selectId > (monitoredObj.length - 1 ) ? (monitoredObj.length - 1 ) : selectId;
        if (selectId >= 0){
            monitoredObj.selectedIndex = selectId ;
        }
    }
    selectFirstIF(ignoredObj);
    decideButtonStatus();
}

function addObj2Select (selectObj,optionObj) {       
    selectObj.options.length ++;
    var oOption = selectObj.options[selectObj.options.length - 1];  
    oOption.text = optionObj.text;
    oOption.value = optionObj.value;
}

function onDel(){    
    var monitoredObj = document.forms[0].elements["monitoredIF"];
    var ignoredObj = document.forms[0].elements["ignoredIF"];
    var selectId = ignoredObj.selectedIndex;
    if (selectId >= 0){
        var obj = ignoredObj.options[selectId];             
        if(obj.value.search(/#/) == -1) {        
            addObj2Select(monitoredObj,obj);
        }           
        ignoredObj.remove(selectId);
        selectId = selectId > (ignoredObj.length - 1 ) ? (ignoredObj.length - 1 ) : selectId;
        if (selectId >= 0){
            ignoredObj.selectedIndex = selectId ;
        }
    }
    selectFirstIF(monitoredObj);
    decideButtonStatus();
}
  
function checkTimeInterval(){ 
    var timeStr = trim(document.forms[0].elements["checkInterval"].value);
    document.forms[0].elements["checkInterval"].value = timeStr;
    if(timeStr == ""){
        return false;
    }   
    var invalid = /[^0-9]/g;
    if(timeStr.search(invalid) != -1){
        return false;
    }
    var time = parseInt(timeStr,10);
    if (time > 3600 || time < 1){
        return false;
    }
    document.forms[0].elements["checkInterval"].value = time;
    return true;
}  

function onSet(){
    if (isSubmitted()){
        return;
    }
    
    if (!checkTimeInterval()){
        alert("<bean:message key="nic.linkdown.checkInterval.invalid"/>");
        document.forms[0].elements["checkInterval"].focus();
        return false;
    }

    if(!checkIgnoredIF()){        
        alert("<bean:message key="nic.linkdown.ignoreIF.invalidIF"/>" + 
              "\r\n" + invalidIF);
        return false;
    }
    var ignored="";
    var ignoredObj = document.forms[0].elements["ignoredIF"];
    for ( var i = 0; i< ignoredObj.length ; i++){
        if (ignored == ""){
            ignored = ignoredObj.options[i].value;
        }else{
            ignored += "," + ignoredObj.options[i].value;
        }
    }
    document.forms[0].elements["ignoreList"].value = ignored;
    
    var msg="<bean:message key="common.confirm" bundle="common"/>" +"\r\n"+
          "<bean:message key="common.confirm.action" bundle="common"/>"+ 
          "<bean:message key="common.button.submit" bundle="common"/>" ;   
        if(confirm(msg)){
            setSubmitted(); 
            document.forms[0].submit();
        }
}

</script>
</head>
<body onload="init();setHelpAnchor('s_network_7');" onUnload="closeDetailErrorWin();">
    <html:form action="linkdownConfig.do?operation=setLinkdownInfo" target="_parent" onsubmit="return false;">        
        <html:button property="reload" onclick="onRefresh()">
                <bean:message key="common.button.reload" bundle="common"/>
        </html:button><br><br>
        <displayerror:error h1_key="nic.h1.servicenetwork"/>
        <br>
        <html:hidden property="ignoreList"/>
        <table border="1" class="VerticalTop">
            <tr>
                  <th><bean:message key= "nic.linkdown.takeOver"/></th>
                  <td><html:checkbox property="takeOver" styleId="takeoverlabel" value="yes" onclick="changeTakeoverStauts()"/>
                      <label for="takeoverlabel"><bean:message key="nic.linkdown.checkbox.takeover"/></label></td>
              </tr>
              <tr>
                  <th><bean:message key= "nic.linkdown.bondDown"/></th>
                  <td><html:radio property="bondDown" styleId="bondall" value="all"/>
                      <label for="bondall"><bean:message key="nic.linkdown.radio.bondDown.all"/></label><br>
                      <html:radio property="bondDown" styleId="bondeach" value="each"/>
                      <label for="bondeach"><bean:message key="nic.linkdown.radio.bondDown.each"/></label>
                  </td>
              </tr>
              <tr>
                  <th><bean:message key= "nic.linkdown.checkInterval"/></th>
                  <td><html:text property="checkInterval" size="4" maxlength="4" style="text-align:right"/>
                      <bean:message key= "nic.linkdown.checkInterval.unit"/></td>
              </tr>
              <tr>
                  <th><bean:message key= "nic.linkdown.interfaces"/></th>
                  <td>
                    <table border=0>
                        <tr>
                            <td><bean:message key="nic.linkdown.interfaces.monitored"/></td>
                            <td>&nbsp;</td>
                            <td><bean:message key="nic.linkdown.interfaces.ignored"/></td>
                        </tr>
                        <tr>
                            <td>
                                <select size="4" style="width:180" name="monitoredIF" ondblclick="onAdd()" onchange="decideButtonStatus()">                                    
                                </select>
                            </td>
                            <td align="center">
                                <input type="button" name="add" onclick="onAdd()" ondblclick="onAdd()"
                                    value="<bean:message key="nic.bond.add"/>" >
                                <br><br>
                                <input type="button" name="del" onclick="return onDel()" ondblclick="onDel()"
                                    value="<bean:message key="nic.bond.del"/>" >
                            </td>
                            <td><select size="4" style="width:180" name="ignoredIF" ondblclick="onDel()" onchange="decideButtonStatus()">
                                </select>
                            </td>
                        </tr>
                    </table>
                </td>
              </tr>              
	</html:form>
</body>
</html:html>

