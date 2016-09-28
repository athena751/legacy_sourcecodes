<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nswsamplingsettingmiddle.jsp,v 1.1 2005/10/19 05:08:17 zhangj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>

<html>
<head>
    <%@include file="../../common/head.jsp" %>
    
    <SCRIPT language=JavaScript src="../common/common.js"></SCRIPT>
    <script language="javascript">
    var midLoadFlag=0;
    function setLoadFlag(){
        midLoadFlag=1;
document.forms[0].interval.value="<bean:write name="interval"/>";
document.forms[0].period.value="<bean:write name="period"/>";
    }
    </script>
</head>
<body onload="setLoadFlag();">
    <h3 class='title'><bean:message key="statis.nsw_sampling.settingmid_h3"/></h3>
    <html:form action="nswsampling.do" target="_parent">
        <table border='1' class='Vertical'>
            <tr><th>
                <bean:message key="statis.nsw_sampling.period"/>
                </th>
                <td>
                <html:text property="period" maxlength="3" size="4"/> 
                <bean:message key="statis.nsw_sampling.days"/>
                </td>
            </tr>
            <tr><th>
                <bean:message key="statis.nsw_sampling.interval"/>
                </th>
                <td>
                <html:select property="interval">
                    <html:option value="1" key="statis.nsw_sampling.interval_1"/>
                    <html:option value="2" key="statis.nsw_sampling.interval_2"/>
                    <html:option value="5" key="statis.nsw_sampling.interval_5"/>
                    <html:option value="10" key="statis.nsw_sampling.interval_10"/>
                    <html:option value="30" key="statis.nsw_sampling.interval_30"/>
                    <html:option value="60" key="statis.nsw_sampling.interval_60"/>
                </html:select>
                <bean:message key="statis.nsw_sampling.minutes"/>
                </td>
            </tr>
        </table>
    </html:form>
</body>
</html>
