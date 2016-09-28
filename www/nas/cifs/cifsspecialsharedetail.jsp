<!-- 
        Copyright (c) 2007-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
 
<!-- "@(#) $Id: cifsspecialsharedetail.jsp,v 1.5 2008/12/18 08:15:11 chenbc Exp $" -->
<%@ page import="com.nec.nsgui.action.base.NSActionUtil" %>

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>
<%@ taglib uri="/WEB-INF/tld/nssorttab.tld" prefix="nssorttab" %>

<html>
<head>
<title><bean:message key="cifs.shareDetail.h3_special_detail"/></title>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">
function onReload(){
    if (isSubmitted()){
        return false;
    }
    setSubmitted();
    document.forms[0].submit();
}

function displayUserTR(show_flag){
    var user_tr = document.getElementById("user_tr");
    if(show_flag){
        user_tr.style.display = "";
    }else{
        user_tr.style.display = "none";
    }
}

function init(){
  <logic:equal name="shareOptionForm" property="shareOption.sharePurpose" value="realtime_scan">
    <logic:equal name="shareOptionForm" property="shareOption.fsType" value="sxfs">
      displayUserTR(false);
    </logic:equal>
  </logic:equal>
  setHelpAnchor('network_cifs_19');
}

</script>
</head>
<body onload="init();" onUnload="setHelpAnchor('network_cifs_18');">

<html:form action="setSpecialShare.do" target="_self" method="post">
<input type="hidden" name="operation" value="displayDetail">
<h1 class="popup"><bean:message key="cifs.common.h1"/></h1>
<nested:nest property="shareOption">
 <nested:equal property="shareExist" value="yes">
 <html:button property="reload" onclick="onReload()">
        <bean:message key="common.button.reload" bundle="common"/>
 </html:button>
 </nested:equal>
</nested:nest>
<h2 class="popup"><bean:message key="cifs.shareDetail.h3_special_detail"/></h2>


<logic:notEqual name="cannot_get_detail" value="true" scope="request">
   <nested:nest property="shareOption">
    <nested:equal property="shareExist" value="no">
     <table><tr><td style='width:100%;'> <bean:message key="cifs.common.specialShareNotExist"/></td></tr></table>
    </nested:equal>
    <nested:notEqual property="shareExist" value="no">
   <table border="1" class="Vertical">
    <tr>
      <th><bean:message key="cifs.sharePurpose"/></th>
      <td>
        <nested:equal property="sharePurpose" value="realtime_scan">
          <bean:message key="cifs.sharePurpose.realtime_scan"/>
        </nested:equal>
        <nested:equal property="sharePurpose" value="backup">
          <bean:message key="cifs.sharePurpose.backup"/>
        </nested:equal>
      </td>
    </tr>
    <tr>
     <th><bean:message key="cifs.shareOption.th_sharename"/></th>
     <td><nested:define id="shareName_td" property="shareName" type="java.lang.String"/>
     <%=NSActionUtil.htmlSanitize(shareName_td)%>
     <input type="hidden" name="shareName" value="<%=shareName_td%>">
     </td>
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
          <tr>
            <td>&nbsp;&nbsp;<bean:message key="cifs.shareOption.td_wl"/>&nbsp;&nbsp;<nested:write property="writeList"/></td>
          </tr>
        </table>
      </td>
    </tr>
    
    <tr id="user_tr">
      <th>
        <nested:equal property="sharePurpose" value="realtime_scan">
          <bean:message key="cifs.specialShare.scanUser"/>
        </nested:equal>
        <nested:equal property="sharePurpose" value="backup">
          <bean:message key="cifs.specialShare.backupUser"/>
        </nested:equal>
      </th>
      <td>
        <nested:define id="validUser_Group_td" property="validUser_Group" type="java.lang.String"/>
        <%=NSActionUtil.htmlSanitize(validUser_Group_td)%>
      </td>
    </tr>
    
     <tr id="server_tr">
        <th>
          <nested:equal property="sharePurpose" value="realtime_scan">
            <bean:message key="cifs.specialShare.scanServer"/>
          </nested:equal>
          <nested:equal property="sharePurpose" value="backup">
            <bean:message key="cifs.specialShare.backupServer"/>
          </nested:equal>
        </th>
        <td><nested:write property="hostsAllow" /></td>
     </tr>
   <nested:equal property="sharePurpose" value="realtime_scan"> <!-- for schedule scan -->
      <tr>
        <th>
            <bean:message key="cifs.specialShare.scheduleScanUser"/>
        </th>
        <td>
            <nested:define id="validUserForScheduleScan_td" property="validUserForScheduleScan" type="java.lang.String"/>
            <%=NSActionUtil.htmlSanitize(validUserForScheduleScan_td)%>
        </td>
      </tr>
      <tr>
        <th>
            <bean:message key="cifs.specialShare.scheduleScanServer"/>
        </th>
        <td>
            <nested:write property="allowHostForScheduleScan"/>
        </td>
      </tr>  
   </nested:equal>
      <tr>      
          <th><bean:message key="cifs.common.th_otherOption"/></th>
          <td>
         <%--  omitted for 0805   
             <nested:equal property="sharePurpose" value="backup">
                 <nested:write property="shadowCopy" /><br>
             </nested:equal>
         --%>
             <nested:write property="browseable" />
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