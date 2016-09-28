<!--
        Copyright (c) 2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: cifsotheroptions4nsview.jsp,v 1.1 2006/11/06 06:49:08 fengmh Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic"%>

<head>
<%@include file="../../common/head.jsp"%>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">

    function onRefresh() {
        if(isSubmitted()){
           return false;
       }
       setSubmitted();
       window.location="otherOptions4nsview.do?operation=displayOtherOptions";
    }
    
    function init() {
        setHelpAnchor('network_cifs_17');
    }
    
</script>
</head>

<body onload="init();">
  <form method="post">
    <nested:nest property="otherOptions">
    <html:button property="refreshBtn" onclick="onRefresh();">
	  <bean:message key="common.button.reload" bundle="common" />
    </html:button><br><br>
    <table border="1">
      <tr>
        <th><bean:message key="cifs.otherOptions.th.directHosting"/></th>
        <td>
          <logic:equal name="otherOptionsForm" property="otherOptions.directHosting" value="yes">
              <bean:message key="cifs.directHosting.use"/>
          </logic:equal>
          <logic:notEqual name="otherOptionsForm" property="otherOptions.directHosting" value="yes">
              <bean:message key="cifs.directHosting.notUse"/> 
          </logic:notEqual>
        </td>
      </tr>
    </table>
    </nested:nest>
  </form>
</body>