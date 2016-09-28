<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: replicasnapshotlistbottom.jsp,v 1.1 2008/05/28 02:14:46 lil Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>

<html:html lang="true">
<head>
  <%@include file="/common/head.jsp" %>
  <script language="JavaScript">
    function initBtn(){
      var disableFlg = true;
      var topForm = parent.topframe.document.forms[0];
      if(topForm.snapshotCb){
        if(!(topForm.snapshotCb.length)){
          if(topForm.snapshotCb.disabled == false){
            disableFlg = false;
          }
        }else{
          for(var i=0;i<topForm.snapshotCb.length;i++){
            if(topForm.snapshotCb[i].disabled == false){
              disableFlg = false;
              break;
            }
          }//for
        }
      }else{
        disableFlg = true;
      }
      document.forms[0].deleteBtn.disabled = disableFlg;
    }
  </script>
</head>
<body onload="initBtn();">
  <form>
    <html:button property="deleteBtn" onclick="return parent.topframe.onDelete();">
        <bean:message key="common.button.delete" bundle="common"/>
    </html:button>
  </form>
</body>
</html:html>
