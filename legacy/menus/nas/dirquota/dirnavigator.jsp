<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: dirnavigator.jsp,v 1.2317 2008/02/29 03:22:30 lil Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" buffer="64kb"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@page import="java.util.*,com.nec.sydney.atom.admin.base.*"%>
<%@page import="com.nec.sydney.atom.admin.nfs.*,com.nec.sydney.beans.base.*"%>
<%@page import="com.nec.sydney.beans.dirquota.*"%>
<%@page import="com.nec.sydney.framework.*,
                com.nec.sydney.atom.admin.base.api.*,
                com.nec.nsgui.model.biz.base.*,
                com.nec.nsgui.action.base.NSActionUtil,
                com.nec.sydney.framework.*" %>

<%
    String frameNo=request.getParameter("frameNo");
    int nodeNo = NSActionUtil.getCurrentNodeNo(request);
    int RPQ_UTF8 = 1;
    int RPQ_SJIS = 1;
    try{
        RPQ_UTF8 = RpqLicense.getLicense("0001",nodeNo);
        RPQ_SJIS = RpqLicense.getLicense("0005",nodeNo);
    }catch(Exception e){}
%>

<jsp:useBean id="navigatorBean" scope="page"  class="com.nec.sydney.beans.dirquota.DirquotaListBean"/>
<%AbstractJSPBean _abstractJSPBean = navigatorBean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>
<%@page language="java"%>
<html>
<head>
<script src="../common/general.js"></script>
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=UTF-8">
<META HTTP-EQUIV="expires" CONTENT="0">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">

<%
    String wholePath=navigatorBean.getWholePath();
    String wholePathParent=navigatorBean.getWholePathParent();
    String act = request.getParameter("act");

    Vector subDir = navigatorBean.getDir();

    String mp=(String)session.getAttribute(NasConstants.MP_SESSION_HEX_MOUNTPOINT);

    String target = (String)session.getAttribute(NasConstants.TARGET);
    String export = (String)session.getAttribute(NasConstants.MP_SESSION_EXPORTROOT);
    String codepage = APISOAPClient.getCodepage(target, export);
    String mpAscii= NSActionUtil.hStr2Str(mp,codepage);
    
    String machineSeries=(String)request.getSession().getAttribute("machineSeries");             
    String canAddJaPath="";
    if( ( machineSeries.equals("Procyon") && ( !codepage.equals("English") ) )
            || ( RPQ_UTF8==0 && ( codepage.equals("UTF8") || codepage.equals("UTF8-NFC") ) )
            || ( RPQ_SJIS==0 && codepage.equals("SJIS") ) ){
        canAddJaPath="yes";
    }else{
        canAddJaPath="no";
    }

    //out.print("<hr>"+mpAscii+"<hr>");

    if(frameNo.equals("0")){
%>
    <title><nsgui:message key="nas_nfs/navi/title_h2_directory"/></title>
<script>
var info = browserInfo();

if(info=="LNS4"){
    document.write("<frameset rows=72,28 >");
}else{
    document.write("<frameset rows=80,20 >");
}
</script>
</head>
<body>
    <frame marginwidth=5 marginheight=5 name=topframe src="<%=response.encodeURL("dirnavigator.jsp")%>?frameNo=1&act=<%=act%>">
    <frame marginwidth=0 marginheight=0 name=bottomframe src="<%=response.encodeURL("dirnavigator.jsp")%>?frameNo=2&act=<%=act%>">
    </frameset>
</body>

</html>

<!-- +++++++++++++++++++++  frame 1  +++++++++++++++++++++ -->

<%
    } else if(frameNo.equals("1")) {
%>

<script language="JavaScript"/>
var back=0;
var clickFlag=0;
function chooseDir(encodedPath,path,abspath,permit){
    if(back==1 && permit=="chaos"){
        document.flagForm.wholePath.value = document.flagForm.wholePathParent.value;
        document.flagForm.action = "<%=response.encodeURL("dirnavigator.jsp")%>?frameNo=1&act=<%=act%>";
        document.flagForm.submit();
        return;
    }else{
        if(permit=="chaos"){
            top.frames[1].document.forms[0].nnn.value =
                "<%=NSActionUtil.hStr2Str(wholePathParent, codepage)%>";
            top.frames[1].document.forms[0].permit.value = "";
            top.frames[1].document.forms[0].absPath.value = "";

            back=1;
            return false;
        }
    }

    back=0;
    if(top.frames[1].document.forms[0]) {
        var bbb=(top.frames[1].document.forms[0].nnn.value).split("/");
        var last=bbb[bbb.length-1];

        if (encodedPath == last && clickFlag==1) {
            if(top.frames[1].document.forms[0].permit.value != "enter"){
                alert ("<nsgui:message key="nas_dataset/alert/not_enter"/>");
                return false;
            }
            document.flagForm.wholePath.value = "<%=wholePath%>"+"0x2f"+abspath;
            document.flagForm.action = "<%=response.encodeURL("dirnavigator.jsp")%>?frameNo=1&act=<%=act%>";
            document.flagForm.submit();
        }else{
            top.frames[1].document.forms[0].nnn.value =
                "<%=NSActionUtil.hStr2Str(wholePath, codepage)%>" + "/" + encodedPath;
            top.frames[1].document.forms[0].permit.value = permit;
            top.frames[1].document.forms[0].absPath.value = abspath;
            clickFlag = 1;
        }
    }
 }
</script>
</head>
<body>
<form name="flagForm" method="post">
    <input type="hidden" name="path" value="">
    <input type="hidden" name="alertFlag" value="enable">
    <input type="hidden" name="wholePath" value="">
    <input type="hidden" name="wholePathParent" value="<%=wholePathParent%>">
</form>
    <h1 class="popup"><nsgui:message key="nas_dataset/datasettop/dirquota"/></h1>
    <h2 class="popup"><nsgui:message key="nas_nfs/navi/title_h2_directory"/>&nbsp;&nbsp;&nbsp;<a href="#" style="text-decoration:underline;font-size:12px;font-weight:normal;" onClick="alert('<nsgui:message key="nas_dataset/alert/dataset_navi_notice"/>');return false"><nsgui:message key="nas_dataset/datasetnavi/notice"/></a></h2>

<%
        // if parent is MP, don't go to the upper.
        if (subDir.size()==0){
            if (!wholePath.equals(mp)){
%>
        <a href="#" onclick='chooseDir("","","","chaos");return false'>
        <img border=0 src="../../../images/back.gif"></a>
        <a href="#" onclick='chooseDir("","","","chaos");return false'>
        <nsgui:message key="nas_common/common/msg_parent"/></a>
        <br>
        <p><nsgui:message key="nas_nfs/navi/p_nodata"/></p>
<%
            }else{
%>
        <p><nsgui:message key="nas_nfs/navi/p_nodata"/></p>
<%
            }
        }else{
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
            if (!wholePath.equals(mp)){
%>
    <tr>
      <td><a href="#" onclick='chooseDir("","","","chaos");return false'>
          <img border=0 src="../../../images/back.gif"></a>
      </td>
      <td><a href="#" onclick='chooseDir("","","","chaos");return false'>
          <nsgui:message key="nas_common/common/msg_parent"/></a>
      </td>
    </tr>
<%        }
        // show all the subDir;

        String codePage = navigatorBean.getCodePage(export);
        for (int i=0; i<subDir.size(); i++){
            String aDir = (String)subDir.get(i);
            StringTokenizer token = new StringTokenizer(aDir);
            // must be 11 tokens.
            String type = token.nextToken(); // permit
            String permit=token.nextToken(); // a number?
            token.nextToken(); // owner
            token.nextToken(); // group
            String size = token.nextToken();
            token.nextToken(); // week
            String mon = token.nextToken();
            String day = token.nextToken();
            String time = token.nextToken();
            String year = token.nextToken();
            String name = token.nextToken();
            String sub=name;
            String encodedSub = navigatorBean.encoding(name, codePage);
            String date = day + "/" + mon + "/" + year;
            if (size.equals("4096"))size = "4K";
            name = navigatorBean.encoding(name, codePage);
            
            if( canAddJaPath.equals("yes") ){
                String[] invalidChars = {"\\", ":", ",", ";", "*", "?", "\"", "<", ">", "|"};
                boolean isValid = true;
                for(int j = 0; j < invalidChars.length; j++){
                    if(name.indexOf(invalidChars[j]) != -1){
                        isValid = false;
                        break;
                    }
                }
                if (!isValid){
                    continue;
                }
            }else{
                String invalidPatterns = "^[~-]|[^a-zA-Z0-9_\\.~-]";
                if(NSUtil.matches(name,invalidPatterns)){
                    continue;
                }
            }
            String absSub = sub;
%>
    <tr>
<%

        if (token.hasMoreTokens()) {
        }else {
%>
        <td>
            <a href="#" onclick='chooseDir("<%=HTMLUtil.sanitize(encodedSub)%>","<%=sub%>","<%=absSub%>","<%=permit%>"); return false'>
            <img border=0 src="../../../images/folder.gif"></a>
        </td>
        <td nowrap>
            <a href="#" onclick='chooseDir("<%=HTMLUtil.sanitize(encodedSub)%>","<%=sub%>","<%=absSub%>","<%=permit%>"); return false'><%=NSUtil.space2nbsp(HTMLUtil.sanitize(name))%></a>
        </td>
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

<%} else if(frameNo.equals("2")){
%>
<%
    if (act.equals("dirquotalist")){
%>

<script language="JavaScript">

    function checkName(str){
        <%if( canAddJaPath.equals("yes") ){%>
            var invalid = /[\\:,;\*\?\"<>|\s]/g;
        <%}else{%>
            var invalid = /^[~\.\-]|[^0-9a-zA-Z_\/\-\.~]|\/\.|\/~|\/\-/g;
        <%}%>
        var flag=str.search(invalid);
        if(flag!=-1){
            return false;
        }else{
            return true;
        }
    }

    function compactName(str){
            var regExp = /\/+/g;
            str = str.replace(regExp,"/");
            if(str.charAt(0)=="/"){
		str = str.substring(1);
	    }

	    if(str.charAt(str.length-1)=="/"){
	        str = str.substring(0,str.length-1);
	    }

	    document.forms[0].directoryDisplay.value=str;
     }

    function onOK(){
        if (!top.frames[0].document.forms[0]){
            return false;
        }else{
            if (document.forms[0].nnn.value=="<nsgui:message key="nas_common/common/msg_select"/>"
                || (document.forms[0].nnn.value=="<%=mpAscii%>"&&(document.forms[0].directoryDisplay.value=="")) ){
                alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                        + "<nsgui:message key="nas_nfs/alert/no_dir"/>");
                return false;
            }

            if( (document.forms[0].permit.value != "sel")
                && document.forms[0].directoryDisplay.value==""){
            	alert("<nsgui:message key="nas_dataset/alert/not_set"/>");
            	return false;
            }

            if(document.forms[0].directoryDisplay.value!=""){
                if(!checkName(document.forms[0].directoryDisplay.value)
                    ||!checkName(document.forms[0].nnn.value)){
                    <%if( canAddJaPath.equals("yes") ){%>
                        alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                        + "<nsgui:message key="nas_dataset/alert/invalid_name_rpq1"/>");
                    <%}else{%>
                        alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                        + "<nsgui:message key="nas_dataset/alert/invalid_name"/>");
                    <%}%>
                    return false;
                }

                compactName(document.forms[0].directoryDisplay.value);
            }


            var strPath;

            if(top.frames[1].document.forms[0].directoryDisplay.value!=""){
                strPath = top.frames[1].document.forms[0].nnn.value+"/"+
                    top.frames[1].document.forms[0].directoryDisplay.value;
            }else{
                strPath = top.frames[1].document.forms[0].nnn.value;
            }
            var str = strPath.replace(/[^\x00-\x7f]/g, "  ");
            if(str.length > 2047){
            	alert("<nsgui:message key="nas_dataset/alert/dirquota_path_toolong"/>");
            	return false;
            }
            if (top.opener
                &&top.opener.document.forms[0]
                &&top.opener.document.forms[0].dirText){
                top.opener.document.forms[0].dirText.value=strPath;
                top.close();
            } else{
                top.close();
            }
        }
    }
</script>
</head>
<body onResize="resize()">
  <form>
    <table>
    <tr><td>
    <%if (!wholePath.equals(mp)){%>
        <input type="text" name="nnn" size="40"
            value="<nsgui:message key="nas_common/common/msg_select"/>"
            readonly onfocus="this.blur();">
    <%}else{%>
        <input type="text" name="nnn" size="40"
            value="<%=mpAscii%>"
            readonly onfocus="this.blur();">
    <%}%>
    / <input type="text" name="directoryDisplay" size="10">
    <input type="hidden" name="absPath" value="">
    <input type="hidden" name="permit" value="">
    <input type="hidden" name="alertFlag" value="enable">
    </td></tr>
    <tr><td>
    <input type="button" value="<nsgui:message key="common/button/submit"/>"
            onClick='onOK();'>
    <input type="button" name="cancel"
            value="<nsgui:message key="common/button/close"/>"
            onclick="parent.close()">

    </td></tr>
    </table>
    </form>
</body>
</html>
<%
        }
%>

<%} //end of frame 2 %>
