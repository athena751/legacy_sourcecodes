<!--
        Copyright (c) 2008-2009 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: nfsdetailinfomiddle.jsp,v 1.6 2009/04/27 04:46:14 yangxj Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ taglib uri="struts-nested" prefix="nested" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil" %>
<%@ page import="com.nec.nsgui.model.entity.nfs.NFSConstant" %>
<html>
<head>
<%@include file="../../common/head.jsp" %>
<html:base/>
<script language="JavaScript" src="../../common/common.js"></script>
<script language="JavaScript" src="../../common/validation.js"></script>
<script language="JavaScript" src="nfscommon.js"></script>
<script language="JavaScript">
</script>
</head>
<body>
<html:form action="nfsDetailInfoMid.do">
<logic:empty name="clients" scope="request">
  <p><bean:message key="export.detail.noclients"/></p>
</logic:empty>
<logic:notEmpty name="clients" scope="request">
<table class="Blank">
  <tr>
    <td align="right">
      <table class="Blank">
      <logic:equal name="<%= NFSConstant.NFS_SESSION_RPQ_LICENSE_KEY %>" value="0" scope="session">
        <tr>
           <td><font class="legendTitle">[<bean:message key="export.detail.legend.option"/>]</font></td>
           <td></td>
           <td><font class="legendTitle">[<bean:message key="export.detail.legend.log"/>]</font></td>
        </tr>
        <tr>
          <td><font class="legend"><bean:message key="legend.option.A"/><bean:message key="legend.colon"/><bean:message key="checkbox.subtree.check"/></font></td>
          <td><font class="legend"><bean:message key="legend.option.D"/><bean:message key="legend.colon"/><bean:message key="checkbox.accesslog"/>&nbsp;&nbsp;&nbsp;&nbsp;</font></td>
          <td><font class="legend"><bean:message key="legend.log.a"/><bean:message key="legend.colon"/><bean:message key="nfs.checkbox.accesslogproc.specific.create"/></font></td>
        </tr>
        <tr>
          <td><font class="legend"><bean:message key="legend.option.B"/><bean:message key="legend.colon"/><bean:message key="checkbox.hide"/></font></td>
          <td><font class="legend"><bean:message key="legend.option.E"/><bean:message key="legend.colon"/><bean:message key="checkbox.unstablewrite"/></font></td>
          <td><font class="legend"><bean:message key="legend.log.b"/><bean:message key="legend.colon"/><bean:message key="nfs.checkbox.accesslogproc.specific.remove"/>&nbsp;&nbsp;&nbsp;&nbsp;</font></td>
        </tr>
        <tr>
          <td><font class="legend"><bean:message key="legend.option.C"/><bean:message key="legend.colon"/><bean:message key="checkbox.secure"/>&nbsp;&nbsp;&nbsp;&nbsp;</font></td>
          <td></td>
           <td><font class="legend"><bean:message key="legend.log.c"/><bean:message key="legend.colon"/><bean:message key="nfs.checkbox.accesslogproc.specific.write"/></font></td>
        </tr>
        <tr>
          <td></td>
          <td></td>
          <td><font class="legend"><bean:message key="legend.log.d"/><bean:message key="legend.colon"/><bean:message key="nfs.checkbox.accesslogproc.specific.read"/></font></td>
        </tr>
      </logic:equal>
      <logic:notEqual name="<%= NFSConstant.NFS_SESSION_RPQ_LICENSE_KEY %>" value="0" scope="session">
        <tr>
           <td><font class="legendTitle">[<bean:message key="export.detail.legend.option"/>]</font></td>
           <td><font class="legendTitle">[<bean:message key="export.detail.legend.log"/>]</font></td>
        </tr>
        <tr>
          <td><font class="legend"><bean:message key="legend.option.A"/><bean:message key="legend.colon"/><bean:message key="checkbox.subtree.check"/></font></td>
          <td><font class="legend"><bean:message key="legend.log.a"/><bean:message key="legend.colon"/><bean:message key="nfs.checkbox.accesslogproc.specific.create"/></font></td>
        </tr>
        <tr>
          <td><font class="legend"><bean:message key="legend.option.B"/><bean:message key="legend.colon"/><bean:message key="checkbox.hide"/></font></td>
          <td><font class="legend"><bean:message key="legend.log.b"/><bean:message key="legend.colon"/><bean:message key="nfs.checkbox.accesslogproc.specific.remove"/>&nbsp;&nbsp;&nbsp;&nbsp;</font></td>
        </tr>
        <tr>
          <td><font class="legend"><bean:message key="legend.option.C"/><bean:message key="legend.colon"/><bean:message key="checkbox.secure"/>&nbsp;&nbsp;&nbsp;&nbsp;</font></td>
           <td><font class="legend"><bean:message key="legend.log.c"/><bean:message key="legend.colon"/><bean:message key="nfs.checkbox.accesslogproc.specific.write"/></font></td>
        </tr>
        <tr>
          <td><font class="legend"><bean:message key="legend.option.D"/><bean:message key="legend.colon"/><bean:message key="checkbox.accesslog"/>&nbsp;&nbsp;&nbsp;&nbsp;</font></td>
          <td><font class="legend"><bean:message key="legend.log.d"/><bean:message key="legend.colon"/><bean:message key="nfs.checkbox.accesslogproc.specific.read"/></font></td>
        </tr>
      </logic:notEqual>
      </table>
    </td>
  </tr>
  <tr>
    <td>
      <table border=1 class='Default'>
        <tr>
          <th colspan=2><bean:message key="th.connectable.client"/></th>
          <th rowspan=2><bean:message key="th.access.mode"/></th>
          <th rowspan=2><bean:message key="th.user.mapping"/></th>
          <th rowspan=2><bean:message key="th.squashed.users"/></th>
          <th colspan=2><bean:message key="th.anonymous.id"/></th>
        <logic:equal name="<%= NFSConstant.NFS_SESSION_RPQ_LICENSE_KEY %>" value="0" scope="session">
          <th colspan=5><bean:message key="th.other.options"/></th>
        </logic:equal>
        <logic:notEqual name="<%= NFSConstant.NFS_SESSION_RPQ_LICENSE_KEY %>" value="0" scope="session">
          <th colspan=4><bean:message key="th.other.options"/></th>
        </logic:notEqual>
          <th colspan=4><bean:message key="th.export.detail.loggingitems"/></th>
        </tr>
        <tr>
			<th><bean:message key="th.export.detail.client"/></th>
			<th><bean:message key="th.export.detail.nisdomain"/></th>
			<th><bean:message key="text.uid"/></th>
			<th><bean:message key="text.gid"/></th>
			<th><bean:message key="legend.option.A"/></th>
			<th><bean:message key="legend.option.B"/></th>
			<th><bean:message key="legend.option.C"/></th>
			<th><bean:message key="legend.option.D"/></th>
		<logic:equal name="<%= NFSConstant.NFS_SESSION_RPQ_LICENSE_KEY %>" value="0" scope="session">
			<th><bean:message key="legend.option.E"/></th>
		</logic:equal>
			<th><bean:message key="legend.log.a"/></th>
			<th><bean:message key="legend.log.b"/></th>
			<th><bean:message key="legend.log.c"/></th>
			<th><bean:message key="legend.log.d"/></th>
        </tr>

        <logic:iterate name="clients" id="oneClient">
	         <tr>
			    <td><bean:write name="oneClient" property="client"/></td>
			    <logic:equal name="oneClient" property="nisDomain" value="--">
	                <td align="center">
	                  <bean:message key="accesslog.proc.none"/>
	                </td>
			    </logic:equal> 
			    <logic:notEqual name="oneClient" property="nisDomain" value="--">
				    <td>
				        <bean:write name="oneClient" property="nisDomain"/>
				    </td>
			    </logic:notEqual>
			    <td>
				    <logic:equal name="oneClient" property="accessMode" value="rw">
				        <bean:message key="radio.read.write"/>
				    </logic:equal>
                    <logic:equal name="oneClient" property="accessMode" value="ro">
                        <bean:message key="radio.read.only"/>
                    </logic:equal> 				     
			    </td>
			    <td>
                    <logic:equal name="oneClient" property="usermapping" value="map">
                        <bean:message key="radio.map"/>
                    </logic:equal>
                    <logic:equal name="oneClient" property="usermapping" value="anon">
                        <bean:message key="radio.anonymous"/>
                    </logic:equal>
                    <logic:equal name="oneClient" property="usermapping" value="no_map">
                        <bean:message key="radio.no.map"/>
                    </logic:equal>  			    
			    </td>
			    <td>
                    <logic:equal name="oneClient" property="rootSquash" value="root_squash">
                        <bean:message key="radio.root.only"/>
                    </logic:equal>
                    <logic:equal name="oneClient" property="rootSquash" value="all_squash">
                        <bean:message key="radio.all"/>
                    </logic:equal>
                    <logic:equal name="oneClient" property="rootSquash" value="no_root_squash">
                        <bean:message key="radio.none"/>
                    </logic:equal> 
			    </td>
			    <td><bean:write name="oneClient" property="annonuid"/></td>
			    <td><bean:write name="oneClient" property="annongid"/></td>
			    <td align="center">
			      <logic:equal name="oneClient" property="subtree" value="true">    
	                    <img src="/nsadmin/images/nation/check.gif">
	              </logic:equal>
                  <logic:equal name="oneClient" property="subtree" value="false">    
                        &nbsp;
                  </logic:equal>
	            </td>
			    <td align="center">
	              <logic:equal name="oneClient" property="hide" value="true">    
	                    <img src="/nsadmin/images/nation/check.gif">
	              </logic:equal>
                  <logic:equal name="oneClient" property="hide" value="false">    
                        &nbsp;
                  </logic:equal>	              		    
			    </td>
			    <td align="center">
	              <logic:equal name="oneClient" property="secure" value="true">    
	                    <img src="/nsadmin/images/nation/check.gif">
	              </logic:equal>
                  <logic:equal name="oneClient" property="secure" value="false">    
                        &nbsp;
                  </logic:equal>
			    </td>
				<td align="center">
	              <logic:equal name="oneClient" property="accesslog" value="true">    
	                    <img src="/nsadmin/images/nation/check.gif">
	              </logic:equal>
                  <logic:equal name="oneClient" property="accesslog" value="false">    
                        &nbsp;
                  </logic:equal>    
			    </td>
			  <logic:equal name="<%= NFSConstant.NFS_SESSION_RPQ_LICENSE_KEY %>" value="0" scope="session">
			    <td align="center">
	              <logic:equal name="oneClient" property="unstablewrite" value="true">    
	                    <img src="/nsadmin/images/nation/check.gif">
	              </logic:equal>
                  <logic:equal name="oneClient" property="unstablewrite" value="false">    
                        &nbsp;
                  </logic:equal>    
			    </td>
			  </logic:equal>
			    <td align="center">
	              <logic:equal name="oneClient" property="create" value="1">    
	                    <img src="/nsadmin/images/nation/check.gif">
	              </logic:equal>
                  <logic:equal name="oneClient" property="create" value="0">    
                        &nbsp;
                  </logic:equal>
                  <logic:equal name="oneClient" property="create" value="--">    
                        <bean:message key="accesslog.proc.none"/>
                  </logic:equal>                  	              
			    </td>
			    <td align="center">
                  <logic:equal name="oneClient" property="remove" value="1">    
                        <img src="/nsadmin/images/nation/check.gif">
                  </logic:equal>
                  <logic:equal name="oneClient" property="remove" value="0">    
                        &nbsp;
                  </logic:equal>
                  <logic:equal name="oneClient" property="remove" value="--">    
                        <bean:message key="accesslog.proc.none"/>
                  </logic:equal>                              
			    </td>
			    <td align="center">
                  <logic:equal name="oneClient" property="write" value="1">    
                        <img src="/nsadmin/images/nation/check.gif">
                  </logic:equal>
                  <logic:equal name="oneClient" property="write" value="0">    
                        &nbsp;
                  </logic:equal>
                  <logic:equal name="oneClient" property="write" value="--">    
                        <bean:message key="accesslog.proc.none"/>
                  </logic:equal>     
			    </td>
			    <td align="center">
                  <logic:equal name="oneClient" property="read" value="1">    
                        <img src="/nsadmin/images/nation/check.gif">
                  </logic:equal>
                  <logic:equal name="oneClient" property="read" value="0">    
                        &nbsp;
                  </logic:equal>
                  <logic:equal name="oneClient" property="read" value="--">    
                        <bean:message key="accesslog.proc.none"/>
                  </logic:equal>     
			    </td>
	        </tr>
        </logic:iterate>
      </table>
    </td>
  </tr>
</table>
</logic:notEmpty>
</html:form>
</body>
</html>