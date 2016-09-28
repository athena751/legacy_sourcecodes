<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ddrmvinfo.jsp,v 1.5 2008/05/24 09:02:59 liuyq Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.action.ddr.DdrActionConst"%>
<%@ page import="java.lang.Double" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<nested:nest property="mvInfo">
 <nested:hidden property="name"/>
 <nested:hidden property="poolNameAndNo"/>
 <nested:hidden property="poolNo"/>
 <nested:hidden property="raidType"/>
 <nested:hidden property="capacity"/>
 <nested:hidden property="usableCap"/>
 <nested:hidden property="aid"/>
 <nested:hidden property="aname"/>
 <nested:hidden property="wwnn"/>
<h4 class="title"><bean:message key="pair.info.mvname"/></h4>
	<table border="1" id="table_rv" nowrap class="Vertical" style="table-layout:fixed;">

	    <tr>
	      <th width=180px><bean:message key="info.volumeName"/></th>
	      <td width=220px>
	    	 	<nested:select property="mvValue4Show" >
	  	           <html:optionsCollection name="<%=DdrActionConst.REQUEST_MV_NAME_AND_VALUE%>" filter="false"/>
			  	</nested:select>
	
	        <html:button property="selectMVBtn" onclick="selectMv();">
	        	<bean:message key="common.button.select" bundle="common"/>
	        </html:button>
	      </td>
	    </tr>
	    <tr>
	      <th><bean:message key="info.storage.capacity"/></th>
	      <td>
	          <DIV id="mvSize">
	              <nested:define id="showCap" property="capacity" type="java.lang.String"/>
	              <logic:notEqual name="showCap" value="">
                     <%=(new DecimalFormat("#,##0.0")).format(new Double(showCap))%>
                  </logic:notEqual>
	          </DIV>
	      </td>
	    </tr>
	    <tr>
	      <th><bean:message key="info.diskarrayName"/></th>
	      <td>
	        <DIV id="mvDiskName"><nested:write property="aname"/></DIV>
	      </td>
	    </tr>
	    <tr>
	      <th valign="top"><bean:message key="pair.detail.poolnameno"/></th>
 	      
	      <nested:define id="pool" property="poolNameAndNo" type="java.lang.String"/>
	      <%String divHeight = (pool.split("<br>").length >=3) ? "54px" : "auto";%>
	      <td valign="top">
	          <DIV id="mvPoolNameAndNo" style="overflow: auto; width: auto; height:<%=divHeight%>">
	              <nested:write property="poolNameAndNo" filter="false"/>
	          </DIV>
	      </td>
	    </tr>
	    <tr>
	      <th><bean:message key="info.pool.raidType"/></th>
	      <td><DIV id="mvRaidType"><nested:write property="raidType"/></DIV></td>
	    </tr>
	  </table>

</nested:nest>
