<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
--> 

<!-- "@(#) $Id: niclist.jsp,v 1.2 2005/10/24 04:40:50 dengyp Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-bean" prefix="bean" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<html:base/>
</head>
<frameset rows="*,60"   border=1 >
   <frame name="niclisttop"        src="../../nic/dispNicList.do?Operation=getNicList"  border=0 > 
   <frame name="niclistbottom"    src="../../nic/listBottom.do" 
      class="TabBottomFrame">   
</frameset>
</html>
