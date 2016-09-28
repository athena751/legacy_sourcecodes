<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: rrdpropertyclose.jsp,v 1.2 2005/10/21 15:29:21 het Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="struts-bean" prefix="bean" %>

<html>
<head>
    <title>
       <bean:message key="statis.properties.h2.display.period"/>
    </title>
    <script language="JavaScript">
        opener.refreshGraph();
        window.close();        
    </script>
</head>
<body>
</body>
</html>