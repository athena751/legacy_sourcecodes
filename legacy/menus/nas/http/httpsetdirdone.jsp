<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: httpsetdirdone.jsp,v 1.2301 2004/04/15 10:14:34 caoyh Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" %>
<%@ page import="com.nec.sydney.atom.admin.http.*" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>

<html>
<head>
<title><nsgui:message key="nas_http/directory/title"/></title>
<script language="JavaScript" src="../common/general.js">
</script>
<script language="JavaScript">
//    function setDone() {
        var setType = "<%= request.getParameter("setType") %>" ;
        var prePage = "<%= request.getParameter("prePage") %>" ;
        var oldNickName = "<%= request.getParameter("oldNickName") %>" ;
        if(oldNickName=="-"){
            oldNickName = "#";
        }
        //var directory = "<%//= request.getParameter("directory") %>" ;
        <%String dir = (String)session.getAttribute("http_directory");%>
        var directory = "<%=dir == null?"":dir%>";
        
        if (window.opener && !window.opener.closed && window.opener.document.forms[0].whichpage
                && window.opener.document.forms[0].whichpage 
                && (window.opener.document.forms[0].whichpage.value==prePage)
                && window.opener.document.forms[0].oldNickName 
                && (window.opener.document.forms[0].oldNickName.value==oldNickName)
                && window.opener.document.forms[0].directory
                && !(setType=="") && !(prePage=="") && !(directory=="")) {
            
            var selDir = window.opener.document.forms[0].directory ;
            
            if (setType=="<%=HTTPConstants.SET_DIR_ADD%>") {
                selDir.length += 1 ;
                selDir.options[selDir.length-1].value = directory ;
                selDir.options[selDir.length-1].text = directory ;
                selDir.options[selDir.length-1].selected = true ;
            } else if (setType=="<%=HTTPConstants.SET_DIR_DEL%>") {
                for (var i=0;i<(selDir.length);i++) {
                    if (selDir.options[i].value==directory) {
                        selDir.options[i] = null ;
                        if (selDir.selectedIndex < 0) {
                            if (i>=selDir.length) {
                                if (selDir.length>0) {
                                    selDir.options[selDir.length-1].selected=true ;
                                }
                            } else {
                                selDir.options[i].selected=true ;
                            }
                        }
                        break ;
                    }
                }
            } else if (setType=="<%=HTTPConstants.SET_DIR_EDIT%>") {
                var theDirectories = directory.split(":") ;
                for (var i=0;i<(selDir.length);i++) {
                    if (selDir.options[i].value==theDirectories[0]) {
                        selDir.options[i].value = theDirectories[1] ;
                        selDir.options[i].text = theDirectories[1] ;
                        break ;
                    }
                }
            }
            
            if (window.opener.document.forms[0].edit) {
                if (selDir.length>0) {
                    window.opener.document.forms[0].edit.disabled = false ;
                } else {
                    window.opener.document.forms[0].edit.disabled = true ;
                }
            }
        }
        window.close() ;
//    }
</script>
</head>
</body>
</html>