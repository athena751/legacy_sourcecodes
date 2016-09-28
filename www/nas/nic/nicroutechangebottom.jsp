<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nicroutechangebottom.jsp,v 1.3 2005/10/24 04:40:50 dengyp Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="struts-bean" prefix="bean" %>
<html>
<HEAD>
<%@include file="../../common/head.jsp" %>	
<html:base/>
<script language="JavaScript" src="../common/common.js"></script>
<script language="javascript">  
	function onSetting(){    
         if (isSubmitted()){
            return false;
        }
        var msg="<bean:message key="common.confirm" bundle="common"/>" +"\r\n"+
          "<bean:message key="common.confirm.action" bundle="common"/>"+ "<bean:message key="common.button.submit" bundle="common"/>";   
        if(confirm(msg)){
    	   setSubmitted();
    	   var options=parent.frames[0].document.addRouteForm.routeList.options;         	   
       	   var i;
       	   var sets = new Array();
       	   var destinations = "";
       	   var gateways = "";
       	   var nicnames = "";
       	   for(i=0;i<options.length;i++){       	  
           sets = options[i].value.split("|");
           if(sets.length<3) return false;
           destinations += sets[0] + ","; 
           gateways += sets[1] + ",";
           nicnames += sets[2] + ",";        	       
       	   }
       	   destinations = destinations.substring(0,destinations.length-1);
       	   gateways = gateways.substring(0,gateways.length-1);
       	   nicnames = nicnames.substring(0,nicnames.length-1);
       	   document.NicRouteChangeForm.nicNames.value = nicnames;
       	   document.NicRouteChangeForm.destinations.value = destinations;
       	   document.NicRouteChangeForm.gateways.value = gateways;
       	   return true;
       	}        	
     else{
      return  false;
      }
   }
   
function changeButtonStatus(){
   if((parent.frames[0]) && (parent.frames[0].buttonEnable)){
       if(parent.frames[0].buttonEnable == 1){
            document.forms[0].set.disabled = false;               
       }else{
           document.forms[0].set.disabled = true;               
       }
    }
}
</script>
</HEAD>
<body onload ="changeButtonStatus();">
<form name="NicRouteChangeForm" action="dispRouteChange.do?Operation=RouteSet" target="_parent" method="post" onsubmit="return onSetting()">
    <input type="hidden" name="nicNames" />    
    <input type="hidden" name="destinations" />
    <input type="hidden" name="gateways" />   
    <input name="set" type="submit" value="<bean:message key="common.button.submit" bundle="common"/>" disabled/>
</form>    
</body>
</html>