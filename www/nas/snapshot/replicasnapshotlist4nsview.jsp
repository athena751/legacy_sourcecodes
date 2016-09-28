<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation
-->
<!-- "@(#) $Id: replicasnapshotlist4nsview.jsp,v 1.3 2008/06/18 07:15:16 lil Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.taglib.nssorttab.*" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/nssorttab.tld" prefix="nssorttab" %>

<html:html lang="true">
<head>
  <%@ include file="/common/head.jsp" %>
  <script language="JavaScript" src="/nsadmin/common/common.js"></script>
  <script language="JavaScript">
    function onBack(){
      if (isSubmitted()){
        return false;
      }
      setSubmitted();
      lockMenu();
      window.location="/nsadmin/menu/nas/common/mountpoint.jsp?nextAction=Snapshot";
      return true;
    }
    function onRefresh(){
      if(isSubmitted()){
        return false;
      }
      setSubmitted();
      window.location="/nsadmin/snapshot/replicaSnapshotListTop.do";
      return true;
    }
  </script>
</head>

<body onload="setHelpAnchor('volume_snapshot_2');" onUnload="unLockMenu();">
  <form>
    <h1 class="title"><bean:message key="snapshot.h1"/></h1>
    <html:button property="backBtn" onclick="return onBack();">
      <bean:message key="common.button.back" bundle="common"/>
    </html:button>&nbsp;
    <html:button property="reloadBtn" onclick="return onRefresh();">
      <bean:message key="common.button.reload" bundle="common"/>
    </html:button>
    
    <h2 class="title"><bean:message key="snapshot.h2"/>&nbsp;[<bean:write name="snapshotDeleteForm" property="mp"/>]</h2>
    <logic:empty name="replicaSnapshotInfoList" scope="request">
      <br><bean:message key="snapshot.msg.nosnapshot"/>
    </logic:empty>
    <logic:notEmpty name="replicaSnapshotInfoList" scope="request">
      <bean:define id="infoList" name="replicaSnapshotInfoList" scope="request"/>
      <nssorttab:table tablemodel="<%=new ListSTModel((java.util.ArrayList)infoList)%>" 
                       id="snapshotInfoTable"
                       table="border=1" 
                       sortonload="createTime" >                      
        <nssorttab:column name="name" 
                          th="STHeaderRender" 
                          td="com.nec.nsgui.action.snapshot.STDataRender4SnapList"
                          sortable="no">
          <bean:message key="snapshot.msg.th.name"/>
        </nssorttab:column>            
        <nssorttab:column name="createTime" 
                          th="STHeaderRender" 
                          td="com.nec.nsgui.action.snapshot.STDataRender4SnapList"
                          sortable="no">
          <bean:message key="snapshot.msg.th.createtime"/>
        </nssorttab:column>            
        <nssorttab:column name="status" 
                          th="STHeaderRender" 
                          td="com.nec.nsgui.action.snapshot.STDataRender4SnapList"
                          sortable="no">
          <bean:message key="snapshot.msg.th.status"/>
        </nssorttab:column>            
      </nssorttab:table>
    </logic:notEmpty>
  </form>
</body>
</html:html>
