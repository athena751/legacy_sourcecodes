<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: LVMList.jsp,v 1.2316 2008/07/02 03:51:49 xingyh Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@page import="java.util.*,com.nec.sydney.atom.admin.base.*,com.nec.sydney.beans.base.*"%>
<%@ page import="com.nec.sydney.framework.*" %>
<%@ page import="com.nec.nsgui.taglib.nssorttab.*"%>

<%@ page buffer="32kb" %>

<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ taglib uri="/WEB-INF/tld/nssorttab.tld" prefix="nssorttab" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>

<jsp:useBean id="listBean" scope="page" class="com.nec.sydney.beans.lvm.LVMListBean"/>
<%AbstractJSPBean _abstractJSPBean = listBean; %>
<%@ include file="../../../menu/common/includeheader.jsp" %>
<%@include file="../../../menu/common/fornashead.jsp" %>

<%@page language="java"%>
<%
    String diskarrayError = (String)session.getAttribute("diskarrayErrOccured");
    if (diskarrayError != null && diskarrayError.equals("true")){
        session.setAttribute("diskarrayErrOccured", null);
        return;
    }
%>
<HTML>
<HEAD>
<TITLE>List Logical Volume</TITLE>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=EUC-JP">
<script language="JavaScript" src="../common/general.js"></script>
<script language="JavaScript" src="/nsadmin/nas/volume/volumecommon.js"></script>
<script language="JavaScript">

var start=1;    //ignore the first form which only include buttons

function enablebutton(obj) {
    var LVListForm = obj.form;
    LVListForm.Extend.disabled=false;
    LVListForm.Remove.disabled=false;
    <%if (listBean.getType() && !listBean.is1Node()){%>
        LVListForm.Move.disabled=false;
    <%}%>
    var tmp = obj.value.split(",");    
    var accessMode = tmp[5];
    if(accessMode == "ro"){
  	    LVListForm.Extend.disabled=true;
    }
}

function disableButton() {
    var len=1;
    if(document.forms.length){
        len=document.forms.length;
        if(document.othersFrm){
            len--;
        }
    }
	//add for nas9131 by WangLi
	if(document.othersFrm&&document.othersFrm.manage){
		document.othersFrm.manage.disabled=true;
		if (document.othersFrm.otherRadio){
			var rlength= document.othersFrm.otherRadio.length;
			if(rlength==null) {
				if(document.othersFrm.otherRadio.checked){
					document.othersFrm.manage.disabled=false;
					var message = document.othersFrm.otherRadio.value.split(",");
					document.othersFrm.lvName.value = message[0];
				    document.othersFrm.ldName.value	= message[4];
				}
			} else {
				var m=rlength;
				for(var i=0; i<document.othersFrm.otherRadio.length && m==rlength; i++) {
					if(document.othersFrm.otherRadio[i].checked){
						m=i;
						var message = document.othersFrm.otherRadio[i].value.split(",");
						document.othersFrm.lvName.value = message[0];
					    document.othersFrm.ldName.value	= message[4];
					}
				}
				if(m!=document.othersFrm.otherRadio.length) {
					document.othersFrm.manage.disabled=false;
				}
			}
		}
    }
    for(var n=start; n<len; n++){
        if(document.forms[n].radioButton==null) {
            document.forms[n].Extend.disabled=true;
            document.forms[n].Remove.disabled=true;
            <%if (listBean.getType() && !listBean.is1Node()){%>
                document.forms[n].Move.disabled=true;
            <%}%>
            continue;
        }
        var rlength= document.forms[n].radioButton.length;
        if(rlength==null) {
            if(document.forms[n].radioButton.checked){
                document.forms[n].Extend.disabled=false;
                document.forms[n].Remove.disabled=false;
                <%if (listBean.getType() && !listBean.is1Node()){%>
                    document.forms[n].Move.disabled=false;
                <%}%>
            } else {
                document.forms[n].Extend.disabled=true;
                document.forms[n].Remove.disabled=true;
                <%if (listBean.getType() && !listBean.is1Node()){%>
                    document.forms[n].Move.disabled=true;
                <%}%>
            }
        } else {
            var m=rlength;
            for(var i=0; i<document.forms[n].radioButton.length && m==rlength; i++) {
                if(document.forms[n].radioButton[i].checked)
                    m=i;
            }
            if(m==document.forms[n].radioButton.length) {
                document.forms[n].Extend.disabled=true;
                document.forms[n].Remove.disabled=true;
                <%if (listBean.getType() && !listBean.is1Node()){%>
                    document.forms[n].Move.disabled=true;
                <%}%>
            } else {
                document.forms[n].Extend.disabled=false;
                document.forms[n].Remove.disabled=false;
                <%if (listBean.getType() && !listBean.is1Node()){%>
                    document.forms[n].Move.disabled=false;
                <%}%>
            }
        }
    }
}

function OnCreate(n, asCluster) {
    var lvNum = 0;
    var len=1;
    if(document.forms.length) {
        len=document.forms.length;
    }
    for(var i=start; i<len; i++){
    	lvNum = lvNum + parseInt(document.forms[i].lvNum.value);
    }
 
    if(lvNum >= 256) {
        alert("<nsgui:message key="common/alert/failed"/>"
	       + "\r\n"
               + "<nsgui:message key="nas_lvm/alert/lv_max"/>");
        return false;
    }
    if(asCluster == "true") {
        window.location="<%=response.encodeURL("LVMCreateShow.jsp")%>?defaultNode="+n+"&lvtype=cluster";
    } else {
        window.location="<%=response.encodeURL("LVMCreateShow.jsp")%>?lvtype=singlenode";
    }
    disableButtonAll();
}

function OnExtend(LVListForm, asCluster) {
    var rlength=LVListForm.radioButton.length;
    if(asCluster == "true") {
        LVListForm.lvtype.value ="cluster";
    }else {
        LVListForm.lvtype.value ="singlenode";
    }

    if(rlength==null) {
        if(LVListForm.radioButton.checked){
            LVListForm.action="<%=response.encodeURL("LVMExtendShow.jsp")%>";
        	LVListForm.submit();
            disableButtonAll();
            return false;
        }
    } else {
        var n=rlength;
        for(var i=0; i<rlength && n==rlength; i++) {
            if(LVListForm.radioButton[i].checked) {
                n=i;
            }
        }
        if(n==rlength) {
            return false;
        } else {
            LVListForm.action="<%=response.encodeURL("LVMExtendShow.jsp")%>";
            LVListForm.submit();
            disableButtonAll();
        }
        return false;
    }
}

function OnRemove(LVListForm, host, asCluster) {
    var message;
    var rlength=LVListForm.radioButton.length;

    if(rlength==null) {
        if(LVListForm.radioButton.checked) {
            message=LVListForm.radioButton.value;
        }
    } else {
        var n=rlength;
        for(var i=0; i<rlength && n==rlength; i++) {
            if(LVListForm.radioButton[i].checked){
                n=i;
            }
        }
        if(n==rlength)
            return false;

        message=LVListForm.radioButton[n].value;
    }
    message=message.split(',');
    if(message[1]!="--") {
        alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
			  + "<nsgui:message key="nas_lvm/alert/unmount"/>");
        return false;
    } else {
        var msg = "<nsgui:message key="common/confirm"/>"
                    + "\r\n"
                    + "<nsgui:message key="common/confirm/act"/>"
                    + "<nsgui:message key="common/button/resource/destroy"/>"
                    + "\r\n"
                    + "<nsgui:message key="nas_lvm/LVMCreateShow/volume"/>"
                    + " : " +message[0];
        if(asCluster == "true"){
            LVListForm.lvtype.value ="cluster";
            msg = msg + "\r\n" + "<nsgui:message key="nas_lvm/LVMCreateShow/th_node"/>" + " : " + host;
        } else {
            LVListForm.lvtype.value ="singlenode";
        }
        if(isSubmitted()
	   &&confirm(msg)) {
            setSubmitted();
            LVListForm.action="<%=response.encodeURL("LVMRemove.jsp")%>";
            lockMenu();
            LVListForm.submit();
            disableButtonAll();
            return false;
        }
        return false;
    }
}

<%if (listBean.getType() && !listBean.is1Node()){%>
function OnMove(LVListForm){
    var message;
    var rlength = LVListForm.radioButton.length;

    if(rlength==null) {
        if(LVListForm.radioButton.checked) {
            message = LVListForm.radioButton.value;
        }
    } else {
        var n=rlength;
        for(var i=0; i<rlength && n==rlength; i++) {
            if(LVListForm.radioButton[i].checked){
                n=i;
            }
        }
        if(n==rlength){
            return false;
        }
        message = LVListForm.radioButton[n].value;
    }
    message = message.split(',');
    if(message[1] != "--") {
        alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
	      + "<nsgui:message key="nas_lvm/lvmMove/hasMount"/>");
        return false;
    } else {
        var msg = "<nsgui:message key="common/confirm"/>"
                    + "\r\n"
                    + "<nsgui:message key="common/confirm/act"/>"
                    + "<nsgui:message key="nas_lvm/lvmMove/Move"/>"
                    + "\r\n"
                    + "<nsgui:message key="nas_lvm/LVMCreateShow/volume"/>"
                    + " : " +message[0];
        var nodeNames = new Array();
        nodeNames[0] = "<nsgui:message key="nas_lvm/common/node0"/>";
        nodeNames[1] = "<nsgui:message key="nas_lvm/common/node1"/>";
        var srcNode = parseInt(LVListForm.node.value);
        msg = msg + "\r\n" + "<nsgui:message key="nas_lvm/lvmMove/SourceNode"/>"
                  + " : " + nodeNames[srcNode];
        msg = msg + "\r\n" + "<nsgui:message key="nas_lvm/lvmMove/DestiNode"/>"
                  + " : " + nodeNames[srcNode==0?1:0];
        LVListForm.lvtype.value = "cluster";
        if(isSubmitted()
	   &&confirm(msg)) {
            setSubmitted();
            LVListForm.action="<%=response.encodeURL("LVMMove.jsp")%>";
            LVListForm.submit();
            lockMenu();
            disableButtonAll();
            return false;
        }
        return false;
    }
}
<%}%>

function check(str) {
    if (str == "")
        return false;
    if(str.charAt(0)=="-")
        return false;
    var avail = /[^A-Za-z0-9_-]/g;
    ifFind = str.search(avail);
    return(ifFind==-1);
}

function onManage(){
    if(document.othersFrm.manage.disabled){
        return false;
    }
    
    if (check(document.othersFrm.lvName.value)==false) {
        alert("<nsgui:message key="common/alert/failed"/>"
                + "\r\n"
                + "<nsgui:message key="nas_lvm/alert/name"/>");
        return false;
    }

    if(document.othersFrm.ldName.value == "--"){
        alert("<nsgui:message key="nas_lvm/alert/no_pv"/>");
        return false;
    }
    var rlength=document.othersFrm.otherRadio.length;
    if(rlength==null) {
        if(document.othersFrm.otherRadio.checked){
        	document.othersFrm.submit();
        	disableButtonAll();
            return false;
        } else {
            return false;
        }
    } else {
        var n=rlength;
        for(var i=0; i<rlength && n==rlength; i++) {
            if(document.othersFrm.otherRadio[i].checked) {
                n=i;
            }
        }
        if(n==rlength) {
            return false;
        }
        document.othersFrm.submit();
        disableButtonAll();
        return false;
    }
}

function enableManage(radioValue){
    var tmpAry = radioValue.split(",");
    document.othersFrm.lvName.value = tmpAry[0];
    document.othersFrm.lunStorage.value = tmpAry[3];
    document.othersFrm.ldName.value = tmpAry[4];
    document.othersFrm.manage.disabled=0;
}
function onReload(){
    window.location="/nsadmin/menu/nas/lvm/LVMList.jsp?cluster=<%=listBean.getType()%>";
    lockMenu();
	disableButtonAll();
}
</script>
<!-- for displaying the waitting page -->
<jsp:include page="../../common/wait.jsp" />
</HEAD>
<BODY onLoad="displayAlert();disableButton()" onUnload="unLockMenu();">
<h1 class="title"><nsgui:message key="nas_lvm/common/h1_lvm"/></h1>
    <form name="ButtonForm" method="post">
        <input type="button" name="reload" value="<nsgui:message key="nas_lvm/common/reload"/>" onClick="onReload()">&nbsp;&nbsp;&nbsp;&nbsp;
        <input type="button" name="Create" value="<nsgui:message key="common/button/resource/create"/>" OnClick="OnCreate('0', '<%=listBean.getType()%>')">
        <input type="hidden" name="alertFlag" value="enable">
    </form>
<h2 class="title"><nsgui:message key="nas_lvm/lvmlist/th_List"/></h2>
<%
    boolean asCluster=listBean.getType();
    Hashtable ht=listBean.getLVInfo();
    Vector keys = listBean.getNodes();
    int nodeNum = keys.size();
    int taglibTableID = 0;
    for(int n=0; n<keys.size(); n++){
%>
    <form name="LVListForm<%=n%>" method="post">
<%
        String node=(String)keys.get(n);
        ArrayList list=(ArrayList)ht.get(n+"");
        if(!node.equals("")) {
%>
        <h3 class="title"><nsgui:message key='<%="nas_lvm/common/node"+ n %>'/></h3>

<%      }

        if(list.isEmpty()){
            String output = NSMessageDriver.getInstance().getMessage(session , "nas_lvm/lvmlist/msg_nolvm");
            out.print(output);
        }else{%>
	      <% 
	        session.setAttribute("LVM_RADIO_ID", "radioButtonID" + n);
	      %>
	      <nssorttab:table  tablemodel="<%=new ListSTModel(list)%>" 
	                      id="<%="lvListNode" + n%>"
	                      table="border=1" 
	                      sortonload="lvName:ascend" >
	                      
	            <nssorttab:column name="radio" 
	                              th="STHeaderRender" 
	                              td="com.nec.sydney.beans.lvm.STDRender4LVM"
	                              sortable="no">
	                
	            </nssorttab:column>
	            <nssorttab:column name="lvName" 
	                              th="STHeaderRender" 
	                              td="com.nec.sydney.beans.lvm.STDRender4LVM"
	                              beforeSort="disableButtonAll();lockMenu()"
	                              sortable="yes">
	               <nsgui:message key="nas_lvm/lvmlist/td_Name"/>
	            </nssorttab:column>
	            
	            <nssorttab:column name="size" 
	                              th="STHeaderRender" 
	                              td="com.nec.sydney.beans.lvm.STDRender4LVM"
	                              comparator="com.nec.nsgui.taglib.nssorttab.NumberStringComparator"
	                              sortable="no">
	                <nsgui:message key="nas_lvm/lvmlist/td_Size"/>
	            </nssorttab:column>
	            
	            
	            <nssorttab:column name="mountPoint" 
	                              th="STHeaderRender" 
	                              td="com.nec.sydney.beans.lvm.STDRender4LVM"
	                              beforeSort="disableButtonAll();lockMenu()"
	                              sortable="yes">
	               <nsgui:message key="nas_lvm/lvmlist/td_Mount"/>
	            </nssorttab:column>
	            
	            
	            <nssorttab:column name="deviceNo" 
	                              th="STHeaderRender" 
	                              td="com.nec.sydney.beans.lvm.STDRender4LVM"
	                              comparator="com.nec.sydney.beans.lvm.DeviceNoComparator"
	                              beforeSort="disableButtonAll();lockMenu()"
	                              sortable="yes">
	                <nsgui:message key="nas_lvm/lvmlist/td_majorAndMinor"/>
	            </nssorttab:column>
	          
	            <%if(!isNasHead.booleanValue()){%>
	                <nssorttab:column name="lunLd" 
	                              th="STHeaderRender" 
	                              td="com.nec.sydney.beans.lvm.STDRender4LVM"
	                              sortable="no">
	                    <nsgui:message key="nas_lvm/lvmlist/th_Disk"/>
	                </nssorttab:column>
	             <%}else{%>
	                <nssorttab:column name="lunStorage" 
	                              th="STHeaderRender" 
	                              td="com.nec.sydney.beans.lvm.STDRender4LVM"
	                              sortable="no">
	                    <nsgui:message key="nas_lvm/lvmlist/td_lun_storage"/>
	                </nssorttab:column>

                    <logic:equal name="hasGfsLicense" value="true" scope="request">
	                <nssorttab:column name="striping" 
                                  th="STHeaderRender" 
                                  td="com.nec.sydney.beans.lvm.STDRender4LVM"
                                  sortable="no">
                        <nsgui:message key="nas_lvm/lvmlist/td_striping"/>
                    </nssorttab:column>
	                </logic:equal>
	             <%}%>
        </nssorttab:table>
      
    <%  
       session.removeAttribute("LVM_RADIO_ID");
    }//end of else[if list.Empty()]
    %>
    <hr>
    <input type="button" name="Extend" value="<nsgui:message key="nas_lvm/common/submit_Extend"/>" disabled OnClick="if(this.disabled) return false ;else {return OnExtend(LVListForm<%=n%>, '<%=asCluster%>')}" >
    <%if(asCluster && !listBean.is1Node()){%>
        &nbsp;&nbsp;
        <input type="button" name="Move" value="<nsgui:message key="nas_lvm/lvmMove/Move"/>" disabled OnClick="if(this.disabled) return false; else {return OnMove(document.LVListForm<%=n%>)}" >
    <%}%>
    &nbsp;&nbsp;&nbsp;&nbsp;
    <input type="button" name="Remove" value="<nsgui:message key="common/button/resource/destroy"/>" disabled OnClick="if(this.disabled) return false ;else {return OnRemove(LVListForm<%=n%>, '<%=node%>', '<%=asCluster%>')}" >
    &nbsp;&nbsp;&nbsp;
    
    <input type="hidden" name="lvNum" value="<%=list.size()%>">
    <%if(asCluster){%>
        <input type="hidden" name="node" value="<%=n%>">
    <%} else {%>
        <input type="hidden" name="node" value="0">
    <%}%>
    <input type="hidden" name="lvtype" >
    <input type="hidden" name="alertFlag" value="enable">
</form>
<%}//end of for (node circle)%>

<%
    ArrayList otherLVs = (ArrayList)listBean.getOthersLVInfo();
    if(!otherLVs.isEmpty()){
%>
    <h2 class="title"><nsgui:message key="nas_lvm/lvmlist/other_list"/></h2>
    <form name="othersFrm" method="post" action="LVMManageShow.jsp" onSubmit="return false;">
    <% 
        session.setAttribute("LVM_RADIO_ID", "otherRadioID");
    %>
          <nssorttab:table  tablemodel="<%=new ListSTModel(otherLVs)%>" 
                          id="otherLvList"
                          table="border=1" 
                          sortonload="lvName:ascend" >
                          
                <nssorttab:column name="radio" 
                                  th="STHeaderRender" 
                                  td="com.nec.sydney.beans.lvm.STDRender4LVM"
                                  sortable="no">
                    
                </nssorttab:column>
                <nssorttab:column name="lvName" 
                                  th="STHeaderRender" 
                                  td="com.nec.sydney.beans.lvm.STDRender4LVM"
                                  beforeSort="disableButtonAll();lockMenu()"
                                  sortable="yes">
                   <nsgui:message key="nas_lvm/lvmlist/td_Name"/>
                </nssorttab:column>
                
                <nssorttab:column name="size" 
                                  th="STHeaderRender" 
                                  td="com.nec.sydney.beans.lvm.STDRender4LVM"
                                  comparator="com.nec.nsgui.taglib.nssorttab.NumberStringComparator"
                                  sortable="no">
                    <nsgui:message key="nas_lvm/lvmlist/td_Size"/>
                </nssorttab:column>
                
                <nssorttab:column name="deviceNo" 
                                  th="STHeaderRender" 
                                  td="com.nec.sydney.beans.lvm.STDRender4LVM"
                                  comparator="com.nec.sydney.beans.lvm.DeviceNoComparator"
                                  beforeSort="disableButtonAll();lockMenu()"
                                  sortable="yes">
                    <nsgui:message key="nas_lvm/lvmlist/td_majorAndMinor"/>
                </nssorttab:column>
              
                <%if(!isNasHead.booleanValue()){%>
                    <nssorttab:column name="lunLd" 
                                  th="STHeaderRender" 
                                  td="com.nec.sydney.beans.lvm.STDRender4LVM"
                                  sortable="no">
                        <nsgui:message key="nas_lvm/lvmlist/th_Disk"/>
                    </nssorttab:column>
                <%}else{%>
                    <nssorttab:column name="lunStorage" 
                                  th="STHeaderRender" 
                                  td="com.nec.sydney.beans.lvm.STDRender4LVM"
                                  sortable="no">
                        <nsgui:message key="nas_lvm/lvmlist/td_lun_storage"/>
                    </nssorttab:column>

                    <logic:equal name="hasGfsLicense" value="true" scope="request">
                    <nssorttab:column name="striping" 
                                  th="STHeaderRender" 
                                  td="com.nec.sydney.beans.lvm.STDRender4LVM"
                                  sortable="no">
                        <nsgui:message key="nas_lvm/lvmlist/td_striping"/>
                    </nssorttab:column>
                    </logic:equal>
                 <%}%>
        </nssorttab:table>
		<hr>
		<input type="hidden" name="iscluster" value="<%=asCluster%>">
		<input type="hidden" name="ldName" value="">
		<input type="hidden" name="lvName" value="">
		<input type="hidden" name="lunStorage" value="">
		<input type="button" name="manage" value="<nsgui:message key="nas_lvm/lvmlist/btn_manage"/>" disabled OnClick="if(this.disabled) return false ;else {return onManage()}">
		<input type="hidden" name="lvNum" value="<%=otherLVs.size()%>">

<%  
        session.removeAttribute("LVM_RADIO_ID");
     }//end of else[if v.Empty()]
%>
   </form>
</BODY>
</HTML>
