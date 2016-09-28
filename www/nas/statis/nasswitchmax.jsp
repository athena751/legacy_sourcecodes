<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nasswitchmax.jsp,v 1.3 2005/10/24 12:24:46 pangqr Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ page import="com.nec.nsgui.action.statis.StatisActionConst" %>

<html>
<HEAD>
<%@include file="../../common/head.jsp" %>
	<title>
	   <bean:message key="statis.y.h2"/>
	</title>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">
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
  } 
function checkMax(){
	if(document.forms[0].elements["yInfoBean.maxradio"][1].checked==true){ 
		var reg=/^\d+(\.?\d+)?$/;      
		var valid=document.forms[0].elements["yInfoBean.max"].value.match(reg);
		if(valid==null){
			return false;
		} 
		var max= parseFloat(document.forms[0].elements["yInfoBean.max"].value);        
		if(max<0.01||max>999999.99){
			return false;
		}
	}   
	return true;
}
function checkMin(){
	if(document.forms[0].elements["yInfoBean.minradio"][1].checked==true){
		var reg=/^\d+(\.?\d+)?$/;        
		var valid=document.forms[0].elements["yInfoBean.min"].value.match(reg);
		if(valid==null){
			return false;
		}
		var min=parseFloat(document.forms[0].elements["yInfoBean.min"].value);
		if(min<0||min>999999.99){
			return false;
		}
	}
	return true;
}
function setValue(){
	if(opener.isSubmitted()){
		return false;
	}
	if(!checkMax()){
		alert('<bean:message key="common.alert.failed" bundle="common"/>' + '\r\n'+'<bean:message key="statis.nasswitch.y.number.error_max"/>');
		document.forms[0].elements["yInfoBean.max"].select();
		return false;
     }
	if(!checkMin()){
		alert('<bean:message key="common.alert.failed" bundle="common"/>' + '\r\n'+'<bean:message key="statis.nasswitch.y.number.error_min"/>'); 
        document.forms[0].elements["yInfoBean.min"].select();  
		return false;
	}
	var max= parseFloat(document.forms[0].elements["yInfoBean.max"].value);
	var maxunit=document.forms[0].elements["yInfoBean.maxunit"].value; 
	var min=parseFloat(document.forms[0].elements["yInfoBean.min"].value);
	var minunit=document.forms[0].elements["yInfoBean.minunit"].value; 
	if(document.forms[0].elements["yInfoBean.maxradio"][1].checked==true
		&& document.forms[0].elements["yInfoBean.minradio"][1].checked==true){ 
		if(unitToNum(min,minunit)>=unitToNum(max,maxunit)){      
			alert('<bean:message key="common.alert.failed" bundle="common"/>' + '\r\n'+'<bean:message key="statis.y.numbercompare.error"/>');
			return false;
       }
    }
    if(document.forms[0].elements["yInfoBean.maxradio"][0].checked==true){
        opener.document.forms[1].elements["yInfoBean.maxradio"].value="default";
        opener.document.forms[1].elements["yInfoBean.displaymax"].value="auto";
    }else{
         opener.document.forms[1].elements["yInfoBean.maxradio"].value="specify"; 
         opener.document.forms[1].elements["yInfoBean.max"].value=document.forms[0].elements["yInfoBean.max"].value; 
         opener.document.forms[1].elements["yInfoBean.displaymax"].value=unitToNum(max,maxunit); 
         opener.document.forms[1].elements["yInfoBean.maxunit"].value=maxunit;    
    }
    if(document.forms[0].elements["yInfoBean.minradio"][0].checked==true){
        opener.document.forms[1].elements["yInfoBean.minradio"].value="default"; 
        opener.document.forms[1].elements["yInfoBean.displaymin"].value="auto";
    }else{
        opener.document.forms[1].elements["yInfoBean.minradio"].value="specify";  
        opener.document.forms[1].elements["yInfoBean.min"].value=document.forms[0].elements["yInfoBean.min"].value; 
        opener.document.forms[1].elements["yInfoBean.displaymin"].value=unitToNum(min,minunit); 
        opener.document.forms[1].elements["yInfoBean.minunit"].value=minunit; 
    }
    opener.document.forms[1].elements["selectedItem"].value=document.forms[0].elements["selectedItem"].value;
    opener.document.forms[1].elements["isDetail"].value=document.forms[0].elements["isDetail"].value;
    opener.document.forms[1].elements["collectionItem"].value=document.forms[0].elements["collectionItem"].value;    
    opener.document.forms[1].submit();
    opener.setSubmitted();
    window.close();
}
function enableMax(){
	document.forms[0].elements["yInfoBean.max"].disabled=false; 
	document.forms[0].elements["yInfoBean.maxunit"].disabled=false;   
}
function disableMax(){
	document.forms[0].elements["yInfoBean.max"].disabled=true;
	document.forms[0].elements["yInfoBean.maxunit"].disabled=true; 
}
function enableMin(){
	document.forms[0].elements["yInfoBean.min"].disabled=false;
	document.forms[0].elements["yInfoBean.minunit"].disabled=false;    
 }
function disableMin(){
	document.forms[0].elements["yInfoBean.min"].disabled=true;
	document.forms[0].elements["yInfoBean.minunit"].disabled=true; 
 }
function init(){
	if(document.forms[0].elements["yInfoBean.maxradio"][0].checked==true){
    	disableMax();    
	}
	if(document.forms[0].elements["yInfoBean.minradio"][0].checked==true){
    	disableMin();
	}
}
function display(){
 var ele=document.forms[0].elements["selectedItem"];
 var value=ele.options[ele.selectedIndex].value
 document.location="changeNasSwitchMax.do?operation=displayMax&collectionItem=<bean:write name="nasSwitchMaxForm" property="collectionItem"/>&selectedItem="+value;
} 
</script>
</HEAD>
<BODY onload="init();">
<h1 class="title"><bean:message name="watchItemDesc"/></h1>
<h2 class="title"><bean:message key="statis.y.h2"/></h2>
<html:form action="changeNasSwitchMax.do?operation=changeMax" method="POST">
<table border=1 class="Vertical">
<tr>
<th><bean:message key="statis.nasswitch.setobject"/></th>
<td>
	<html:select property="selectedItem">			
		<html:option value="access"><bean:message key="statis.nasswitch.th.title.access"/></html:option>
		<html:option value="res"><bean:message key="statis.nasswitch.th.title.response"/></html:option>
		<html:option value="rover"><bean:message key="statis.nasswitch.th.title.rover"/></html:option>				
	</html:select>
<input type="button" value="<bean:message key='statis.y.select'/>" onclick="return display()">	
</td>
</tr>
</table>
<br>
<table border=1 class="Vertical">
	<tr>
		<th><bean:message key="statis.y.maxtitle"/></th>
		<td><html:radio property="yInfoBean.maxradio" value="default" styleId="max1" onclick="disableMax()"/>
		<label for="max1">
			<bean:message key="statis.y.maxdefaultlabelauto"/>
		</label><br>
			<html:radio property="yInfoBean.maxradio" styleId="max2" value="specify" onclick="enableMax()"/>
		<label for="max2">
          <bean:message key="statis.y.maxspecifylabel"/>
		</label>&nbsp;&nbsp;
		<html:text property="yInfoBean.max" maxlength="9"/>&nbsp;
			<html:select property="yInfoBean.maxunit">			
			<html:option value="u"><bean:message key="statis.y.unit.u"/></html:option>
			<html:option value="m"><bean:message key="statis.y.unit.m"/></html:option>
			<html:option value="-"><bean:message key="statis.y.unit.none"/></html:option>
			<html:option value="k"><bean:message key="statis.y.unit.k"/></html:option>
			<html:option value="M"><bean:message key="statis.y.unit.M"/></html:option>			
			</html:select>
			</td>
		</tr>
		<tr>
		<th><bean:message key="statis.y.mintitle"/></th>
			<td><html:radio property="yInfoBean.minradio" styleId="min1" value="default" onclick="disableMin()"/>
			<label for="min1">
			<bean:message key="statis.y.mindefaultlabel" arg0="0"/>
			</label><br>
			<html:radio property="yInfoBean.minradio" styleId="min2" value="specify" onclick="enableMin()"/>
			<label for="min2">
			<bean:message key="statis.y.minspecifylabel"/>
			</label>&nbsp;&nbsp;
			<html:text property="yInfoBean.min" maxlength="9"/>&nbsp;
			<html:select property="yInfoBean.minunit">			
			<html:option value="u"><bean:message key="statis.y.unit.u"/></html:option>
			<html:option value="m"><bean:message key="statis.y.unit.m"/></html:option>
			<html:option value="-"><bean:message key="statis.y.unit.none"/></html:option>			
			<html:option value="k"><bean:message key="statis.y.unit.k"/></html:option>
			<html:option value="M"><bean:message key="statis.y.unit.M"/></html:option>						
			</html:select>
			</td>
		</tr>
</table>
<html:hidden property="collectionItem"/>
<html:hidden property="isDetail"/>
<br>
<input type="button" value="<bean:message key='statis.y.submit'/>" onclick="return setValue()">
<input type="button" value="<bean:message key='statis.y.close'/>" onclick="window.close();">
</html:form>
</BODY>
</HTML>
