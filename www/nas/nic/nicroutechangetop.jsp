<!--
        Copyright (c) 2005-2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nicroutechangetop.jsp,v 1.4 2006/07/06 07:15:00 wanghb Exp $" -->


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page buffer="32kb" %>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>

<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript" src="../common/validation.js"></script>
<script language="javaScript">

var buttonEnable = 0;
function init(){     
    buttonEnable = 1;
    if((window.parent.frames[1].document)
        &&(window.parent.frames[1].document.forms[0]) ){
        window.parent.frames[1].changeButtonStatus();
    }    
}

 function onChangeItem(){
 	var index = document.addRouteForm.routeList.options.selectedIndex; 	
 	options = document.addRouteForm.routeList.options;
    var target = options[index].value; 
 	var sets = new Array();
 	sets = target.split("|");
 	if(sets[0].search("/")==-1){
 	    if(sets[0].match("default")){
            document.addRouteForm.destRadio[0].checked = 1;
            setDestination("0");  
            document.addRouteForm.network.value = "";
            document.addRouteForm.mask.value = "";           
            document.addRouteForm.host.value = "";
        }else{
            document.addRouteForm.destRadio[1].checked = 1;
            setDestination("1");
            document.addRouteForm.host.value = sets[0];      
            document.addRouteForm.network.value = "";
            document.addRouteForm.mask.value = "";          
        }
 	}else{
 	    document.addRouteForm.destRadio[2].checked = 1;
        setDestination("2");       
        var network;
        var netmask;
        var gateway;
        network = sets[0].substr(0,sets[0].indexOf("/"));
        netmask = sets[0].substr(sets[0].indexOf("/")+1,sets[0].length);         
        netmask = int2mask(netmask);
        document.addRouteForm.network.value = network;
        document.addRouteForm.mask.value = netmask; 
        document.addRouteForm.host.value = "";
 	} 	
 	document.addRouteForm.gateway.value = sets[1]; 	
 	document.addRouteForm.nicNameList.value = sets[2];
    document.addRouteForm.del.disabled = 0;    
}

function onAdd(){     
	 if(document.addRouteForm.destRadio[1].checked) {
    	document.addRouteForm.host.value = trim(document.addRouteForm.host.value);
        if (!checkIP(document.addRouteForm.host.value)){
            alert("<bean:message key="alert.message.host.invalid"/>");
            document.addRouteForm.host.focus();
            return false;
        }
        if(document.addRouteForm.host.value == "0.0.0.0"){
            alert('<bean:message key="alert.message.ipallzero" />');
            document.addRouteForm.host.focus();
            return false;
        }
    }else if(document.addRouteForm.destRadio[2].checked){
        //check network
        document.addRouteForm.network.value = trim(document.addRouteForm.network.value);
        if (!checkIP(document.addRouteForm.network.value)){
            alert("<bean:message key="alert.message.network.invalid"/>");
            document.addRouteForm.network.focus();
            return false;
        }    
        if(document.addRouteForm.network.value == "0.0.0.0"){
            alert('<bean:message key="alert.message.ipallzero" />');
            document.addRouteForm.network.focus();
            return false;
        }
        //check mask
        document.addRouteForm.mask.value = trim(document.addRouteForm.mask.value);
        if(mask2int(document.addRouteForm.mask.value)==-1){
            alert("<bean:message key="alert.message.netmask.invalid"/>");
            document.addRouteForm.mask.focus();
            return false;
        }
        document.addRouteForm.network.value = getNetwork(document.addRouteForm.network.value,document.addRouteForm.mask.value);
    }   
    //check gateway
    document.addRouteForm.gateway.value = trim(document.addRouteForm.gateway.value);    
      var tempGateway = document.addRouteForm.gateway.value;     
      if (!checkIP(tempGateway)|| tempGateway == "0.0.0.0"){
            alert("<bean:message key="alert.message.gateway.invalid"/>");
      document.addRouteForm.gateway.focus();
      return false;
    }   
    var destination;
    var gateway;
    var nicname;
    if(document.addRouteForm.destRadio[0].checked){
        destination = "default";             
    }else if(document.addRouteForm.destRadio[1].checked){
      	destination = document.addRouteForm.host.value;       	
    } else if(document.addRouteForm.destRadio[2].checked){
       	destination = document.addRouteForm.network.value + "/" + mask2int(document.addRouteForm.mask.value);       	
    } 
    gateway = document.addRouteForm.gateway.value;   
    nicname = document.addRouteForm.nicNameList.value;   
    if(!addToList(destination,gateway,nicname)){
        alert("<bean:message key="alert.message.samerouting"/>");
        return false;
    }    
    onChangeItem();
}

function addToList(destination,gateway,nicname){
	var str = destination + "|" + gateway+"|"+nicname;
	var i;
	var v1 = new Array();
	var v2 = new Array();
	v1 = str.split("|");
    for(i=0;i<document.addRouteForm.routeList.options.length;i++){        
        v2 = document.addRouteForm.routeList.options[i].value.split("|");
        if(v1[0]==v2[0] && v1[2]==v2[2]){
            return false;
        } 
    }    
    document.addRouteForm.routeList.options.length ++;
    oOption = document.addRouteForm.routeList.options[document.addRouteForm.routeList.options.length-1];	
	oOption.text = destination + " " + gateway+" "+nicname;
    oOption.value = str;	
    oOption.selected =1;
	return true;
}

function setDestination(value){ 
 switch(value){
    case "1":            
           document.addRouteForm.network.disabled=1;
           document.addRouteForm.mask.disabled=1;
           document.addRouteForm.host.disabled=0;           
           break;
    case "2":
            document.addRouteForm.network.disabled=0;
            document.addRouteForm.mask.disabled=0;
            document.addRouteForm.host.disabled=1;            
            break;
      default:
          document.addRouteForm.network.disabled=1;
          document.addRouteForm.mask.disabled=1;
          document.addRouteForm.host.disabled=1;          
 }
}

function autoSetMask(){
    if (trim(document.addRouteForm.mask.value) != ""
        || !checkIP(trim(document.addRouteForm.network.value))
        || trim(document.addRouteForm.network.value) == "0.0.0.0"){ 
        return false;         
    }    
    document.addRouteForm.mask.value = getMaskFromIP(trim(document.addRouteForm.network.value)) ;
}

function onDel(){	    
	var options = document.addRouteForm.routeList.options;
    var index = options.selectedIndex;
    var lastIndex = index;
    for(; index < options.length-1; index++){
        options[index].value = options[index+1].value;
        options[index].text = options[index+1].text;
    }
    options.length--;   
    if(options.length == 0){        
        setDefault();
        return false;
    }  
    if(lastIndex == options.length){
        options.selectedIndex = lastIndex -1;
        onChangeItem();
    }else if(lastIndex < options.length){
        options.selectedIndex = lastIndex;
        onChangeItem();
    }   
}

function setDefault(){    
    document.addRouteForm.destRadio[0].checked = 1;
    setDestination("0");
    document.addRouteForm.gateway.value = "";
    document.addRouteForm.network.value = "";
    document.addRouteForm.mask.value = "";
    document.addRouteForm.host.value = "";
    document.addRouteForm.nicNameList.options.selectedIndex = 0;
    document.addRouteForm.routeList.options.selectedIndex = -1;
    document.addRouteForm.del.disabled = 1;   
}

</script>
<title></title>
</head>

<body onload="displayAlert();setDefault();init();setHelpAnchor('routing_2');" onUnload="closeDetailErrorWin();">
    <form name="addRouteForm" method="post">         	
    	<displayerror:error h1_key="nic.h1.routing"/>
        <br>              
         <table border="1" class=Vertical>
            <tr>
                <th rowspan="3"><bean:message key="nic.route.table.head.destination" /></th>
                <td >
                &nbsp;<input type="radio" name="destRadio" id="defaultID" value="0"
                    onclick="setDestination(this.value)" />
                <label for="defaultID"><bean:message key="nic.route.table.head.default" /></label>
                </td>
            </tr>
            <tr>
              <td >&nbsp;<input type="radio" name="destRadio" id="hostID" value="1" onclick="setDestination(this.value)"/>
              <label for="hostID"><bean:message key="nic.route.table.head.ip" /></label>&nbsp;
              <input type="text" name="host"  maxlength="15" size="15" 
                    value="" onfocus="if (this.disabled) this.blur();">&nbsp; </td>
            </tr>
            <tr><td >
            <table>
               <tr>
                <td rowspan="2">
                <input type="radio" name="destRadio" id="networkID" value="2" onclick="setDestination(this.value)" />
                </td>
                <td>                
                    <label for="networkID"><bean:message key="nic.route.table.head.network" /></label></td><td>
                    <input type="text" name="network" maxlength="15" size="15" 
                        value=""  />
                   </td></tr>
                   <tr><td>
                        <label for="networkID"><bean:message key="nic.route.table.head.netmask" /></label></td><td>
                        <input type="text" name="mask" maxlength="15" size="15" 
                            onfocus='autoSetMask()'/>
                </td></tr>
                </table>                
                </td>
            </tr>
            <tr>
                <th><bean:message key="nic.list.table.head.gateway" /></th>
                <td >
                    <input type="text" name="gateway" 
                        value="" maxlength="15" size="15"/>
                </td>
            </tr>
            <tr>
                <th><bean:message key="nic.route.table.head.nicname" /></th>
                <td >
                    <select name="nicNameList">                       
                    <logic:notEmpty name="nicList">              
                        <logic:iterate id="nicnames" indexId="i" name = "nicList">	                      
                            <option value="<bean:write name="nicnames"/>" ><bean:write name="nicnames"/></option>        
                        </logic:iterate>
                    </logic:notEmpty>
                    </select>
                </td>
            </tr>   
            <tr><td colspan="2">
      <input type="button" name="add" 
                    value="<bean:message key="nic.route.add"/>" onclick="onAdd()"/>
       <table><tr><td>
          <select name="routeList" size=5 onchange="onChangeItem()" style="width:330">
          <logic:notEmpty name="routeList">  
            <bean:define id="routeDetail"  name="routeList"  />
            <logic:iterate id="detail" indexId="i" name = "routeDetail">
              <bean:define id="destination" name="detail" property="destination" type="java.lang.String"/>
              <bean:define id="gateway" name="detail" property="gateway" type="java.lang.String"/>
              <bean:define id="nicName" name="detail" property="nicName" type="java.lang.String"/>
              <option value="<bean:write name="destination"/>|<bean:write name="gateway"/>|<bean:write name="nicName"/>"><bean:write name="destination"/> <bean:write name="gateway"/> <bean:write name="nicName"/></option>        
            </logic:iterate>
          </logic:notEmpty>
          </select>
       </td></tr></table>
        <input type="button" name="del" 
                    value="<bean:message key="common.button.delete" bundle="common"/>" disabled="1"
                    onclick="onDel();"/> &nbsp;&nbsp;                            
	  </td>
   </tr>
</table>
</form>
</body>
</html>
