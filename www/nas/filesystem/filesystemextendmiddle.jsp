<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: filesystemextendmiddle.jsp,v 1.5 2007/05/09 08:07:03 xingyh Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.taglib.nssorttab.*"%>
<%@ page import="com.nec.nsgui.action.filesystem.*"%>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>

<%@ taglib uri="/WEB-INF/tld/struts-html.tld"  prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld"  prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/nssorttab.tld"    prefix="nssorttab" %>

<%@ page buffer="32kb" %>
<html:html lang="true">
<head>
<%@ include file="../../common/head.jsp" %>
<bean:define id="isNashead" value="<%=(NSActionUtil.isNashead(request))? "true":"false"%>"/>

<script language="JavaScript">
function init(){
    <logic:notEmpty name="<%=FilesystemConst.SESSION_FREELD_TABLE_MODEL%>" scope="session">
        parent.bottomFrame.location = "<%=request.getContextPath()%>/filesystem/extendFSBottom.do";
    </logic:notEmpty>
}

function changeButton() {
    var selectedLdNum = 0;
    if (!(document.forms[0].ldCheckbox.length)) {
        if (document.forms[0].ldCheckbox.checked) {
            selectedLdNum++;
        }
    } else {
        for (var i = 0; i < document.forms[0].ldCheckbox.length; i++) {
            if (document.forms[0].ldCheckbox[i].checked) {
                selectedLdNum++;
            }
        }
    }
    
    if (parent.bottomFrame
        && parent.bottomFrame.document
        && parent.bottomFrame.document.forms[0]) {
	    if (selectedLdNum == 0) {
	        parent.bottomFrame.document.forms[0].set.disabled = true;
	    } else {
	        parent.bottomFrame.document.forms[0].set.disabled = false;
	    }      
    }
    
    <logic:equal name="isNashead" value="true" scope="session">
	    <logic:equal name="hasGfsLicense" value="true" scope="session">
		    if (parent.topFrame 
		        && parent.topFrame.document
		        && parent.topFrame.document.getElementById("striping")) {
		        if (selectedLdNum >= 2) {
			      parent.topFrame.document.getElementById("striping").disabled = false;
	              parent.topFrame.document.getElementById("notStriping").disabled = false;		      
			    } else {
	              parent.topFrame.document.getElementById("striping").disabled = true;
	              parent.topFrame.document.getElementById("notStriping").disabled = true;		        
			    }
		    }
	    </logic:equal>
    </logic:equal>
}
</script>
</head> 
<body onload="init();">
<form>
    <logic:equal name="isNashead" value="true">
        <h3 class="title"><bean:message key="filesystem.extend.h3.lunSelect"/></h3>
    </logic:equal>
    <logic:notEqual name="isNashead" value="true" >
        <h3 class="title"><bean:message key="filesystem.extend.h3.ldSelect"/></h3>
    </logic:notEqual>
    
    <logic:empty name="<%=FilesystemConst.SESSION_FREELD_TABLE_MODEL%>" scope="session">
        <logic:equal name="isNashead" value="true">
            <p><bean:message key="filesystem.extend.noLun"/></p>
        </logic:equal>
        <logic:notEqual name="isNashead" value="true" >
            <p><bean:message key="filesystem.extend.noFreeLd"/></p>
        </logic:notEqual>
    </logic:empty>
    <logic:notEmpty name="<%=FilesystemConst.SESSION_FREELD_TABLE_MODEL%>" scope="session">
        <bean:define id="tableModel" name="<%=FilesystemConst.SESSION_FREELD_TABLE_MODEL%>" scope="session"/>
        
        <logic:equal name="isNashead" value="true" >
            <nssorttab:table  tablemodel="<%=(SortTableModel)tableModel%>" 
                        id="list1"
                        table="border=1" 
                        sortonload="lun:ascend" >
                      
                <nssorttab:column name="checkbox" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.filesystem.STDataRender4Filesystem"
                              sortable="no">
                
                </nssorttab:column>
            
                <nssorttab:column name="lun" 
                                  th="STHeaderRender" 
                                  td="com.nec.nsgui.action.filesystem.STDataRender4Filesystem"
                                  comparator="com.nec.nsgui.taglib.nssorttab.NumberStringComparator"
                                  sortable="yes">
                    <bean:message key="filesystem.extend.th.lun"/>
                </nssorttab:column>
                <nssorttab:column name="storage" 
                                  th="STHeaderRender" 
                                  td="STDataRender"
                                  sortable="yes">
                    <bean:message key="filesystem.extend.th.storage"/>
                </nssorttab:column>
          
                <nssorttab:column name="ldSize" 
                                  th="STHeaderRender" 
                                  td="com.nec.nsgui.action.filesystem.STDataRender4Filesystem"
                                  comparator="com.nec.nsgui.taglib.nssorttab.NumberStringComparator"
                                  sortable="yes">
                    <bean:message key="filesystem.extend.th.size"/>
                </nssorttab:column>
            </nssorttab:table>
        </logic:equal>
        
        <logic:notEqual name="isNashead" value="true" >
            <nssorttab:table  tablemodel="<%=(SortTableModel)tableModel%>" 
                          id="list1"
                          table="border=1" 
                          sortonload="ldNo:ascend" >
                      
                <nssorttab:column name="checkbox" 
                                  th="STHeaderRender" 
                                  td="com.nec.nsgui.action.filesystem.STDataRender4Filesystem"
                                  sortable="no">
                
                </nssorttab:column>
            
                <nssorttab:column name="ldNo" 
                                  th="STHeaderRender" 
                                  td="com.nec.nsgui.action.filesystem.STDataRender4Filesystem"
                                  comparator="com.nec.nsgui.taglib.nssorttab.NumberStringComparator"
                                  sortable="yes">
                    <bean:message key="filesystem.extend.th.ldNo"/>
                </nssorttab:column>
                <nssorttab:column name="ldPath" 
                                  th="STHeaderRender" 
                                  td="STDataRender"
                                  comparator="com.nec.nsgui.action.filesystem.LdPathComparator"
                                  sortable="yes">
                    <bean:message key="filesystem.extend.th.ldName"/>
                </nssorttab:column>
                <nssorttab:column name="ldSize" 
                                  th="STHeaderRender" 
                                  td="com.nec.nsgui.action.filesystem.STDataRender4Filesystem"
                                  comparator="com.nec.nsgui.taglib.nssorttab.NumberStringComparator"
                                  sortable="yes">
                    <bean:message key="filesystem.extend.th.size"/>
                </nssorttab:column>
            </nssorttab:table>
        </logic:notEqual>
    </logic:notEmpty>
</form>
</body>
</html:html>