<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation
-->
<!-- "@(#) $Id: ddrpairdetailtop.jsp,v 1.2 2008/04/20 07:27:12 lil Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.action.ddr.DdrActionConst" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>

<html:html lang="true">
<head>
  <%@ include file="/common/head.jsp" %>
  <script language="JavaScript" src="/nsadmin/common/common.js"></script>
  <script language="JavaScript">
    function resizeWindow(){	
	  var mvTable = document.getElementById("mvTable");
	  var rvTable = document.getElementById("rvTable");
	  
	  var mvTableCurrentWidth = mvTable.clientWidth;
	  var rvTableCurrentWidth = rvTable.clientWidth;
	  var maxWidth = rvTableCurrentWidth;

	  if(mvTableCurrentWidth > maxWidth){
		maxWidth = mvTableCurrentWidth;
	  }
	  
	  var scheduleTable = document.getElementById("scheduleTable");
	  if(scheduleTable){
	    var scheduleTableCurrentWidth = scheduleTable.clientWidth;
	    if(scheduleTableCurrentWidth > maxWidth){
		  maxWidth = scheduleTableCurrentWidth;
	    }
	  }

      parent.window.focus();
      if(maxWidth > 650){
	    parent.window.resizeTo(maxWidth+55,810);
	  }
    }

    //load the bottom frame when top frame has been loaded
    function loadBtnFrame(){
	  if (parent.bottomframe){
        setTimeout('parent.bottomframe.location="'+'<html:rewrite page="/ddrClosePage.do"/>'+'"',1);
  	  }
    }
    
    // set btnframe with blank page when top frame unloading
    function unloadBtnFrame() {
      if (parent.bottomframe){
        parent.bottomframe.location="/nsadmin/common/commonblank.html";
      }    
    }
  </script>
</head>

<body onload="loadBtnFrame();setHelpAnchor('disk_backup_2');" onUnload="unloadBtnFrame();">
  <h1 class="title"><bean:message key="ddr.h1"/></h1>
  <h2 class="title"><bean:message key="pair.detail.h2"/></h2>

  <h3 class="title"><bean:message key="pair.detail.mvinfo.h3"/></h3>
  <form>
    <bean:define id="mvDetail" name="ddrPairDetailMVBean" scope="session"/>
    <nested:root name="mvDetail">
      <table id="mvTable" border="1" class="Vertical" nowrap>
        <tr>
          <th><bean:message key="pair.detail.mvname"/></th>
          <td><nested:write property="name"/></td>
        </tr>
        <tr>
          <th><bean:message key="pair.detail.node"/></th>
          <td><bean:message key="pair.detail.node.text"/><nested:write property="node"/></td>
        </tr>
        <tr>
          <th><bean:message key="info.storage.capacity"/></th>
          <td><nested:write property="capacity"/></td>
        </tr>
        <tr>
          <th><bean:message key="info.mountpoint"/></th>
          <td><nested:write property="mp"/></td>
        </tr>
        <tr>
          <th><bean:message key="info.diskarrayName"/></th>
          <td><nested:write property="aname"/></td>
        </tr>
        <tr>
          <th valign="top"><bean:message key="pair.detail.poolnameno"/></th>
          <td>
            <nested:define id="pool" property="poolNameAndNo" type="java.lang.String"/>
            <%String divHeight = (pool.split("<br>").length >=3) ? "54px" : "auto";%>
            <DIV id="poolNameAndNo" style="overflow: auto; width: auto; height: <%=divHeight%>">
              <nested:write property="poolNameAndNo" filter="false"/>
            </DIV>
          </td>
        </tr>
        <tr>
          <th><bean:message key="info.pool.raidType"/></th>
          <td><nested:write property="raidType"/></td>
        </tr>
        <nested:notEqual property="mvStatusMsg" value="">
          <tr>
            <th><bean:message key="pair.info.status"/></th>
            <td><nested:write property="mvStatusMsg"/></td>
          </tr>
        </nested:notEqual>
        <nested:equal property="status" value="extendmvfail">
          <tr>
            <th><bean:message key="pair.info.errorcode"/></th>
            <td><nested:write property="mvResultCode"/></td>
          </tr>
          <tr>
            <th><bean:message key="pair.detail.errMsg"/></th>
            <td class="wrapTD"><nested:write property="mvErrMsg" filter="false"/></td>
          </tr>
        </nested:equal>
      </table>
    </nested:root>
  </form>

  <h3 class="title"><bean:message key="pair.detail.rvinfo.h3"/></h3>
  <bean:define id="rvDetailHtmlCode" name="ddrPairDetailRVHtmlCode" scope="session"/>
  <table id="rvTable" border="1" class="Vertical" nowrap>
    <%=rvDetailHtmlCode%>
  </table>

  <logic:equal name="ddrPairDetailType" value="generation" scope="session">
    <h3 class="title"><bean:message key="pair.detail.scheduleinfo.h3"/></h3>
    <nested:root name="mvDetail">
      <nested:equal property="schedule" value="">
        <bean:message key="pair.detail.noschedule"/>
      </nested:equal>
      <nested:notEqual property="schedule" value="">
        <table id="scheduleTable" border="1" class="Vertical" nowrap>
          <tr>
            <th><bean:message key="pair.info.schedule"/></th>
            <td><nested:write property="schedule" filter="false"/></td>
          </tr>
          <nested:notEqual property="schedStatusMsg" value="">
            <tr>
              <th><bean:message key="pair.info.status"/></th>
              <td><nested:write property="schedStatusMsg"/></td>
            </tr>
          </nested:notEqual>
          <nested:equal property="status" value="createschedfail">
            <tr>
              <th><bean:message key="pair.info.errorcode"/></th>
              <td><nested:write property="schedResultCode"/></td>
            </tr>
            <tr>
              <th><bean:message key="pair.detail.errMsg"/></th>
              <td class="wrapTD"><nested:write property="schedErrMsg" filter="false"/></td>
            </tr>
          </nested:equal>
          <nested:equal property="status" value="createfail">
            <tr>
              <th><bean:message key="pair.info.errorcode"/></th>
              <td><nested:write property="schedResultCode"/></td>
            </tr>
            <tr>
              <th><bean:message key="pair.detail.errMsg"/></th>
              <td class="wrapTD"><nested:write property="schedErrMsg" filter="false"/></td>
            </tr>
          </nested:equal>
        </table>
      </nested:notEqual>
    </nested:root>
  </logic:equal>

</body>
</html:html>
