<!--
        Copyright (c) 2006-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: cifsotheroptionstop.jsp,v 1.5 2007/05/08 05:52:18 chenbc Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="com.nec.nsgui.action.cifs.CifsActionConst"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested"%>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror"%>

<html>
<head>
<%@include file="../../common/head.jsp"%>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript" src="../common/validation.js"></script>
<script language="JavaScript">
var old_directHosting = "no";
    
    function onRefresh() {
        if(isSubmitted()){
           return false;
       }
       setSubmitted();
       window.parent.location="loadOtherOptions.do";
       return true;
    }
    
    function init() {
        <logic:equal name="otherOptionsForm" property="otherOptions.directHosting" value="yes">
            old_directHosting = "yes";
        </logic:equal>
        if(parent.frames[1].document && parent.frames[1].document.forms[0]
           && parent.frames[1].document.forms[0].set) {
            parent.frames[1].document.forms[0].set.disabled = true;
        }
        displayAlert();
        setHelpAnchor('network_cifs_17');
        initDirectHosting();
    }
    
    function initDirectHosting() {
        <logic:present name="<%=CifsActionConst.REQUEST_DISABLE_DIRECTHOSTING%>" scope="request">
            old_directHosting = "no";
            document.forms[0].elements["otherOptions.directHosting"].checked = false;
            document.forms[0].elements["otherOptions.directHosting"].disabled = true;
        </logic:present>
        <logic:notPresent name="<%=CifsActionConst.REQUEST_DISABLE_DIRECTHOSTING%>" scope="request">
            document.forms[0].elements["otherOptions.directHosting"].disabled = false;
        </logic:notPresent>
    }
    
    function onSet() { 
        if(isSubmitted()) {
            return false;
        }
        
        if(!confirm('<bean:message key="cifs.otherOptions.DH.setConfirm"/>')){
            return false;
        }
        if((old_directHosting == "no" && document.forms[0].elements["otherOptions.directHosting"].checked)
           || (old_directHosting == "yes" && !document.forms[0].elements["otherOptions.directHosting"].checked)) {
            setSubmitted();
            document.forms[0].submit();
            return true;
        }
        return false;
    }
    
    function onChangeDH() {
        //just when direct hosting checkbox's status is changed, enable bottom frame's "set" button. 
        if(parent.frames[1].document && parent.frames[1].document.forms[0]
           && parent.frames[1].document.forms[0].set) {
            if((old_directHosting == "no" && document.forms[0].elements["otherOptions.directHosting"].checked)
               || (old_directHosting == "yes" && !document.forms[0].elements["otherOptions.directHosting"].checked)) {
                parent.frames[1].document.forms[0].set.disabled = false;
            } else {
                parent.frames[1].document.forms[0].set.disabled = true;
            }
        }
    }
    
</script>
</head>

<body onload="init();">
  <html:form method="post" action="otherOptions.do?operation=setOtherOptions" target="otheroptions_topframe">
    <nested:nest property="otherOptions">
	<html:button property="reload" onclick="onRefresh()">
        <bean:message key="common.button.reload" bundle="common"/>
    </html:button><br><br>
    <displayerror:error h1_key="cifs.common.h1"/>
    <logic:present name="<%=CifsActionConst.REQUEST_DISABLE_DIRECTHOSTING%>" scope="request">
        <table border="0">
           <tr>
             <td rowspan="2" class="ErrorInfo">
              <img border=0 src="../images/icon/png/icon_alert.png" >
             </td>
             <td class="ErrorInfo">
               <logic:equal name="<%=CifsActionConst.REQUEST_DISABLE_DIRECTHOSTING%>" value="0" scope="request">
                 <bean:message key="cifs.error.directHostingSelfNodeCannotSet.generalInfo"/>
               </logic:equal>
               <logic:equal name="<%=CifsActionConst.REQUEST_DISABLE_DIRECTHOSTING%>" value="1" scope="request">
                 <bean:message key="cifs.error.directHostingFriendNodeCannotSet.generalInfo"/>
               </logic:equal>
             </td>
           </tr>
        </table><br>
    </logic:present>
    
    <table>
      <tr>
        <td style="wrap:hard;width:80%">
          <bean:message key="cifs.directHosting.notice"/>
        </td>
      </tr>
    </table><br>
    
    <table border="1">
      <tr>
        <th><bean:message key="cifs.otherOptions.th.directHosting"/></th>
        <td>
          <nested:checkbox property="directHosting" styleId="directHosting" value="yes" disabled="true" onclick="onChangeDH()"/>
          <label for="directHosting"><bean:message key="cifs.directHosting.use"/></label>
        </td>
      </tr>
    </table>
    </nested:nest>
  </html:form>
</body>
</html>