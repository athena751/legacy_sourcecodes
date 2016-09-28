<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: LVMError.jsp,v 1.2301 2008/02/29 11:53:32 liy Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<html>
<head>
<script>
function displayAlert(){
<%
String tempMsg = (String)session.getAttribute("alertMessage");
session.setAttribute("alertMessage",null);
String cluster = request.getParameter("cluster");
String fromPage = request.getParameter("fromPage");
if (fromPage == null || fromPage.equals("")){
    throw new Exception("cannot decide from which page.");
}
if (tempMsg != null && !tempMsg.trim().equals("")){
    String outputStr = "";
    for (int i = 0; i<tempMsg.length();i++){
        if (tempMsg.charAt(i) == '\'' 
            || tempMsg.charAt(i) == '\"'){
            outputStr = outputStr + "\\" + tempMsg.charAt(i);
        }else if (tempMsg.charAt(i) == '\\'){
            if ((i+1 < tempMsg.length()) 
                && (tempMsg.charAt(i+1) == 'r' || tempMsg.charAt(i+1) == 'n')){
                outputStr = outputStr + tempMsg.charAt(i) + tempMsg.charAt(i+1);
                i++;
            }else{
                outputStr = outputStr + "\\" + tempMsg.charAt(i);
            }
        }else{
            outputStr = outputStr + tempMsg.charAt(i);
        }
    }
%>

        window.alert("<%=outputStr%>");
    <%    
    if (fromPage.equals("fromDestory")
        || fromPage.equals("fromCreate") 
        || fromPage.equals("fromManage") 
        || fromPage.equals("fromMove")
        || fromPage.equals("fromExtend")
        || fromPage.equals("fromExtendShow")){
    %>
            window.location = "<%=response.encodeURL("LVMList.jsp")%>?cluster=<%=cluster%>";
    <%}%>

<%}%>
}
</script>
</head>
<body onload="displayAlert();">
</body>
</html>