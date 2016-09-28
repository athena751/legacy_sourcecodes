<!--
        Copyright (c) 2007-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: volumelicensecommon.jsp,v 1.3 2008/02/25 05:50:22 liy Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ page import="com.nec.nsgui.action.volume.VolumeActionConst"%>
<%@ page import="java.lang.Double" %>
<%@ page import="java.text.DecimalFormat" %>

<%String moduleBundle=request.getParameter("moduleBundle");%>
<logic:equal name="<%=VolumeActionConst.SESSION_MACHINE_PROCYON%>" value="true" scope="session">
    <bean:define id="licenseCap" name="<%=VolumeActionConst.SESSION_VOL_LIC_LICENSECAP%>" scope="session" type="java.lang.String"/>
    <bean:define id="totalFSCap" name="<%=VolumeActionConst.SESSION_VOL_LIC_TOTALFSCAP%>" scope="session" type="java.lang.String"/>
    <table border="0">
    	<logic:equal name="<%=VolumeActionConst.SESSION_VOL_LIC_EXCEEDLICENSE%>" value="true" scope="session">
	        <tr>
	           <td class="ErrorInfo"><img border=0 src="/nsadmin/images/icon/png/icon_alert.png"></td>
			   <td class="ErrorInfo"><bean:message key="volumeLicense.warning.exceed" bundle="<%=moduleBundle%>"/></td>
	        </tr>
        </logic:equal>
        <tr>
            <td>&nbsp;</td>
            <td>
            	<table border="0">
                	<tr>
                    	<td><bean:message key="volumeLicense.th.licenseCapacity" bundle="<%=moduleBundle%>"/></td>
                    	<td><bean:message key="msg.batch.colon" bundle="<%=moduleBundle%>"/></td>
                    	<logic:equal name="<%=VolumeActionConst.SESSION_DISPLAY_LIC_NOLIMIT%>" value="true" scope="session">
	                    	<td style="text-align:right"><bean:message key="volumeLicense.nolimit" bundle="<%=moduleBundle%>"/></td>
                    	</logic:equal>
	                	<logic:notEqual name="<%=VolumeActionConst.SESSION_DISPLAY_LIC_NOLIMIT%>" value="true" scope="session">
	                    	<td style="text-align:right"><%=(licenseCap.equals(VolumeActionConst.DOUBLE_HYPHEN)) ? licenseCap : ((new DecimalFormat("#,##0.0")).format(new Double(licenseCap)))%></td>
                    	</logic:notEqual>
                	</tr>
                	<tr>
                    	<td><bean:message key="volumeLicense.th.totalFSCapacity" bundle="<%=moduleBundle%>"/></td>
                    	<td><bean:message key="msg.batch.colon" bundle="<%=moduleBundle%>"/></td>
                      	<td style="text-align:right"><%=(totalFSCap.equals(VolumeActionConst.DOUBLE_HYPHEN)) ? totalFSCap : ((new DecimalFormat("#,##0.0")).format(new Double(totalFSCap)))%></td>
	                </tr>
    	        </table>
            </td>
        </tr>        
    </table>
</logic:equal>