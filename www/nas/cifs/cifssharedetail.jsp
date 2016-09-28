<!-- 
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
 
<!-- "@(#) $Id: cifssharedetail.jsp,v 1.11 2008/12/09 10:15:30 chenbc Exp $" -->
<%@ page import="com.nec.nsgui.action.base.NSActionUtil" %>
<%@ page import="com.nec.nsgui.action.cifs.CifsActionConst" %>

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>
<%@ taglib uri="/WEB-INF/tld/nssorttab.tld" prefix="nssorttab" %>

<html>
<head>
<title><bean:message key="cifs.shareDetail.h3_detail"/></title>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">
function onReload(){
    if (isSubmitted()){
        return false;
    }
    setSubmitted();
    document.forms[0].submit();
    //window.location="setShare.do?operation=displayDetail";
    
}
</script>
</head>
<body onload="setHelpAnchor('network_cifs_14');" onUnload="setHelpAnchor('network_cifs_1');">

<html:form action="setShare.do" target="_self" method="post">
<h1 class="popup"><bean:message key="cifs.common.h1"/></h1>
<nested:nest property="shareOption">
 <nested:equal property="shareExist" value="yes">
 <html:button property="reload" onclick="onReload()">
        <bean:message key="common.button.reload" bundle="common"/>
 </html:button>
 </nested:equal>
</nested:nest>
<h2 class="popup"><bean:message key="cifs.shareDetail.h3_detail"/></h2>


<logic:notEqual name="cannot_get_detail" value="true" scope="request">
   <nested:nest property="shareOption">
    <nested:equal property="shareExist" value="no">
     <table><tr><td style='width:100%;'> <bean:message key="cifs.common.shareNotExist"/></td></tr></table>
    </nested:equal>
    <nested:notEqual property="shareExist" value="no">
   <table border="1" class="Vertical">
    <tr>
     <th><bean:message key="cifs.shareOption.th_sharename"/></th>
     <td><nested:define id="shareName_td" property="shareName" type="java.lang.String"/>
     <%=NSActionUtil.htmlSanitize(shareName_td)%>
     <input type="hidden" name="operation" value="displayDetail">
     <input type="hidden" name="shareName" value="<%=shareName_td%>">
     </td>
      <nested:hidden property="shareName"/>
    </tr>
    <tr>
     <th><bean:message key="cifs.shareOption.th_connection"/></th>
      <td><nested:write property="connection"/></td>
    </tr>
    <tr>
      <th><bean:message key="cifs.shareOption.th_directory"/></th>
      <td nowrap>
        <nested:define id="directory_td" property="directory" type="java.lang.String"/>
        <%=NSActionUtil.htmlSanitize(directory_td)%>
      </td>
    </tr>
    <tr>
      <th><bean:message key="cifs.shareOption.th_comment"/></th>
      <td>
        <nested:define id="comment_td" property="comment" type="java.lang.String"/>
        <%=NSActionUtil.htmlSanitize(comment_td)%>
      </td>
    </tr>
    <tr>
      <th><bean:message key="cifs.shareOption.th_accessMode"/></th>
      <td>
        <table border="0">
          <tr>
            <td><nested:write property="readOnly"/>
            </td>
          </tr>
          <logic:notEqual name="cifs_securityMode" value="Share">
          <tr>
            <td>
                &nbsp;&nbsp;<bean:message key="cifs.shareOption.td_wl"/>&nbsp;&nbsp;<nested:write property="writeList"/>        
            </td>
          </tr>
          </logic:notEqual>
        </table>
      </td>
    </tr>

    <logic:equal name="cifs_securityMode" value="Share">
        <tr>
          <th><bean:message key="cifs.shareOption.th_password"/></th>
            <nested:define id="passwd_td" property="settingPassword" type="java.lang.String"/>
        <td>
            <nested:write property="settingPassword" />
         </td>
        </tr>
    </logic:equal>
    
    <logic:notEqual name="cifs_securityMode" value="Share">
    <tr>
      <th><bean:message key="cifs.shareOption.th_validusers"/></th>
      <td>
        <nested:define id="validUser_Group_td" property="validUser_Group" type="java.lang.String"/>
        <%=NSActionUtil.htmlSanitize(validUser_Group_td)%>
      </td>
    </tr>
    <tr>
      <th><bean:message key="cifs.shareOption.th_invalidusers"/></th>
      <td>
        <nested:define id="invalidUser_Group_td" property="invalidUser_Group" type="java.lang.String"/>
        <%=NSActionUtil.htmlSanitize(invalidUser_Group_td)%>
      </td>
    </tr>
    </logic:notEqual>
     <tr>
        <th><bean:message key="cifs.shareOption.th_hostsallow"/></th>
        <td><nested:write property="hostsAllow" /></td>
     </tr>
          <tr>
          <th><bean:message key="cifs.shareOption.th_hostsdeny"/></th>
            <td><nested:write property="hostsDeny" /></td>
          </tr>    
      <logic:equal name="<%=CifsActionConst.SESSION_SECURITY_MODE%>" value="<%=CifsActionConst.SECURITYMODE_ADS%>" scope="session">
        <logic:equal name="<%=CifsActionConst.SESSION_HASANTIVIRUSSCAN_LICENSE%>" value="yes" scope="session">
          <tr>
            <th><bean:message key="cifs.antiVirus"/></th>
            <td>
              <nested:notEqual property="antiVirus" value="">
                <nested:equal property="antiVirusForShare" value="yes">
                  <bean:message key="cifs.shareOption.antiVirusForGlobal.follow_global"/>
                </nested:equal>
                <nested:notEqual property="antiVirusForShare" value="yes">
                  <bean:message key="cifs.antiVirus.disabled"/>
                </nested:notEqual>
                <br>&nbsp;&nbsp;
                <bean:message key="cifs.shareOption.antiVirusForGlobal.current_setting"/>
                <nested:equal property="antiVirusForGlobal" value="yes">
                  <bean:message key="cifs.antiVirus.current.enabled"/>
                </nested:equal>
                <nested:notEqual property="antiVirusForGlobal" value="yes">
                  <bean:message key="cifs.antiVirus.current.disabled"/>
                </nested:notEqual>
              </nested:notEqual>
              <nested:equal property="antiVirus" value="">
                <bean:message key="cifs.antiVirus.meanNothing"/>
              </nested:equal>
            </td>
          </tr>
        </logic:equal>
      </logic:equal>
      <tr>      
          <th><bean:message key="cifs.common.th_otherOption"/></th>
          <td>
          <!-- <nested:write property="serverProtect" />
              <br> -->
              <nested:write property="shadowCopy" />
              <br>
              <nested:write property="dirAccessControlAvailable" />
            <logic:notEqual name="cifs_securityMode" value="Share">
              <br />
              <nested:write property="pseudoABE" />
            </logic:notEqual>
          </td>
      </tr>
     
   </table>
   </nested:notEqual>
 </nested:nest>  
</logic:notEqual>

<logic:equal name="cannot_get_detail" value="true" scope="request">
     <table><tr><td style='width:100%;'> <bean:message key="cifs.shareDetial.noSharesDetail"/></td></tr></table>
</logic:equal>
<br>
<br>
<center>
<input type="button" value='<bean:message key="common.button.close" bundle="common"/>' onClick="window.close()"/>
</center>   
</html:form>
</body>
</html>