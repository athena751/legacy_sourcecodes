<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
 
<!-- "@(#) $Id: niclistbottom.jsp,v 1.5 2007/08/23 05:19:00 fengmh Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<html>
<HEAD>
<%@include file="../../common/head.jsp" %>  
<html:base/>
<script language="JavaScript" src="../common/common.js"></script>
<script language="javascript">    
     var popUpWinName ;
     function onDetail(){
         var pageleft = (screen.width - 500) / 2;
         var pagetop = (screen.height - 600) / 2;
         popUpWinName = window.open("/nsadmin/common/commonblank.html","nicDetail",
                "resizable=yes,toolbar=no,menubar=no,scrollbar=yes,width=500,height=600"+",top="+pagetop+",left="+pageleft);
          //window.parent.frames[0].dispatchShareInfo();
          document.forms[0].interfaceName.value = window.parent.frames[0].document.forms[0].selectedInterface.value;          
          document.forms[0].action = "nicDetail.do";
          document.forms[0].target = "nicDetail";
          document.forms[0].submit();
          popUpWinName.focus();
    }
    function changeButtonStatus(){ 
        if((parent.frames[0]) && (parent.frames[0].buttonEnable)){
            if(parent.frames[0].buttonEnable == 1){
                document.forms[0].detail.disabled = 0;    
                if(document.forms[0].change) document.forms[0].change.disabled = 0;            
                if(document.forms[0].communicationmode) document.forms[0].communicationmode.disabled = 0;             
                if(document.forms[0].del) document.forms[0].del.disabled = 0; 
                if(document.forms[0].ifdel) document.forms[0].ifdel.disabled = 0; 
            }
           if(parent.frames[0].document.listForm.radioValue[0]){
                var i = 0;
                for(i=0;i<parent.frames[0].document.forms[0].radioValue.length;i++){
                    if(parent.frames[0].document.forms[0].radioValue[i].checked == "1"){
                        parent.frames[0].onRadioChange(parent.frames[0].document.listForm.radioValue[i].value);
                        return true;
                    }
                }         
           }else if(parent.frames[0].document.listForm.radioValue){                                            
                parent.frames[0].onRadioChange(parent.frames[0].document.listForm.radioValue.value);
                return true;   
           }             
        }      
    }      
 
<logic:present name="userinfo" >  
   <logic:equal name="userinfo" value="nsadmin">     
    function disableButtons(){
        document.forms[0].detail.disabled=1;
        document.forms[0].del.disabled=1;    
        document.forms[0].change.disabled=1;
        document.forms[0].communicationmode.disabled=1;  
    }
    
    function onDelete(){   
        if(window.parent.frames[0].document.forms[0].ipSet.value == "0" && (document.forms[0].ifdel.checked == "0"   
           || document.forms[0].ifdel.disabled == "1" )){
            alert("<bean:message key="nic.list.delete.ipnull"/>");
            return false;
        }
        if(window.parent.frames[0].document.forms[0].alias_baseIF.value == "1"){
            alert("<bean:message key="nic.list.delete.alias_baseIF"/>");
            return false;
        }
        var msg="<bean:message key="common.confirm" bundle="common"/>" +"\r\n"+
          "<bean:message key="common.confirm.action" bundle="common"/>"+ 
          "<bean:message key="common.button.delete" bundle="common"/>" + "\r\n"+
          "<bean:message key="nic.h1"/>: " +
          window.parent.frames[0].document.forms[0].selectedInterface.value; 
        
        if(document.forms[0].ifdel.disabled == "0" && document.forms[0].ifdel.checked == "1"){
            var selectedInterface=window.parent.frames[0].document.forms[0].selectedInterface.value;
            if(selectedInterface.match(/^bond\d$/)){                
                var ignoreList=window.parent.frames[0].ignoreList.split(","); 
                var find = false;
                for(var i = 0; i<ignoreList.length; i++){
                    if(selectedInterface == ignoreList[i]){
                        find = true;
                        break;
                    }
                }
                if(find){
                    msg = "<bean:message key="nic.list.deletebond.isIgnored"/>" + "\r\n" +
                        "<bean:message key="common.confirm" bundle="common"/>" +"\r\n" +
                        "<bean:message key="common.confirm.action" bundle="common"/>"+ 
                        "<bean:message key="common.button.delete" bundle="common"/>" + "\r\n"+
                        "<bean:message key="nic.h1"/>: " + selectedInterface;
                }
            }
        }
        if(confirm(msg)){
           disableButtons(); 
           setSubmitted();          
           document.forms[0].interfaceName.value = window.parent.frames[0].document.forms[0].selectedInterface.value;                     
           document.forms[0].action = "dispNicList.do?Operation=nicDelete";
           document.forms[0].target ="_parent";
           document.forms[0].submit();
           return true;
        }else{
          return  false;
        }
    }   
    
    function onChange() {
        document.forms[0].interfaceName.value = window.parent.frames[0].document.forms[0].selectedInterface.value;	
        document.forms[0].action = "interfaceChange.do";
        document.forms[0].target ="_parent";
        document.forms[0].submit();
    }
    
    function onCommunicationMode(){
        document.forms[0].interfaceName.value = window.parent.frames[0].document.forms[0].selectedInterface.value;
        document.forms[0].action = "linkStatus.do";
        document.forms[0].target ="_parent";
        document.forms[0].submit();        
    }
 </logic:equal>   
</logic:present>
</script>
</HEAD>
<body onload ="changeButtonStatus();" onunload="closePopupWin(popUpWinName);">
<form name="interfaceNameForm" target="_parent" method="post" >
    <input type="hidden" name="interfaceName" />      
    <input type="hidden" name="nic_from4change" value="service" />  
    <input name="detail" type="button" value="<bean:message key="common.button.detail2" bundle="common"/>" onclick="onDetail();" disabled/>
<logic:present name="userinfo" >  
   <logic:equal name="userinfo" value="nsadmin">    
    <input name="change" type="button" value="<bean:message key="nic.list.button.value.set"/>" onclick="onChange();" disabled/>
    <input name="communicationmode" type="button" value="<bean:message key="nic.list.button.value.communicationmode"/>" onclick="onCommunicationMode();" disabled/>      
    &nbsp;&nbsp;
    <input name="del" type="button" value="<bean:message key="common.button.delete" bundle="common"/>" onclick="onDelete();" disabled/>
    <input type="checkbox" name="ifdel" id="label_check" value="-ex" disabled/><label
                for="label_check"><bean:message key="nic.list.ifdelete"/></label>
 </logic:equal>   
</logic:present>
</form>    
</body>
</html>