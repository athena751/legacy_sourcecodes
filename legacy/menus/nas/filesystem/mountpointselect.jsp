<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: mountpointselect.jsp,v 1.2306 2007/09/12 09:42:51 wanghb Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" %>
<%@ page import="com.nec.sydney.framework.*" %>
<%@ page import="java.util.* , com.nec.sydney.atom.admin.base.* , com.nec.sydney.beans.base.*" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>

<jsp:useBean id="MountPointSelectBean" scope="page" class="com.nec.sydney.beans.filesystem.MountPointSelectBean"/>
<jsp:setProperty name="MountPointSelectBean" property="*"/>
<% AbstractJSPBean _abstractJSPBean = MountPointSelectBean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>
<script src="../common/general.js"></script>

<%
    String frameNo = request.getParameter("frameNo");
    String codepage = request.getParameter("codepage");
    String level = request.getParameter("level");
    String mpoint = request.getParameter("mpoint");
    String fsType = request.getParameter("fsType");

//add by maojb on 2003.9.3 for cifs mapd use
    String from = request.getParameter("from");   // the parameter value : cifs , mapdauth , mapdnative
    String type = request.getParameter("type");   // the parameter value : file , dir

    if (frameNo.equals("0")) {
%>
<html>
<head>

<%
//add by maojb on 2003.9.3 for cifs mapd use
if( type != null && type.equals("file")) {
%>
<title><nsgui:message key="nas_cifs/common/select_title"/></title>
<%
} else {
%>
<title><nsgui:message key="nas_filesystem/fsmove/mp_select_title"/></title>
<%
}
%>

<%@include file="../../../menu/common/meta.jsp" %>
</head>

<script>
var info = browserInfo();

if(info=="LNS4"){
    document.write("<frameset rows=72,28 >");
}else{
    document.write("<frameset rows=80,20 >");
}
</script>

<%
//add by maojb on 2003.9.3 for cifs mapd use
if (from==null) {
%>
    <frame marginwidth=5 marginheight=5 name=topframe src='<%= response.encodeURL("mountpointselect.jsp") %>?frameNo=1&codepage=<%=codepage%>&level=<%=level%>&mpoint=<%=mpoint%>&fsType=<%=fsType%>'>
    <frame marginwidth=0 marginheight=0 name=bottomframe src='<%= response.encodeURL("mountpointselect.jsp") %>?frameNo=2&codepage=<%=codepage%>&level=<%=level%>&mpoint=<%=mpoint%>&fsType=<%=fsType%>'>
<%
} else {
%>
    <frame marginwidth=5 marginheight=5 name=topframe src='<%= response.encodeURL("mountpointselect.jsp") %>?frameNo=1&from=<%=from%>&type=<%=type%>'>
    <frame marginwidth=0 marginheight=0 name=bottomframe src='<%= response.encodeURL("mountpointselect.jsp") %>?frameNo=2&from=<%=from%>&type=<%=type%>'>
<%
}
%>

</frameset>
</html>
<%
    } else if (frameNo.equals("1")) {

%>
<html>
<head>
<%@include file="../../../menu/common/meta.jsp" %>
</head>
<script language="javaScript">


function chooseDir(hexPath , pathStr) {
    if(top.frames[1].document.forms[0]) {
        if (pathStr == top.frames[1].document.forms[0].existDir.value) {
                document.forms[0].hexpath.value = URLEncoder(hexPath);
                document.forms[0].submit();
            }else{
                top.frames[1].document.forms[0].existDir.value = pathStr;
                top.frames[1].document.forms[0].directory.value = pathStr;
                top.frames[1].document.forms[0].hexpath.value = hexPath;
                document.forms[0].hexpath.value = hexPath;

                top.frames[1].document.forms[0].isFile.value = "n";
            }
    }
}

//add the function by maojb on 2003.9.3 for cifs mapd use
function chooseFile(filePath) {
    if(top.frames[1].document.forms[0]) {
        top.frames[1].document.forms[0].existDir.value = filePath;
        top.frames[1].document.forms[0].directory.value = filePath;
        top.frames[1].document.forms[0].hexpath.value = filePath;
        document.forms[0].hexpath.value = filePath;

        top.frames[1].document.forms[0].isFile.value = "y";

    }
}

function initIsFile() {
    if (top.frames[1].document.forms[0]) {
        top.frames[1].document.forms[0].isFile.value = "n";
    }
}
</script>
</head>
<body onLoad="displayAlert(); initIsFile()">
<%
if (from == null) {
%>
<h1 class="popup"><nsgui:message key="nas_filesystem/common/h1"/></h1>
<%
} else if(from.equals("cifs")){
%>
<h1 class="popup"><nsgui:message key="nas_cifs/common/h1_cifs"/></h1>
<%
} else if(from.equals("mapdauth")) {
%>
<h1 class="popup"><nsgui:message key="nas_mapd/common/h1_setup"/></h1>
<%
} else if(from.equals("mapdnative")) {
%>
<h1 class="popup"><nsgui:message key="nas_native/common/h1"/></h1>
<%
} else if(from.equals("ftpd")) {
%>
<h1 class="popup"><nsgui:message key="nas_ftp/common/h1"/></h1>
<%
}
%>

<%
if (type != null && type.equals("file")){
%>
<h2 class="popup"><nsgui:message key="nas_cifs/common/select_title"/></h2>
<%
} else {
%>
<h2 class="popup"><nsgui:message key="nas_nfs/navi/title_h2_directory"/></h2>
<%
}
%>
<form method="post" action='<%=response.encodeURL("mountpointselect.jsp")%>?frameNo=1'>
<input type="hidden" name="operation">
<input type="hidden" name="beanClass" value="<%=MountPointSelectBean.getClass().getName()%>">
<input type="hidden" name="alertFlag" value="enable">
<input type="hidden" name="hexpath" value='<jsp:getProperty name="MountPointSelectBean" property="hexpath"/>'>


<%
//add by maojb on 2003.9.3 for cifs mapd use
if (from == null) {
%>
<input type="hidden" name="codepage" value='<jsp:getProperty name="MountPointSelectBean" property="codepage"/>'>
<input type="hidden" name="level" value='<jsp:getProperty name="MountPointSelectBean" property="level"/>'>
<input type="hidden" name="mpoint" value='<jsp:getProperty name="MountPointSelectBean" property="mpoint"/>'>
<input type="hidden" name="fsType" value='<jsp:getProperty name="MountPointSelectBean" property="fsType"/>'>
<%
} else {
%>
<input type="hidden" name="from" value="<%=from%>">
<input type="hidden" name="type" value="<%=type%>">
<%
}
%>


<%
        String hexpath = MountPointSelectBean.getHexpath();

//modify by maojb on 2003.9.3 for cifs mapd use
        int sublen;
        if (from == null) {
            sublen = hexpath.lastIndexOf("0x2f");
        } else {
            sublen = hexpath.lastIndexOf("/");
        }
        String parentPathHex = hexpath.substring(0,sublen);

        String parentPathShow;
        if (from == null) {
            parentPathShow = NSUtil.hStr2EncodeStr(parentPathHex, codepage, CommonConst.BROWSER_ENCODE);
        } else {
            parentPathShow = parentPathHex;
        }


        Vector dirList = MountPointSelectBean.getDirList();

//modify by maojb on 2003.9.3 for cifs mapd use
        int dirType;
        if (from == null) {
            dirType = MountPointSelectBean.getDirType(); // 0 : exportgroup 1: direct mount 2: sub mount
        } else {
            if(hexpath.equals("/etc")) {
                dirType = -1;  // should display "openldap" , no parent
            } else {
                dirType = -2;  // should display parent
            }
        }
        if (dirType == 1) {
            parentPathShow = "";
        }

        if(parentPathShow.equals("/etc")){
            parentPathShow = "/etc/openldap";
        }

        if ((dirList == null || dirList.size() == 0) && dirType == 0) {

%>
    <p><nsgui:message key="nas_filesystem/fsmove/no_exportgroup"/></p>
<%
//modify by maojb on 2003.9.3 for cifs mapd use
        } else if ((dirList == null || dirList.size() == 0) && dirType == -1) {
%>
    <p><nsgui:message key="nas_cifs/alert/no_openldap_dir"/></p>
<%
        } else {
%>
    <table width="100%">
    <tr>
        <th align="left">&nbsp;</th>
        <th align="left"><nsgui:message key="nas_filesystem/fsmove/th_name"/></th>
        <th align="left"><nsgui:message key="nas_filesystem/fsmove/th_date"/></th>
        <th align="left"><nsgui:message key="nas_filesystem/fsmove/th_time"/></th>
    </tr>
<%
//modify by maojb on 2003.9.3 for cifs mapd use
            if(dirType != 0 && dirType != -1 ) {
%>
    <tr>
        <td><a href="#" onclick='chooseDir("<%=parentPathHex%>","<%=parentPathShow%>"); return false'>
            <img border=0 src="../../../images/back.gif"></a></td>
        <td nowrap><a href="#" onclick='chooseDir("<%=parentPathHex%>","<%=parentPathShow%>"); return false'>
            <nsgui:message key="nas_common/common/msg_parent"/></a></td>
    </tr>
<%
            }

            // show all the subDir;
            for (int i=0; i<dirList.size(); i++){
                String aDir = (String)dirList.get(i);
                StringTokenizer token = new StringTokenizer(aDir);
                // must be 11 tokens.
                String typeStr = token.nextToken(); // permit
                token.nextToken(); // a number?
                token.nextToken(); // owner
                token.nextToken(); // group
                String size = token.nextToken();
                token.nextToken(); // week
                String mon = token.nextToken();
                String day = token.nextToken();
                String time = token.nextToken();
                String year = token.nextToken();
                String hexname = token.nextToken();

//modify by maojb on 2003.9.3 for cifs mapd use
                String hexsubdir;
                if (from == null) {
                    hexsubdir = hexpath + "0x2f" + hexname;
                } else {
                    hexsubdir = hexpath + "/" + hexname;  //the hex isn't hex , is string
                }

//modify by maojb on 2003.9.3 for cifs mapd use
                String subdirStr;
                if (from == null) {
                    subdirStr = NSUtil.hStr2EncodeStr(hexsubdir, codepage, CommonConst.BROWSER_ENCODE);
                } else {
                    subdirStr = hexsubdir;
                }


                String date = day + "/" + mon + "/" + year;

//modify by maojb on 2003.9.3 for cifs mapd use
                String nameStr;
                if(from == null) {
                    nameStr = NSUtil.hStr2EncodeStr(hexname, codepage, CommonConst.BROWSER_ENCODE);
                } else {
                    nameStr = hexname;
                }
                String invalidPatterns = "^[~-]|[^a-zA-Z0-9_\\.~-]";

                if(NSUtil.matches(nameStr,invalidPatterns)){
                    continue;
                }

                boolean isFile = true;
                if(typeStr.charAt(0) == 'd') {
                    isFile = false;
                }
%>
    <tr>
<%
//modify by maojb on 2003.9.3 for cifs mapd use
if (type != null && isFile ) {
%>
        <td><a href="#" onclick='chooseFile("<%=subdirStr%>"); return false'>
            <img border=0 src="../../../images/text.gif"></a></td>
        <td nowrap><a href="#" onclick='chooseFile("<%=subdirStr%>"); return false'>
            <%=nameStr%></a></td>
        <td nowrap><b><%=date%></b></td>
        <td nowrap><b><%=time%></b></td>
<%
} else {
%>
        <td><a href="#" onclick='chooseDir("<%=hexsubdir%>","<%=subdirStr%>"); return false'>
            <img border=0 src="../../../images/folder.gif"></a></td>
        <td nowrap><a href="#" onclick='chooseDir("<%=hexsubdir%>","<%=subdirStr%>"); return false'>
            <%=nameStr%></a></td>
        <td nowrap><b><%=date%></b></td>
        <td nowrap><b><%=time%></b></td>
<%
}
%>
    </tr>

<%
            }
%>
</table>
<%
        }
%>
</form>
</body>
</html>
<%
    } else {
%>

<html>
<head>
<%@include file="../../../menu/common/meta.jsp" %>

<script language="JavaScript">
function setOperation(form, op) {
    form.operation.value = op;
}

function resetdir(){
    document.forms[0].directory.value = "<nsgui:message key="nas_common/common/msg_select"/>";
    document.forms[0].existDir.value = "";
    document.forms[0].hexpath.value = "";
    document.forms[0].createDir.value = "";
    document.forms[0].createDir.focus();
}

//add the function by maojb on 2003.9.3 for cifs mapd use
function resetdirInCifs() {
    document.forms[0].directory.value = "<nsgui:message key="nas_common/common/msg_select"/>";
    document.forms[0].existDir.value = "";
    document.forms[0].hexpath.value = "";
}

function checkName(str){
    var valid = /^[~\.\-]|[^0-9a-zA-Z_\/\-\.~]|\/\.|\/~|\/\-/g;
    var flag=str.search(valid);
    if(flag!=-1){
        return true;
    }else{
        return false;
    }
}

function compactName(str){
    var regExp = /\/+/g;
    str = str.replace(regExp,"/");
    if(str.charAt(0)=="/"){
        str = str.substring(1);
    }
    if(str!="") {
        if(str.charAt(str.length-1)=="/"){
            str = str.substring(0,str.length-1);
        }
    }
    document.forms[0].createDir.value=str;
}

function chkEveryLevel(str){
    var tmpArray=new Array();
    var reg=/\//g;
    tmpArray=str.split(reg);
    for(var index=0; index<tmpArray.length; index++){
        if (tmpArray[index].length>255){
            return true;
        }
    }
    return false;
}

function checkLevels(str) {
    var tmpArray=new Array();
    var reg=/\//g;
    tmpArray=str.split(reg);
    var info = browserInfo();

    var levels;
    if (info == "IE") {
        levels = tmpArray.length + 1;
    } else {
        levels = tmpArray.length;
    }

    if (levels == top.frames[0].document.forms[0].level.value) {
        return false;
    } else {
        return true;
    }
}


//add the function by maojb on 2003.9.3 for cifs mapd use
function onOKInCifs() {
    var selDir=trim(document.forms[0].existDir.value);
    var directory=trim(document.forms[0].directory.value);

    document.forms[0].existDir.value = selDir;
    document.forms[0].directory.value = directory;

    if(selDir == ""){
        alert("<nsgui:message key="nas_cifs/alert/file_dir_none"/>");
        return false;
    }

<%
if (type != null && type.equals("file")) {
%>
    if(document.forms[0].isFile.value == "n") {
        alert("<nsgui:message key="nas_cifs/alert/file_none"/>");
        return false;
    }
<%
}
%>

    if(top.window.opener&&!top.window.opener.closed){
        if(top.window.opener.pathForDisp) {
            top.window.opener.pathForDisp.value = selDir;
        }
    }

    top.close();
}
</script>

<jsp:include page="../../../menu/common/wait.jsp"/>
</head>
<body onResize="resize()" onLoad="displayAlert()">
<form method="post" >
<input type="hidden" name="operation">
<input type="hidden" name="beanClass" value="<%=MountPointSelectBean.getClass().getName()%>">
<input type="hidden" name="alertFlag" value="enable">

<input type="hidden" name="hexpath" value='<jsp:getProperty name="MountPointSelectBean" property="hexpath"/>'>
<input type="hidden" name="isFile" value="">

<%
//modify by maojb on 2003.9.3 for cifs mapd use
if (from == null) {
%>
<input type="hidden" name="codepage" value='<jsp:getProperty name="MountPointSelectBean" property="codepage"/>'>
<input type="hidden" name="level" value='<jsp:getProperty name="MountPointSelectBean" property="level"/>'>
<input type="hidden" name="mpoint" value='<jsp:getProperty name="MountPointSelectBean" property="mpoint"/>'>
<input type="hidden" name="fsType" value='<jsp:getProperty name="MountPointSelectBean" property="fsType"/>'>
<%
}
%>

<table width="100%">
    <tr>
        <td>
            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                <tr><td nowrap>
<%
//modify by maojb on 2003.9.3 for cifs mapd use
if (from == null) {
%>
                    <input type="hidden" name="existDir" value="">
                    <input type="text" name="directory" size="18"
                        value="<nsgui:message key="nas_common/common/msg_select"/>"
                        onFocus="this.blur()" readonly > /

                    <input type="text" name="createDir" size="10">
<%
} else {
%>
                    <input type="hidden" name="existDir" value="">
                    <input type="text" name="directory" size="30"
                        value="<nsgui:message key="nas_common/common/msg_select"/>"
                        onFocus="this.blur()" readonly >
<%
}
%>
                </td></tr>
            </table>
       </td>
    </tr>
    <tr>
        <td>
<%if (from == null) {%>
<%} else {%>
           <input type="button" name="ok" value="<nsgui:message key="common/button/submit"/>" onclick="onOKInCifs()">
            <input type="button" name="reset" value="<nsgui:message key="common/button/reset"/>" onclick="resetdirInCifs()">
<%
}
%>
            <input type="button" name="cancel" value="<nsgui:message key="common/button/close"/>" onclick="parent.close()">
        </td>
    </tr>
    </table>
</form>
</body>
</html>
<%
    }
%>
