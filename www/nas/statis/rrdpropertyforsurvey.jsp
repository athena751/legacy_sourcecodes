<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: rrdpropertyforsurvey.jsp,v 1.3 2005/10/24 12:24:46 pangqr Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ taglib uri="struts-nested" prefix="nested" %>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror" %>
<%@ page import="com.nec.nsgui.action.statis.StatisActionConst" %>
<%@ page import="com.nec.nsgui.model.biz.statis.WatchItemDef" %>
<html>
<head>
    <title>
       <bean:message key="statis.properties.h2.display.period"/>
    </title>
    <%@include file="../../common/head.jsp" %> 
    <script language="JavaScript" src="../common/common.js"></script>
    <script language="JavaScript" src="../nas/statis/property.js"></script>
    <script language="JavaScript">
        function submitModify(){
            if(isSubmitted() ){
                return false;
            }
            if(!confirm('<bean:message key="common.confirm" bundle="common"/>\r\n'+
                        '<bean:message key="common.confirm.action" bundle="common"/>'+
                        '<bean:message key="common.button.submit" bundle="common"/>')){
                return false;
            }
            setSubmitted();
            document.forms[0].submit();
            return true;
        }
        <logic:equal name="is4Survey" value="true">
            is4Survey = true;
        </logic:equal>  
    </script>
</head>
  
<body onload="initialization();displayAlert();">
<h1><bean:message name="watchItemDesc"/></h1>
<displayerror:error h1_key="statis.properties.h1"/>
<h2><bean:message key="statis.properties.h2.display.period"/></h2>
<html:form action="rrdproperty.do?operation=saveOptionForSurvey">
<nested:nest property="optionInfo">
<table border="1" class="Vertical">
    <tr>
    <%@include file="propertycontent.jsp" %>    
</table><br>
</nested:nest>
<html:button property="submitBtn" onclick="return submitModify()"><bean:message bundle="common" key="common.button.submit"/></html:button>
<html:button property="resetBtn" onclick="document.forms[0].reset();resetElement()"><bean:message bundle="common" key="common.button.reset"/></html:button>
<html:button property="closeBtn" onclick="window.close();"><bean:message bundle="common" key="common.button.close"/></html:button>
</html:form>
</body>
</html>