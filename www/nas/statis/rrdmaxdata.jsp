<!--
        Copyright (c) 2005-2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: rrdmaxdata.jsp,v 1.10 2006/03/03 05:10:26 pangqr Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ page import="com.nec.nsgui.action.statis.StatisActionConst" %>
<%@ page import="com.nec.nsgui.model.biz.statis.WatchItemDef" %>

<html>
<HEAD>
<%@include file="../../common/head.jsp" %>
	<title>
	   <bean:message key="statis.y.h2"/>
	</title>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript" src="../common/validation.js"></script>
<bean:define id="isSpecial" name="isSpecial" type="java.lang.String"/>
<bean:define id="unit_type" name="unit_type" type="java.lang.String"/>
<script language="JavaScript">
<logic:notEqual name="unit_type" value="quantity_1024">
  function unitToNum(number,unit){
     if(unit=="-"){
       return parseFloat(number);
     }
     if(unit=="u"){
       return parseFloat(number)*0.000001;
      }
     if(unit=="m"){
       if(number=="99990"){
           return 99.99;
       }           
       return parseFloat(number)*0.001;
     }
     if(unit=="k"){
       return parseFloat(number)*1000;
      }
     if(unit=="M"){
       return parseFloat(number)*1000000;
      }
     if(unit=="G"){
       return parseFloat(number)*1000000000;
      }
  } 
</logic:notEqual>
<logic:equal name="unit_type" value="quantity_1024">
  function unitToNum(number,unit){
     if(unit=="-"){
       return parseFloat(number);
     }
     if(unit=="k"){
       return parseFloat(number)*1024;
      }
     if(unit=="M"){
       return parseFloat(number)*1024*1024;
      }
     if(unit=="G"){
       return parseFloat(number)*1024*1024*1024;
      }
  } 
</logic:equal>
  function checkMax(){
   if(document.forms[0].elements["yInfoBean.maxradio"][1].checked==true){ 
        document.forms[0].elements["yInfoBean.max"].value = gInputTrim(document.forms[0].elements["yInfoBean.max"].value);
        var reg=/^[0-9]+(\.?[0-9]+)?$/;
        var valid=document.forms[0].elements["yInfoBean.max"].value.match(reg);
        if(valid==null){
            return false;
        } 
        var max= parseFloat(document.forms[0].elements["yInfoBean.max"].value);
        if("<bean:write name='isSpecial'/>"=="1"){ 
        	if(max<0.01||max>100){
             	return false;
        	}       	
        }else{
        	if(max<0.01||max>999999.99){
	     		return false;
	    	}
        }           
     }
     return true;
  }
  function checkMin(){
    if(document.forms[0].elements["yInfoBean.minradio"][1].checked==true){
         document.forms[0].elements["yInfoBean.min"].value = gInputTrim(document.forms[0].elements["yInfoBean.min"].value);
         var reg=/^[0-9]+(\.?[0-9]+)?$/;
         var valid=document.forms[0].elements["yInfoBean.min"].value.match(reg);
         if(valid==null){
            return false;
          }
         var min=parseFloat(document.forms[0].elements["yInfoBean.min"].value);      
         if("<bean:write name='isSpecial'/>"=="1"){                 
          	if(min<0||min>99.99){
          		return false;
          	}          	
         }else{
         	if(min<0||min>999999.99){ 
            	    return false;
          	}           
		}
    }
    return true;
 }
 function setValue(){
 	 if(opener==null||opener.document==null||opener.document.forms[1]==null){
 	 	 return false;
 	 }
     if(opener.isSubmitted()){
         return false;
      }
     if(!checkMax()){
       if("<bean:write name='isSpecial'/>"=="1"){
         alert('<bean:message key="common.alert.failed" bundle="common"/>' + '\r\n'+'<bean:message key="statis.y.number.error_isSpecialMax"/>');
       }
       else if("<bean:write name='isSpecial'/>"=="0"){
         alert('<bean:message key="common.alert.failed" bundle="common"/>' + '\r\n'+'<bean:message key="statis.y.number.error_notSpecialMax"/>');
       }
       document.forms[0].elements["yInfoBean.max"].select();
       return false;
     }
     if(!checkMin()){
       if("<bean:write name='isSpecial'/>"=="1"){
         alert('<bean:message key="common.alert.failed" bundle="common"/>' + '\r\n'+'<bean:message key="statis.y.number.error_isSpecialMin"/>');
       }
       else if("<bean:write name='isSpecial'/>"=="0"){
         alert('<bean:message key="common.alert.failed" bundle="common"/>' + '\r\n'+'<bean:message key="statis.y.number.error_notSpecialMin"/>');
       }   
        document.forms[0].elements["yInfoBean.min"].select();  
       return false;
     }
     var max= parseFloat(document.forms[0].elements["yInfoBean.max"].value);
     var min=parseFloat(document.forms[0].elements["yInfoBean.min"].value);
     var maxunit=document.forms[0].elements["yInfoBean.maxunit"].value; 
     var minunit=document.forms[0].elements["yInfoBean.minunit"].value; 
     if(document.forms[0].elements["yInfoBean.maxradio"][1].checked==true
     	&& document.forms[0].elements["yInfoBean.minradio"][1].checked==true){ 
        	if(unitToNum(min,minunit)>=unitToNum(max,maxunit)){      
            	alert('<bean:message key="common.alert.failed" bundle="common"/>' + '\r\n'+'<bean:message key="statis.y.numbercompare.error"/>');
            	return false;
         	}
    }
    if(document.forms[0].elements["yInfoBean.maxradio"][0].checked==true){
        opener.document.forms[1].elements["yInfoBean.max"].value="";
        opener.document.forms[1].elements["yInfoBean.displaymax"].value="default";
        opener.document.forms[1].elements["yInfoBean.maxradio"].value="default";
        opener.document.forms[1].elements["yInfoBean.maxunit"].value="-"; 
    }else{
         opener.document.forms[1].elements["yInfoBean.maxradio"].value="specify"; 
         opener.document.forms[1].elements["yInfoBean.displaymax"].value=unitToNum(max,maxunit); 
         opener.document.forms[1].elements["yInfoBean.max"].value=document.forms[0].elements["yInfoBean.max"].value; 
         opener.document.forms[1].elements["yInfoBean.maxunit"].value=maxunit;    
    }
    if(document.forms[0].elements["yInfoBean.minradio"][0].checked==true){
        opener.document.forms[1].elements["yInfoBean.min"].value="";
        opener.document.forms[1].elements["yInfoBean.displaymin"].value="default";
        opener.document.forms[1].elements["yInfoBean.minradio"].value="default";
        opener.document.forms[1].elements["yInfoBean.minunit"].value="-";  
    }else{
        opener.document.forms[1].elements["yInfoBean.minradio"].value="specify"; 
        opener.document.forms[1].elements["yInfoBean.displaymin"].value=unitToNum(min,minunit); 
        opener.document.forms[1].elements["yInfoBean.min"].value=document.forms[0].elements["yInfoBean.min"].value; 
        opener.document.forms[1].elements["yInfoBean.minunit"].value=minunit; 
    }
    opener.document.forms[1].elements["watchItem"].value=document.forms[0].elements["watchItem"].value;
    opener.document.forms[1].elements["targetId"].value=document.forms[0].elements["targetId"].value;
    opener.document.forms[1].elements["isDetail"].value=document.forms[0].elements["isDetail"].value;
    opener.document.forms[1].submit();
    opener.setSubmitted();
   	window.close();
 }
 function enableMax(){
   document.forms[0].elements["yInfoBean.max"].disabled=false; 
   <logic:equal name="isSpecial" value="0">
     document.forms[0].elements["yInfoBean.maxunit"].disabled=false; 
   </logic:equal>  
 }
 function disableMax(){
   document.forms[0].elements["yInfoBean.max"].disabled=true;
   document.forms[0].elements["yInfoBean.maxunit"].disabled=true; 
 }
 function enableMin(){
   document.forms[0].elements["yInfoBean.min"].disabled=false;
   <logic:equal name="isSpecial" value="0">
    document.forms[0].elements["yInfoBean.minunit"].disabled=false; 
   </logic:equal>   
 }
 function disableMin(){
   document.forms[0].elements["yInfoBean.min"].disabled=true;
   document.forms[0].elements["yInfoBean.minunit"].disabled=true; 
 }
function init(){
 if(document.forms[0].elements["yInfoBean.maxradio"][0].checked==true){
    disableMax();    
 }else{
   if("<bean:write name='isSpecial'/>"=="1"){
      document.forms[0].elements["yInfoBean.maxunit"].disabled=true;
    }
 }
 if(document.forms[0].elements["yInfoBean.minradio"][0].checked==true){
    disableMin();
 }else{
    if("<bean:write name='isSpecial'/>"=="1"){
      document.forms[0].elements["yInfoBean.minunit"].disabled=true;
    }
 }
}
</script>
</HEAD>
<BODY onload="init();">
<h1 class="title"><bean:message name="watchItemDesc"/></h1>
<h2 class="title"><bean:message key="statis.y.h2"/></h2>
<html:form action="changeMax.do?operation=changeMax" method="POST">
<table border=1 class="Vertical">
	<tr>
		<th><bean:message key="statis.y.maxtitle"/></th>
		<td><html:radio property="yInfoBean.maxradio" value="default" styleId="max1" onclick="disableMax()"/>
	<bean:define id="max" name="maxDefined" type="java.lang.String"/>		
		<label for="max1">
			<logic:notEmpty name="max">
			<bean:message key="statis.y.maxdefaultlabel" arg0="<%=max%>"/>
			</logic:notEmpty>
			<logic:empty name="max">
			<bean:message key="statis.y.maxdefaultlabelauto"/>
			</logic:empty>
		</label><br>
			<html:radio property="yInfoBean.maxradio" styleId="max2" value="specify" onclick="enableMax()"/>
		<label for="max2">
          <bean:message key="statis.y.maxspecifylabel"/>
		</label>&nbsp;&nbsp;
		<html:text property="yInfoBean.max" maxlength="9"/>&nbsp;
			<html:select property="yInfoBean.maxunit">
			<logic:equal name="unit_type" value="percentage">
			    <html:option value="-"><bean:message key="statis.y.unit.none"/></html:option>
			</logic:equal>
			<logic:equal name="unit_type" value="quantity_1000_decimal">
			    <html:option value="u"><bean:message key="statis.y.unit.u"/></html:option>
			    <html:option value="m"><bean:message key="statis.y.unit.m"/></html:option>
			    <html:option value="-"><bean:message key="statis.y.unit.none"/></html:option>
			    <html:option value="k"><bean:message key="statis.y.unit.k"/></html:option>
			    <html:option value="M"><bean:message key="statis.y.unit.M"/></html:option>
			</logic:equal>				
			<logic:equal name="unit_type" value="quantity_1000">
			    <html:option value="-"><bean:message key="statis.y.unit.none"/></html:option>
			    <html:option value="k"><bean:message key="statis.y.unit.k"/></html:option>
			    <html:option value="M"><bean:message key="statis.y.unit.M"/></html:option>
			    <html:option value="G"><bean:message key="statis.y.unit.G"/></html:option>
			</logic:equal>
			<logic:equal name="unit_type" value="quantity_1024">
			    <html:option value="-"><bean:message key="statis.y.unit.none"/></html:option>
			    <html:option value="k"><bean:message key="statis.y.unit.k_1024"/></html:option>
			    <html:option value="M"><bean:message key="statis.y.unit.M_1024"/></html:option>
			    <html:option value="G"><bean:message key="statis.y.unit.G_1024"/></html:option>
			</logic:equal>							
			</html:select>
			</td>
		</tr>
		<tr>
		<th><bean:message key="statis.y.mintitle"/></th>
			<td><html:radio property="yInfoBean.minradio" styleId="min1" value="default" onclick="disableMin()"/>
	<bean:define id="min" name="minDefined" type="java.lang.String"/>			
			<label for="min1">
			<logic:notEmpty name="min">
			<bean:message key="statis.y.mindefaultlabel" arg0="<%=min%>"/>
			</logic:notEmpty>
			<logic:empty name="min">
			<bean:message key="statis.y.mindefaultlabelauto"/>
			</logic:empty>
			</label><br>
			<html:radio property="yInfoBean.minradio" styleId="min2" value="specify" onclick="enableMin()"/>
			<label for="min2">
			<bean:message key="statis.y.minspecifylabel"/>
			</label>&nbsp;&nbsp;
			<html:text property="yInfoBean.min" maxlength="9"/>&nbsp;			
			<html:select property="yInfoBean.minunit">						
			<logic:equal name="unit_type" value="percentage">
			    <html:option value="-"><bean:message key="statis.y.unit.none"/></html:option>
			</logic:equal>
			<logic:equal name="unit_type" value="quantity_1000_decimal">
			    <html:option value="u"><bean:message key="statis.y.unit.u"/></html:option>
			    <html:option value="m"><bean:message key="statis.y.unit.m"/></html:option>
			    <html:option value="-"><bean:message key="statis.y.unit.none"/></html:option>
			    <html:option value="k"><bean:message key="statis.y.unit.k"/></html:option>
			    <html:option value="M"><bean:message key="statis.y.unit.M"/></html:option>
			</logic:equal>				
			<logic:equal name="unit_type" value="quantity_1000">
			    <html:option value="-"><bean:message key="statis.y.unit.none"/></html:option>
			    <html:option value="k"><bean:message key="statis.y.unit.k"/></html:option>
			    <html:option value="M"><bean:message key="statis.y.unit.M"/></html:option>
			    <html:option value="G"><bean:message key="statis.y.unit.G"/></html:option>
			</logic:equal>
			<logic:equal name="unit_type" value="quantity_1024">
			    <html:option value="-"><bean:message key="statis.y.unit.none"/></html:option>
			    <html:option value="k"><bean:message key="statis.y.unit.k_1024"/></html:option>
			    <html:option value="M"><bean:message key="statis.y.unit.M_1024"/></html:option>
			    <html:option value="G"><bean:message key="statis.y.unit.G_1024"/></html:option>
			</logic:equal>							   				
			</html:select>
			</td>
		</tr>
</table>

<html:hidden property="watchItem"/>
<html:hidden property="targetId"/>
<html:hidden property="isDetail"/>
<br>
<input type="button" value="<bean:message key='statis.y.submit'/>" onclick="return setValue()">
<input type="button" value="<bean:message key='statis.y.close'/>" onclick="window.close();">
</html:form>
</BODY>
</HTML>
