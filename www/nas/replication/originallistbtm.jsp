<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: originallistbtm.jsp,v 1.2 2005/09/16 02:04:23 liyb Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>


<html>
<head>
<%@include file="../../common/head.jsp" %>    
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">

function init(){

    var originalRadio;
    if ((parent.bottomframe.document.forms[0])
         && (parent.bottomframe.document.forms[0].elements["originalRadio"] != null)) {
    
        originalRadio = parent.bottomframe.document.forms[0].elements["originalRadio"];
        
        //if only one radio
        if (!(originalRadio.length)) {
           originalRadio.click();
        } else {                                 //if has a varry of radio
            var hasChecked = false;
            for (var i = 0; i < originalRadio.length; i++) {
                if (originalRadio[i].checked) {
                     hasChecked = true;
                     originalRadio[i].click();
                }
            }
            
            if (!hasChecked) {
               originalRadio[0].click();
            }
        }
    } else {
        // if no original , disable all button 
            parent.btnframe.document.forms[0].modifyBtn.disabled=true;
            parent.btnframe.document.forms[0].deleteBtn.disabled=true;
            parent.btnframe.document.forms[0].demoteBtn.disabled=true;        
    }
}
   
</script>
</head>
<body onload="init();parent.bottomframe.displayAlert();">
	<form method="POST"  name="btnForm">
		<html:button property="modifyBtn"  onclick="parent.bottomframe.onSet('preModify');">        
		   <bean:message key="common.button.modify2" bundle="common"/>  
		</html:button>
		&nbsp;
		<html:button property="demoteBtn"  onclick="parent.bottomframe.onSet('preDemote');">        
		   <bean:message key="original.button.demote2" />  
		</html:button>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<html:button property="deleteBtn"  onclick="parent.bottomframe.onSet('delete');">        
		   <bean:message key="common.button.delete" bundle="common"/> 
		</html:button>
	</form>
</body>

</html>
