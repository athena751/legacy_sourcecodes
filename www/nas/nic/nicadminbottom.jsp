<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
 
<!-- "@(#) $Id: nicadminbottom.jsp,v 1.2 2005/10/24 04:39:19 dengyp Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<html>
<HEAD>
<%@include file="../../common/head.jsp" %>  
<html:base/>
<script language="JavaScript" src="../common/common.js"></script>
<script language="javascript">   
function changeButtonStatus(){
   if((parent.frames[0]) ){
       if(parent.frames[0].buttonEnable){
            document.forms[0].detail.disabled = 0;
            if(document.forms[0].communicationmode) document.forms[0].communicationmode.disabled = 0;
       }else{
            document.forms[0].detail.disabled = 1; 
            if(document.forms[0].communicationmode) document.forms[0].communicationmode.disabled = 1; 
       }
    }
}

var popUpWinName ;
     function onDetail(){
         var pageleft = (screen.width - 500) / 2;
         var pagetop = (screen.height - 600) / 2;
         popUpWinName = window.open("/nsadmin/common/commonblank.html","nicDetail",
                "resizable=yes,toolbar=no,menubar=no,scrollbar=yes,width=500,height=600"+",top="+pagetop+",left="+pageleft );
          //window.parent.frames[0].dispatchShareInfo();          
                             
          document.forms[0].action = "nicDetail.do";
          document.forms[0].target = "nicDetail";
          document.forms[0].submit();
          popUpWinName.focus();
    }

    function onCommunicationMode(){
 
        document.forms[0].action = "linkStatus.do";
        document.forms[0].target ="_parent";
        document.forms[0].submit();        
    }
        
</script>
</HEAD>
<body onload ="changeButtonStatus();" onunload="closePopupWin(popUpWinName);">
<form name="nicadminForm" target="_parent" method="post" >
    <input type="hidden" name="interfaceName" value="bond0"/>  
    <input type="hidden" name="nic_from4change" value="admin" />        
    <input name="detail" type="button" value="<bean:message key="common.button.detail2" bundle="common"/>" onclick="onDetail();" disabled/>
	<logic:present name="userinfo" >  
	   <logic:equal name="userinfo" value="nsadmin">       
	    <input name="communicationmode" type="button" value="<bean:message key="nic.list.button.value.communicationmode"/>" onclick="onCommunicationMode();" disabled/>          
	   </logic:equal>
	</logic:present>
</form>    
</body>
</html>