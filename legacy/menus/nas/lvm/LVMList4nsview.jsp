<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: LVMList4nsview.jsp,v 1.6 2007/08/23 06:53:11 xingyh Exp $" -->

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

<script language="JavaScript" src="/nsadmin/nas/volume/volumecommon.js"></script>
<script language="JavaScript" src="../common/general.js"></script>
<script language="JavaScript">
function onReload(){
    window.location="/nsadmin/menu/nas/lvm/LVMList4nsview.jsp?cluster=<%=listBean.getType()%>";
    lockMenu();
    disableButtonAll();
}
</script>
<!-- for displaying the waitting page -->
<jsp:include page="../../common/wait.jsp" />
</HEAD>
<BODY onLoad="displayAlert()" onUnload="unLockMenu();">
<h1 class="title"><nsgui:message key="nas_lvm/common/h1_lvm"/></h1>
    <form name="ButtonForm" method="post">
        <input type="button" name="reload" value="<nsgui:message key="nas_lvm/common/reload"/>" onClick="onReload()">&nbsp;&nbsp;&nbsp;&nbsp;
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
    </form>
<%}//end of for (node circle)%>

<%
    ArrayList otherLVs = (ArrayList)listBean.getOthersLVInfo();
    if(!otherLVs.isEmpty()){
%>
    <h2 class="title"><nsgui:message key="nas_lvm/lvmlist/other_list"/></h2>
    <form name="othersFrm" method="post">
    <% 
        session.setAttribute("LVM_RADIO_ID", "otherRadioID");
    %>
          <nssorttab:table  tablemodel="<%=new ListSTModel(otherLVs)%>" 
                          id="otherLvList"
                          table="border=1" 
                          sortonload="lvName:ascend" >

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
<%  
        session.removeAttribute("LVM_RADIO_ID");
     }//end of else[if v.Empty()]
%>
   </form>
</BODY>
</HTML>
