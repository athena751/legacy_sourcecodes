<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nicvlantop.jsp,v 1.4 2007/05/09 06:46:23 wanghb Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror"%>

<html:html lang="true">
<head>
<%@include file="../../common/head.jsp"%>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript" src="../common/validation.js"></script>
<script language="JavaScript">
	var buttonEnable = 0;
	function enableSet() {		
			<logic:notEmpty name="nicNameList4Vlan"> 
			if(document.forms[0].nicNameList.options.length>0){
			     buttonEnable = 1;
			}
			if(window.parent.frames[1].document&&window.parent.frames[1].document.forms[0]) {
				window.parent.frames[1].changeButtonStatus();
			}		
			</logic:notEmpty >
	}
	
	function onBonding(){	  
        if((parent.frames[1] && parent.frames[1].isSubmitted()) || isSubmitted()){
            return false;
        }        
	    if(document.forms[0].availableNicCount4Bond.value <2){
            alert("<bean:message key="alert.message.bond.notenough"/>");    
            return false;
        }
        setSubmitted();    	   
	    document.forms[0].submit();
	}
	
	var vlanName="<logic:present name="vlanName" ><bean:write name="vlanName"/></logic:present>";    
	function init(){
	   <logic:notEmpty name="nicNameList4Vlan"> 	  
    	   if(vlanName!=""){
	           var tmp = new Array();
	           tmp = vlanName.split("\.");
	           if(tmp.length<2) return;
	           document.forms[0].nicNameList.value = tmp[0];
	           document.forms[0].vid.value = tmp[1];	       
	       }	   
	   </logic:notEmpty >      
	}
	
	</script>
</head>
<body onLoad="enableSet();init();displayAlert();setHelpAnchor('s_network_5');" >
<displayerror:error h1_key="nic.h1.servicenetwork" /><br>
<logic:notEmpty name="nicNameList4Vlan"> 
    <form name="interfaceNameForm" action="bondShow.do" method="post" target="_parent" onSubmit="return false;">
        <input type="hidden" name="from4bond" value="vlan" />
        <input type="hidden" name="vlanCount" value="<bean:write name="vlanCount"/>" />      
        <input type="hidden" name="availableNicCount4Bond" value="<bean:write name="availableNicCount4Bond"/>"/> 
        
    	<table border="1" class=Vertical>
		<tr>
			<th align="left"><bean:message key="nic.list.table.head.name" /></th>
			<td align="left">
			   <select name="nicNameList">                       
               <logic:notEmpty name="nicNameList4Vlan">              
                  <logic:iterate id="nicNameList4Vlan" indexId="i" name = "nicNameList4Vlan">                        
                     <option value="<bean:write name="nicNameList4Vlan"/>" ><bean:write name="nicNameList4Vlan"/></option>        
                  </logic:iterate>
               </logic:notEmpty>
               </select>
               <input type="button" name="bond" value="<bean:message key="nic.list.button.value.bonding"/>" onclick="onBonding()" /> 
			</td>
		</tr>	
        <tr>
            <th align="left"><bean:message key="nic.vlan.vid" /></th>
            <td align="left">
             <input type="text" name="vid" value=''
             maxlength="4" size="25" /></td>
        </tr>	
	   </table>
    </form>
    </logic:notEmpty >
    <logic:empty name="nicNameList4Vlan">
    <bean:message key="nic.vlan.no_available_interface" />      
    </logic:empty >
</body>
</html:html>
