<!--
        Copyright (c) 2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: niclinkdowninfo.jsp,v 1.1 2007/08/24 01:22:19 wanghui Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>

<html>
<head>
<%@include file="../../common/head.jsp"%>  
<script language="JavaScript" src="../common/common.js"></script>
<script language="javascript">
function onRefresh(){    
    if(isSubmitted()){
        return false;
    }
    setSubmitted();
    window.location="linkdownConfig.do?operation=getLinkdownInfo4View";       
}
</script>
</head>
<body onload="setHelpAnchor('s_network_7');">  
  <form name="linkdowninfo" method="post">
      <html:button property="refreshBtn" onclick="onRefresh();">
            <bean:message key="common.button.reload" bundle="common"/>
      </html:button><br><br>
      <logic:equal name="linkdown_hasSet" value="no">
          <bean:message key="nic.linkdown.notSet"/>
      </logic:equal>
      <logic:notEqual name="linkdown_hasSet" value="no">
          <table border="1" class="VerticalTop">
              <tr>
                  <th><bean:message key= "nic.linkdown.takeOver"/></th>
                  <td><logic:equal name="linkdownInfo" property="takeOver" value="yes">
                      <bean:message key= "nic.linkdown.takeover.enabled"/>
                      </logic:equal>
                      <logic:notEqual name="linkdownInfo" property="takeOver" value="yes">
                      <bean:message key= "nic.linkdown.takeover.disabled"/>
                      </logic:notEqual>
                  </td>
              </tr>
              <tr>
                  <th><bean:message key= "nic.linkdown.bondDown"/></th>
                  <td><logic:equal name="linkdownInfo" property="bondDown" value="each">
                      <bean:message key= "nic.linkdown.radio.bondDown.each"/>
                      </logic:equal>
                      <logic:notEqual name="linkdownInfo" property="bondDown" value="each">
                      <bean:message key= "nic.linkdown.radio.bondDown.all"/>
                      </logic:notEqual>
                  </td>
              </tr>
              <tr>
                  <th><bean:message key= "nic.linkdown.checkInterval"/></th>
                  <td><bean:write name="linkdownInfo" property="checkInterval"/>
                      <bean:message key="nic.linkdown.checkInterval.unit"/>
                  </td>
              </tr>
              <tr>
                  <th><bean:message key= "nic.linkdown.ignoreList"/></th>
                  <td><bean:write name="linkdownInfo" property="ignoreList" filter="false"/></td>
              </tr>
          </table>
      </logic:notEqual>
  </form>
</body>
</html>

