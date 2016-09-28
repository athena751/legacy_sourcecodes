<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: niclisttop.jsp,v 1.10 2007/09/12 07:04:37 fengmh Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.taglib.nssorttab.*,java.util.*"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ taglib uri="taglib-sorttable" prefix="nssorttab" %>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror"%>

<html>
<head>
<%@include file="../../common/head.jsp" %>  
<html:base/>
<script language="JavaScript" src="../../common/common.js"></script>
<script language="javascript">
var buttonEnable = 0;
var ignoreList = "<bean:write name="nic_ignoreList"/>";
function init(){
   <logic:notEmpty name="nicList" scope="request">      
         buttonEnable = 1;
         if(window.parent.frames[1]){
             if((window.parent.frames[1].document)
                    &&(window.parent.frames[1].document.forms[0]) ){
                window.parent.frames[1].changeButtonStatus();
            }    
         } 
   </logic:notEmpty> 
   <logic:present name="Alert4PartnerNode">
        alert("<bean:message key="common.alert.done" bundle="common"/>" +"\r\n"+"<bean:message key="nic.alert.deletepartner"/>");
   </logic:present>        
}

/*
     The onRadioChange function *****
     the value's format is defined as :interfaceName#isSet#isVlan#hasVlan#isIPAlias#hasIPAlias#type
     such as : eth0#1#0#0#0#0#1
               bond1#1#0#1#1#0#0
               bond1.1#1#1#0#0#1#0
    the cases:
        if isSet is true, then delete button is enabled, otherwise diabled
        if isVlan is true, then communicationmode button is disabled, otherwise enabled
        if hasVlan is true, then change button is enabled, otherwise diabled
        if isIPAlias is true, then communicationmode button is disabled, ifdel is checked and disabled
        if hasIPAlias is true, then when delete this I/F, alert
        if type is TOE, then communicationmode button is disabled
*/
function onRadioChange(value){    
    if((window.parent.frames[1].document)
                    &&(window.parent.frames[1].document.forms[0])){
        var v = new Array();    
        v = value.split("#");        
        document.forms[0].ipSet.value = "0"; 
        if(v.length == 7) {
            if(v[2] == "1" || v[4] == "1" || v[6] == "1"){
                if(window.parent.frames[1].document.forms[0].communicationmode)
                    window.parent.frames[1].document.forms[0].communicationmode.disabled = 1;                          
            }else{
                if(window.parent.frames[1].document.forms[0].communicationmode)
                    window.parent.frames[1].document.forms[0].communicationmode.disabled = 0;               
            }
            if(v[4] == "1") {
                if(window.parent.frames[1].document.forms[0].ifdel) {
                    window.parent.frames[1].document.forms[0].ifdel.checked = 1;
                }
            } else {
                if(window.parent.frames[1].document.forms[0].ifdel) {
                    window.parent.frames[1].document.forms[0].ifdel.checked = 0;
                }
            }
            if((!v[0].match(/^bond/) && v[2] == "0") || v[3] =="1" || v[4] == "1") {
                if(window.parent.frames[1].document.forms[0].ifdel){
                    window.parent.frames[1].document.forms[0].ifdel.disabled = 1;                                      
                }
            } else {
                if(window.parent.frames[1].document.forms[0].ifdel){
                    window.parent.frames[1].document.forms[0].ifdel.disabled = 0;                                      
                }
            }
            
            if(v[3] == "1"){
                if(window.parent.frames[1].document.forms[0].change)
                    window.parent.frames[1].document.forms[0].change.disabled = 1;
                 if(window.parent.frames[1].document.forms[0].del)
                    window.parent.frames[1].document.forms[0].del.disabled = 1;                                                     
            }else{
                if(window.parent.frames[1].document.forms[0].change)
                    window.parent.frames[1].document.forms[0].change.disabled = 0;
                if(window.parent.frames[1].document.forms[0].del)
                    window.parent.frames[1].document.forms[0].del.disabled = 0;                
            }                                    
        }        
    document.forms[0].selectedInterface.value = v[0];    
    document.forms[0].ipSet.value = v[1];
    document.forms[0].isAlias.value = v[4];
    document.forms[0].alias_baseIF.value = v[5];
   }
}

function onRefresh(){
    if(parent.frames[1]){
        if(parent.frames[1].isSubmitted()){
            return false;
        }
        parent.frames[1].setSubmitted();
    }   
    parent.location="/nsadmin/nic/nicList.do";
}
</script>
</head>
<body onload="displayAlert();init();setHelpAnchor('s_network_1');" onUnload="closeDetailErrorWin();">          
    <form name="listForm" method="post">   
        <html:button property="refreshBtn" onclick="onRefresh();">
           <bean:message key="common.button.reload" bundle="common"/>
        </html:button><br>
        <logic:present name="display4maintain" scope="request">
          <br><div class="Warning"><bean:message key="nic.list.display4maintain"/></div>
        </logic:present>
        <displayerror:error h1_key="nic.h1.servicenetwork"/><br>
        <logic:empty name="nicList" scope="request">
              <br><bean:message key="nic.list.nointerface"/>
        </logic:empty>      
        <logic:notEmpty name="nicList">        
        <input type="hidden" name="selectedInterface" /> 
        <input type="hidden" name="ipSet" />
        <input type="hidden" name="alias_baseIF" />
        <input type="hidden" name="isAlias" />
         <bean:define id="nicList" name="nicList" scope="request"/>
         <nssorttab:table  tablemodel="<%=new ListSTModel((Vector)nicList)%>" 
                      id="list1"
                      table="border=1"  >
            
            <nssorttab:column name="radioValue" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.nic.STDataRender4Nic"
                              sortable="no" >
            </nssorttab:column>
            
            <nssorttab:column name="nicName" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.nic.STDataRender4Nic"
                              sortable="no">      
                 <bean:message key="nic.list.table.head.name"/>         
            </nssorttab:column>
            
            <nssorttab:column name="status" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.nic.STDataRender4Nic"
                              sortable="no">    
                  <bean:message key="nic.list.table.head.status"/>           
            </nssorttab:column>     
            
            <nssorttab:column name="ipAddress" 
                              th="com.nec.nsgui.action.nic.STHeaderRender4IP"  
                              td="com.nec.nsgui.action.nic.STDataRender4Nic"
                              sortable="no"> 
            </nssorttab:column>
            
            <nssorttab:column name="gateway" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.nic.STDataRender4Nic"
                              sortable="no">   
                  <bean:message key="nic.list.table.head.gateway"/>           
            </nssorttab:column>            
            
            <nssorttab:column name="mtu" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.nic.STDataRender4Nic"
                              sortable="no">          
                  <bean:message key="nic.list.table.head.mtu"/>    
            </nssorttab:column>
            
             <nssorttab:column name="mode" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.nic.STDataRender4Nic"
                              sortable="no">    
                <bean:message key="nic.list.table.head.extension"/>          
            </nssorttab:column>
            
            <nssorttab:column name="vl" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.nic.STDataRender4Nic"
                              sortable="no">   
                <bean:message key="nic.list.table.head.vl"/>           
            </nssorttab:column>
                
          <logic:equal name="machineSeries" value="Procyon" scope="session">
            <nssorttab:column name="alias" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.nic.STDataRender4Nic"
                              sortable="no">   
                <bean:message key="nic.list.table.head.alias"/>           
            </nssorttab:column>
          </logic:equal>
          
            <nssorttab:column name="construction" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.nic.STDataRender4Nic"
                              sortable="no">   
                <bean:message key="nic.list.table.head.construction"/>          
            </nssorttab:column>
            
         </nssorttab:table>             
       </logic:notEmpty>
        </form>
</body>
</html>