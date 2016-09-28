<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation
-->
<!-- "@(#) $Id: replicasnapshotlisttop.jsp,v 1.4 2008/06/27 11:04:24 lil Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.taglib.nssorttab.*" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/nssorttab.tld" prefix="nssorttab" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>

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
      parent.location="/nsadmin/menu/nas/common/mountpoint.jsp?nextAction=Snapshot";
      return true;
    }
    
    function onRefresh(){
      if(isSubmitted()){
        return false;
      }
      setSubmitted();
      parent.location="/nsadmin/snapshot/replicaSnapshotList.do";
      return true;
    }
    
    function setCheckboxStatus(flag){
      if(!(document.forms[0].snapshotCb.length)){
        if(document.forms[0].snapshotCb.disabled == false){
          document.forms[0].snapshotCb.checked = flag;
        }
      }else{
        for(var i=0;i<document.forms[0].snapshotCb.length;i++){
          if(document.forms[0].snapshotCb[i].disabled == false){
            document.forms[0].snapshotCb[i].checked = flag;
          }
        }
      }    
    }
    
    function onDelete(){
      if(isSubmitted()){
        return false;
      }
      if(!(document.forms[0].snapshotCb.length)){
        if(document.forms[0].snapshotCb.checked){
          document.forms[0].delSnapshotNames.value = document.forms[0].snapshotCb.value;
        }else{
          alert('<bean:message key="snapshot.msg.alert.checknosnap"/>');
          return false;
        }
      }else{
        var delSnapshotNameArrs = new Array();
        for(var i=0;i<document.forms[0].snapshotCb.length;i++){
          if(document.forms[0].snapshotCb[i].checked){
            delSnapshotNameArrs.push(document.forms[0].snapshotCb[i].value);
          }
        }
        if(delSnapshotNameArrs.length == 0){
          alert('<bean:message key="snapshot.msg.alert.checknosnap"/>');
          return false;
        }else{
          document.forms[0].delSnapshotNames.value = delSnapshotNameArrs.join(",");
        }
      }
        
      var msg = 
          "<bean:message key="common.confirm" bundle="common"/>\r\n" +
          "<bean:message key="common.confirm.action" bundle="common"/> " + 
            "<bean:message key="common.button.delete" bundle="common"/>"; 

      if(confirm(msg)){
        setSubmitted();
        document.forms[0].submit();
        return true;
      }else{
        return false;
      }
    }
    
    //load the bottom frame when top frame has been loaded
    function loadBtnFrame(){
	  if (parent.bottomframe){
        setTimeout('parent.bottomframe.location="'+'<html:rewrite page="/replicaSnapshotListBottom.do"/>'+'"',1);
  	  }
    }
    
    // set btnframe with blank page when top frame unloading
    function unloadBtnFrame() {
      if (parent.bottomframe){
        parent.bottomframe.location="/nsadmin/common/commonblank.html";
      }    
    }
    
    function init(){
      var disableFlg = true;
      var topForm = document.forms[0];
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
        topForm.selectAll.disabled = disableFlg;
        topForm.releaseAll.disabled = disableFlg;
      }
    }
  </script>
</head>

<body onload="init();loadBtnFrame();displayAlert();setHelpAnchor('volume_snapshot_2');" onUnload="unLockMenu();closeDetailErrorWin();unloadBtnFrame();">
  <html:form action="replicaSnapshotDelete.do">
    <h1 class="title"><bean:message key="snapshot.h1"/></h1>
    <html:button property="backBtn" onclick="return onBack();">
      <bean:message key="common.button.back" bundle="common"/>
    </html:button>&nbsp;
    <html:button property="reloadBtn" onclick="return onRefresh();">
      <bean:message key="common.button.reload" bundle="common"/>
    </html:button>
    
    <h2 class="title"><bean:message key="snapshot.h2"/>&nbsp;[<bean:write name="snapshotDeleteForm" property="mp"/>]</h2>
    <displayerror:error h1_key="snapshot.h1"/>
    <logic:empty name="replicaSnapshotInfoList" scope="request">
      <br><bean:message key="snapshot.msg.nosnapshot"/>
    </logic:empty>
    <logic:notEmpty name="replicaSnapshotInfoList" scope="request">
      <html:button property="selectAll" onclick="setCheckboxStatus(true);">
        <bean:message key="snapshot.button.selectall"/>
      </html:button>
      <html:button property="releaseAll" onclick="setCheckboxStatus(false);">
        <bean:message key="snapshot.button.releaseall"/>
      </html:button>
      <bean:define id="infoList" name="replicaSnapshotInfoList" scope="request"/>
      <nssorttab:table tablemodel="<%=new ListSTModel((java.util.ArrayList)infoList)%>" 
                       id="snapshotInfoTable"
                       table="border=1" 
                       sortonload="createTime" >                      
        <nssorttab:column name="snapshotCb" 
                          th="STHeaderRender" 
                          td="com.nec.nsgui.action.snapshot.STDataRender4SnapList"
                          sortable="no">
        </nssorttab:column>            
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

    <html:hidden property="delSnapshotNames"/>
  </html:form>
</body>
</html:html>
