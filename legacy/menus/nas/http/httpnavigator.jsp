<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: httpnavigator.jsp,v 1.2306 2007/04/27 03:43:36 liul Exp $" -->
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@page import="java.util.*,com.nec.sydney.atom.admin.base.*"%>
<%@page import="com.nec.sydney.atom.admin.http.*,com.nec.sydney.beans.base.*"%>
<%@page import="com.nec.sydney.framework.*" %>

<%
    String frameNo=request.getParameter("frameNo");
    frameNo = frameNo==null?"0":frameNo;
%>
<jsp:useBean id="httpNavigatorBean" scope="page"  class="com.nec.sydney.beans.http.HttpNavigatorBean"/>
<jsp:setProperty name="httpNavigatorBean" property="*" />
<%AbstractJSPBean _abstractJSPBean = httpNavigatorBean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>
<%@page language="java"%>
<html>
<head>
<script src="../common/general.js"></script>
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=EUC-JP">
<META HTTP-EQUIV="expires" CONTENT="0">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">

<%
    String path=httpNavigatorBean.getPath();
    String act = request.getParameter("act");
    String frompage = request.getParameter("frompage");
    int countCifs = 0;
    if(frameNo.equals("0")){
        if (act.equals("getall")){

%>
<title><nsgui:message key="nas_nfs/navi/title_h1_file"/></title>
<%     } else {   %>

<title><nsgui:message key="nas_nfs/navi/title_h2_directory"/></title>
<%      }%>
</head>
<script>
var info = browserInfo();

if(info=="LNS4"){
    document.write("<frameset rows=72,28 >");
}else{
    document.write("<frameset rows=80,20 >");
}
</script>
    <frame marginwidth=5 marginheight=5 name=topframe src=<%= response.encodeURL("httpnavigator.jsp") %>?frameNo=1&act=<%=act%>&frompage=<%=frompage%>>
    <frame marginwidth=0 marginheight=0 name=bottomframe src=<%= response.encodeURL("httpnavigator.jsp") %>?frameNo=2&act=<%=act%>&frompage=<%=frompage%>>
    </frameset>


</html>

<!-- +++++++++++++++++++++  frame 1  +++++++++++++++++++++ -->

<%
    } else if(frameNo.equals("1")) {
%>
<script language="JavaScript"/>
    function chooseDir(encodedPath, path){
        document.flagForm.path.value = path;
        //get the string path after "/export/".
        var directoryName = encodedPath.substring(8, encodedPath.length);
        if (encodedPath == top.frames[1].document.forms[0].directory.value) {
            document.flagForm.action = "<%=response.encodeURL("httpnavigator.jsp")%>?frameNo=1";
            document.flagForm.submit();
        }else{
            top.frames[1].document.forms[0].directory.value = encodedPath;
            top.frames[1].document.forms[0].directoryDisplay.value = directoryName;
        }
    }

<%  if (act.equals("getall")){%>
    function chooseFile(encodedPath){
            //document.forms[0].path.value = path;
            //get the string paths after "/export/".
            var paths = encodedPath.substring(8, encodedPath.length).split("/");
            var d = "";
            for(var i=0; i<paths.length-1; i++){
                d = d + paths[i] + "/";
            }
            d = d.substring(0,d.length-1);
            var fileName = encodedPath.substring(8, encodedPath.length);
            top.frames[1].document.forms[0].directory.value = "/export/"+d;
            top.frames[1].document.forms[0].directoryDisplay.value = d;
            top.frames[1].document.forms[0].createDir.value = paths[paths.length-1];
    }
<%}%>
</script>
</head>
<body>
<form name="flagForm" method="post" >
    <input type="hidden" name="path" value="">
    <input type="hidden" name="operation" value="findPath">
    <input type="hidden" name="act" value="<%=httpNavigatorBean.getAct()%>">
    <input type="hidden" name="alertFlag" value="enable">
    <input type="hidden" name="frompage" value="<%=frompage%>">
</form>
<%if (frompage != null && frompage.equals("ftp")){%>
<h1 class="popup"><nsgui:message key="nas_ftp/common/h1"/></h1>
<%}else{%>
<h1 class="popup"><nsgui:message key="nas_http/common/h1"/></h1>
<%}%>
<%  if(act.equals("nfs")){%>
            <h2 class="popup"><nsgui:message key="nas_nfs/navi/title_h2_directory"/></h2>
<%  }else if(act.equals("getall")){%>
            <h2 class="popup"><nsgui:message key="nas_nfs/navi/title_h1_file"/></h2>
<%   }%>

<%
        Map exportMap = httpNavigatorBean.getExportMap();
        Vector subDir = httpNavigatorBean.getDir();
        String encodeUpperPath = httpNavigatorBean.getDefaultPath();
        String upperPath = NSUtil.ascii2hStr(httpNavigatorBean.getDefaultPath());
        if (!path.equals(httpNavigatorBean.getDefaultPath())){
            int sublen = path.lastIndexOf("0x2f");
            upperPath = path.substring(0,sublen);
            encodeUpperPath = httpNavigatorBean.encoding(upperPath, exportMap);
        }

        if (subDir == null){
            String[] sepaInfo = {httpNavigatorBean.encoding(path, exportMap)};
%>
        <p><%=NSMessageDriver.getInstance().getMessage(session,"nas_nfs/navi/p_nodir", sepaInfo, false)%></p>
<%
        } else if (path.equals("") && subDir.size()==0){
%>
        <p><nsgui:message key="nas_nfs/navi/p_nodata"/></p>
<%
        } else  {
%>
    <table width = 100%>
    <tr>
    <th align="left">
    </th>
    <th align="left"><nsgui:message key="nas_nfs/navi/th_name"/></th>
    <th align="left"><nsgui:message key="nas_nfs/navi/th_date"/></th>
    <th align="left"><nsgui:message key="nas_nfs/navi/th_time"/></th>
    </tr>
<%
            if (!httpNavigatorBean.encoding(path, exportMap).equals(httpNavigatorBean.getDefaultPath())){
%>
    <tr>
      <td><a href="#" onclick='chooseDir("<%=encodeUpperPath%>", "<%=upperPath%>");
                 return false'>
           <img border=0 src="../../../images/back.gif"></a></td>
        <td nowrap><a href="#" onclick='chooseDir("<%=encodeUpperPath%>", "<%=upperPath%>");
                 return false'>
            <nsgui:message key="nas_common/common/msg_parent"/>
            </a>
        </td>
    </tr>
<%        }
        // show all the subDir;
        for (int i=0; i<subDir.size(); i++){
            String aDir = (String)subDir.get(i);
            StringTokenizer token = new StringTokenizer(aDir);
            // must be 11 tokens.
            String type = token.nextToken(); // permit
            token.nextToken(); // a number?
            token.nextToken(); // owner
            token.nextToken(); // group
            String size = token.nextToken();
            token.nextToken(); // week
            String mon = token.nextToken();
            String day = token.nextToken();
            String time = token.nextToken();
            String year = token.nextToken();
            String name = token.nextToken();
            String choosedPath = path + "0x2f" + name;
            String encodedChoosedPath = httpNavigatorBean.encoding(choosedPath, exportMap);
            String encodeName = encodedChoosedPath.split("/")[encodedChoosedPath.split("/").length-1];
            String invalidPatterns = "^[~-]|[^a-z\\sA-Z0-9_\\.~-]";
            if(NSUtil.matches(encodeName,invalidPatterns)){
                continue;
            }
            String date = day + "/" + mon + "/" + year;
            if (size.equals("4096"))size = "4K";
%>
    <tr>
<%
    if (type.charAt(0) == 'd'){
%>
    <td><a href="#" onclick='chooseDir("<%=encodedChoosedPath%>","<%=choosedPath%>"); return false'>
        <img border=0 src="../../../images/folder.gif"></a></td>
    <td nowrap><a href="#" onclick='chooseDir("<%=encodedChoosedPath%>","<%=choosedPath%>"); return false'><%=NSUtil.space2nbsp(encodeName)%></a></td>
<%          }else {     %>
    <td><a href="#" onclick='chooseFile("<%=encodedChoosedPath%>"); return false'>
        <img border=0 src="../../../images/text.gif"></a></td>
    <td nowrap><a href="#" onclick='chooseFile("<%=encodedChoosedPath%>"); return false'><%=NSUtil.space2nbsp(encodeName)%></a></td>

<%
    }
%>
        <td nowrap><b><%=date%></b></td>
        <td nowrap><b><%=time%></b></td>
    </tr>
<%
        } // end of the subDir loop.
    }
%>
    </table>

</body>
</html>

<!-- +++++++++++++++++++++  frame 2  +++++++++++++++++++++ -->

<%}else if(frameNo.equals("2")){
%>
<%
    String exportRoot = httpNavigatorBean.getDefaultPath();
%>
    <script language="javaScript">
        function onOK(){
            if(!isSubmitted()){
                return false;
            }
            <%if (frompage == null || !frompage.equals("ftp")){%>
            var str = document.forms[0].createDir.value;
            if(str!=""){
                if(checkName(str)){
                    alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                            + <nsgui:message key="nas_http/alert/invalid_name"
                             firstReplace="document.forms[0].createDir.value" separate="true"/>);
                    return false;
                }
            }
            compactName(str);
            <%}%>
            // 1. The length of full path can not over 2047.
            // 2. The length of every level can not over 255.
            var fullPath=document.forms[0].directory.value;
            <%if (frompage == null || !frompage.equals("ftp")){%>
            var newDir=document.forms[0].createDir.value;
            document.forms[0].createDir.value = newDir;
            if(newDir != "") {
                fullPath+="/" + newDir;
            }
            <%}%>
            if(chkLevelNumber(fullPath)){
                <%if (act.equals("getall")){%>
                    alert("<nsgui:message key="nas_http/alert/msg_error_file"/>");
                <%}else{%>
                    alert("<nsgui:message key="nas_http/alert/msg_error_directory"/>");
                <%}%>
                return false;
            }

            if(fullPath.length>2047){
                alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                        + "<nsgui:message key="nas_nfs/alert/over_max"/>");
                return false;
            }
            <%if (act.equals("getall")){%>
            if(chkEveryLevel(newDir)){
                alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                        + "<nsgui:message key="nas_nfs/alert/over_level_max"/>");
                return false;
            }
            <%}%>
            // End.
            top.path.value=fullPath;
            top.close();
            return true;
        }

        function chkLevelNumber(str){
            //below the mount point.
            //"/export/group/" is error
            if(document.forms[0].directory.value.split("/").length<4 ){
                return true;
            }
            //"/export/group/mount" is error if file is not allowed.
            <%if ((frompage == null || !frompage.equals("ftp")) && act.equals("getall")){%>
            if (str.split("/").length<5 || document.forms[0].createDir.value==""){
                return true;
            }
            <%}%>
            return false;
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

        function checkName(str){
            var valid = /^[~\.\-]|[^0-9a-z A-Z_\/\-\.~]|\/\.|\/~|\/\-/g;
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
	        <%if (frompage == null || !frompage.equals("ftp")){%>
	        document.forms[0].createDir.value=str;
	        <%}%>
        }

       function resetdir(){
               document.forms[0].directory.value = "";
               document.forms[0].directoryDisplay.value = "<nsgui:message key="nas_common/common/msg_select"/>";
               <%if (frompage == null || !frompage.equals("ftp")){%>
               document.forms[0].createDir.value = "";
               document.forms[0].createDir.focus();
               <%}%>
       }

</script>
<jsp:include page="../../common/wait.jsp" />
</head>

<body onResize="resize()" onload="displayAlert();">
<form>
    <table width="100%">
      <tr>
        <td>
             <table width="100%" border="0" cellpadding="0" cellspacing="0">
               <tr><td nowrap>
                 <%=httpNavigatorBean.getDefaultPath()+"/"%>
                 <input type="text" name="directoryDisplay" size="<%=frompage != null && frompage.equals("ftp")?"30":"18"%>"
                     value="<nsgui:message key="nas_common/common/msg_select"/>"
                     onFocus="this.blur()" readonly>
                     <input type="hidden" name="directory" value="">
                     <%
                     //if it is http , directory can be created,
                     //otherwise it is ftp ,directory can't be created.
                     if (frompage == null || !frompage.equals("ftp")){
                     %>
                             /
               <input type="text" name="createDir" size="15">
                    <%}%>
             </td></tr>
           </table>
        </td>
      </tr>
      <tr>
       <td>
           <input type="button" name="ok" value="<nsgui:message key="common/button/submit"/>" onclick="onOK()">
           <input type="button" name="reset" value="<nsgui:message key="common/button/reset"/>" onclick="resetdir()">
           <input type="button" name="cancel" value="<nsgui:message key="common/button/close"/>" onclick="parent.close()">
        </td>
      </tr>
     </table>
    <input type="hidden" name="alertFlag" value="enable">
    </form>
    </body>
</html>

<%} //end of frame 2 %>
