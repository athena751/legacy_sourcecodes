<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: filesystemextendtop.jsp,v 1.8 2007/08/23 05:14:36 xingyh Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.action.filesystem.FilesystemConst" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld"   prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld"   prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld"  prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld"  prefix="displayerror" %>

<%@ page import="java.lang.Double" %>
<%@ page import="java.text.DecimalFormat" %>

<html:html lang="true">
<head>
<%@ include file="../../common/head.jsp" %>
<script language="JavaScript" src="<%=request.getContextPath()%>/common/common.js"></script>
<script language="JavaScript">
function onReload() {
    if (isSubmitted()) {
        return false;
    }
    
    setSubmitted();
    parent.location="/nsadmin/filesystem/extendFSShow.do?from=extend";
    lockMenu();
    return true;
}

function onBack() {
    if (isSubmitted()) {
        return false;
    }
    lockMenu();
    setSubmitted();
    window.parent.location="<html:rewrite page='/filesystemListAndDel.do?operation=display'/>";
}

function init() {
    <logic:equal name="isNashead" value="true" scope="session">
        <logic:equal name="hasGfsLicense" value="true" scope="session">
		    if (document.getElementById("striping")) {
			    if (parent.middleFrame
			        && parent.middleFrame.document
			        && parent.middleFrame.document.forms[0]
			        && parent.middleFrame.document.forms[0].ldCheckbox) {

				    var selectedLdNum = 0;
				    if (!(parent.middleFrame.document.forms[0].ldCheckbox.length)) {
				        if (parent.middleFrame.document.forms[0].ldCheckbox.checked) {
				            selectedLdNum++;
				        }
				    } else {
				        for (var i = 0; i < parent.middleFrame.document.forms[0].ldCheckbox.length; i++) {
				            if (parent.middleFrame.document.forms[0].ldCheckbox[i].checked) {
				                selectedLdNum++;
				            }
				        }
				    }
	
		            if (selectedLdNum >= 2) {
		              document.getElementById("striping").disabled = false;
		              document.getElementById("notStriping").disabled = false;            
		            } else {
		              document.getElementById("striping").disabled = true;
		              document.getElementById("notStriping").disabled = true;               
		            }
		        }
			}
	    </logic:equal>
    </logic:equal>
}
</script>
</head> 
<body onLoad="init();displayAlert();" onUnload="unLockMenu();closeDetailErrorWin()">
    <h1 class="title"><bean:message key="h1.filesystem"/></h1>
    <html:button property="backBtn" onclick="onBack();">
        <bean:message key="common.button.back" bundle="common"/>
    </html:button>&nbsp;&nbsp;&nbsp;&nbsp;
    <html:button property="reloadBtn" onclick="return onReload();">
        <bean:message key="common.button.reload" bundle="common"/>
    </html:button>
    <h2 class="title"><bean:message key="filesystem.extend.h2"/></h2>
    <displayerror:error h1_key="h1.filesystem"/>
    <br>
    <jsp:include page="../volume/volumelicensecommon.jsp" flush="true">
	    <jsp:param name="moduleBundle" value="volume/filesystem"/>
    </jsp:include>
    <br>
    <form> 
        <bean:define id="fsInfo" name="<%=FilesystemConst.SESSION_FS_INFO_OBJ%>" scope="session"/>
        <nested:root name="fsInfo">
	        <table border="1" nowrap class="Vertical">
                <tr>
                    <th align=left><bean:message key="info.volumeName" bundle="volume/filesystem"/></th>
                    <td align=left>
                        <nested:define id="volumeName4Show" property="volumeName"/>  
                        <%=volumeName4Show.toString().replaceFirst("NV_LVM_", "")%>
                </td>
                </tr>
                <tr>
                    <th align=left><bean:message key="info.mountpoint" bundle="volume/filesystem"/></th>
                    <td><nested:write property="mountPoint" /></td>
                </tr>
                <tr>
                    <th align=left><bean:message key="info.capacity" bundle="volume/filesystem"/></th>
                    <td>
                    	<nested:define id="showCap" property="capacity" type="java.lang.String"/>
                        <%=(new DecimalFormat("#,##0.0")).format(new Double(showCap))%>	
                    </td>
                </tr>
                
                <logic:equal name="isNashead" value="true" scope="session">
                    <logic:equal name="hasGfsLicense" value="true" scope="session"> 
		                <nested:equal property="useGfs" value="true">
		                    <th align="left"><bean:message key="info.gfs" bundle="volume/filesystem"/></th>
		                    <td>
		                       <nested:radio property="striping" styleId="striping" value="true" disabled="true"/>
				               <label for="striping">
				                  <bean:message key="info.striping" bundle="volume/filesystem"/>
				               </label>
				               &nbsp;&nbsp;
				               <nested:radio property="striping" styleId="notStriping" value="false" disabled="true"/>
				               <label for="notStriping">
				                  <bean:message key="info.not.striping" bundle="volume/filesystem"/>
				               </label>
		                    </td>
		                </nested:equal>
	                </logic:equal>
                </logic:equal>	                
            </table>
        </nested:root>
    </form>
</body>
</html:html>


