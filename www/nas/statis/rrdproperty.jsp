<!--
        Copyright (c) 2006-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: rrdproperty.jsp,v 1.6 2007/04/03 03:19:05 caows Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ taglib uri="struts-nested" prefix="nested" %>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror" %>

<html>
<head>
    <title>
       <bean:message key="statis.properties.h1"/>
    </title>
    <%@include file="../../common/head.jsp" %> 
    <script language="JavaScript" src="../common/common.js"></script>
    <script language="JavaScript" src="../nas/statis/property.js"></script>
    <script language="JavaScript">
        var isEnterKey=true;
        function submitModify(){
            if(isSubmitted() ){
                return false;
            }
            if(!checkValue()){
                return false;
            }
            if(!confirm('<bean:message key="common.confirm" bundle="common"/>\r\n'+
                        '<bean:message key="common.confirm.action" bundle="common"/>'+
                        '<bean:message key="common.button.submit" bundle="common"/>')){
                return false;
            }
            setSubmitted();
            isEnterKey=false;
            document.forms[0].submit();
            return true;
        }
        
        function checkValue(){
            if( document.forms[0].elements["optionInfo.sampleInfo.sample"][1].checked ) {
                var str = trim( document.forms[0].elements["optionInfo.sampleInfo.sampleInterval"].value );
                var avail = /[^0-9]/g;
                var ifFind = str.search(avail);
                if(ifFind!=-1||str>60||str <= 0){
                    alert("<bean:message key="statis.properties.error.sample.time"/>");
                    return false;
                }
            }
            return true;
        }
        
    </script>
</head>
  
<body onload="initialization();displayAlert();" onUnload="closeDetailErrorWin();">

<displayerror:error h1_key="<%=(String)request.getSession().getAttribute("watchItemDesc") %>" />
<html:form action="rrdproperty.do?operation=saveOption" target="_parent" onsubmit="if(isEnterKey) return false;">

<nested:nest property="optionInfo">
<table border="1" class="Vertical">

    <tr>
        <th rowspan="5">
            <bean:message key="statis.properties.th_custom"/>
        </th>
    <%@include file="propertycontent.jsp" %>    
    
    <tr>
        <th>
            <bean:message key="statis.properties.th_timescale"/>
        </th>
        <td colspan="3">
            <nested:radio property="sampleInfo.sample" value = "auto" styleId="sample_auto" onclick="enableAuto();"/>
            <label for="sample_auto">
                <bean:message key="statis.properties.radio_auto"/>
            </label> 
            
            <nested:radio property="sampleInfo.sample" value = "specific" styleId="sample_spec" onclick="enableSpecific();"/>
            <label for="sample_spec">
                <bean:message key="statis.properties.radio_specific"/>
            </label>
            
            <nested:text property="sampleInfo.sampleInterval" size="5" maxlength="2" />
            <nested:select property="sampleInfo.sampleUnit" >
                <html:option  value="Minutes">
                    <bean:message key="statis.properties.option.minutes"/>
                </html:option>
                <html:option value="Hours">
                    <bean:message key="statis.properties.option.hours"/>
                </html:option>
            </nested:select>
        </td>
    </tr>
    
</table>
</nested:nest>

</html:form>
</body>
</html>