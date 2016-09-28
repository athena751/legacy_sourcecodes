<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: sitemap.jsp,v 1.17 2007/08/29 07:03:30 liul Exp $" -->

<%@ page import="java.util.*
        ,com.nec.nsgui.model.entity.framework.menu.*
        ,com.nec.nsgui.action.base.*" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ page contentType="text/html;charset=UTF-8"%>

<%

NSMenusBean nsMenus = (NSMenusBean)request.getAttribute("menu");
Map allCategories = nsMenus.getCategoryMap();
//store the be displayed sub category's position in a column
int[] subCateBreak = new int[allCategories.size()];
/*
Iterator allCateKeys = allCategories.keySet().iterator();
for(int subCateIndex=0; allCateKeys.hasNext(); subCateIndex++){
    CategoryBean categorie = (CategoryBean)allCategories.get(allCateKeys.next());
    Iterator cateKeys = categorie.getSubCategoryMap().keySet().iterator();
    double[] subCateHeight = new double[categorie.getSubCategoryMap().size()];
    double cateHeight = 0;
    //get the sub category's all item count
    for (int i=0; cateKeys.hasNext(); i++){
        SubCategoryBean subCate = (SubCategoryBean)categorie.getSubCategoryMap().get(cateKeys.next());
        //1.25:means the subCategory's title
        subCateHeight[i]=subCate.getItemMap().size()+1.25;
        cateHeight += subCateHeight[i];
    }
    //category height contain the space line.
    cateHeight += subCateHeight.length -2;
    int colRight = subCateHeight.length-1;
    double preResult = cateHeight;
    double curResult = 0;
    //split the subcategory in left and right columns.
    //in left column, from 1st subcategory to last, 
    //do the loop:
    //count the left column height, and count the rest
    //rigth column heigth, get minimum difference between
    //the two height.
    double leftHeight = 0;
    double rightHeight = 0;
    for(int colLeft=0; colLeft<subCateHeight.length; colLeft++){
        //count the left column heith
        leftHeight += subCateHeight[colLeft];
        //add the space line height.
        leftHeight += colLeft;
        //count the right coloumn height
        rightHeight = cateHeight - leftHeight;
        curResult = Math.abs(leftHeight - rightHeight);
        //judge the the difference is minimum or not
        if(curResult < preResult){
           preResult = curResult;
           colRight--;
           continue; 
        }
        //finded the minimum difference 
        subCateBreak[subCateIndex] = colLeft;
        break;
    }
}*/
//define the layout according to a certain style.
String machineType = NSActionUtil.getMachineType(request);
String machineSeries = (String)request.getSession().getAttribute("machineSeries");
String curLang = NSActionUtil.getCurrentLang(request);
if(machineType.equals(NSActionConst.MACHINE_TYPE_NASCLUSTER)){
    if(curLang.equals(NSActionConst.LANGUAGE_ENGLISH)){
        subCateBreak[0] = 2;
        subCateBreak[1] = 4;
        if(machineSeries.equals("Procyon")){
        	subCateBreak[2] = 5;
        }else{
            subCateBreak[2] = 4;
        }
    }else{
        subCateBreak[0] = 2;
        subCateBreak[1] = 4;
        if(machineSeries.equals("Procyon")){
        	subCateBreak[2] = 5;
        }else{
            subCateBreak[2] = 4;
        }
    }
}else if(machineType.equals(NSActionConst.MACHINE_TYPE_SINGLE)){
    if(curLang.equals(NSActionConst.LANGUAGE_ENGLISH)){
        subCateBreak[0] = 2;
        subCateBreak[1] = 4;
        subCateBreak[2] = 4;    
    }else{
        subCateBreak[0] = 2;
        subCateBreak[1] = 4;
        subCateBreak[2] = 4;    
    }
}else if(machineType.equals(NSActionConst.MACHINE_TYPE_ONENODESIRIUS)){
    if(curLang.equals(NSActionConst.LANGUAGE_ENGLISH)){
        subCateBreak[0] = 2;
        subCateBreak[1] = 4;
        if(machineSeries.equals("Procyon")){
        	subCateBreak[2] = 5;
        }else{
            subCateBreak[2] = 4;
        }   
    }else{
        subCateBreak[0] = 2;
        subCateBreak[1] = 4;
        if(machineSeries.equals("Procyon")){
        	subCateBreak[2] = 5;
        }else{
            subCateBreak[2] = 4;
        }    
    }
}else{
//Nashead (include NasheadSingle and NasheadCluster)
     if(curLang.equals(NSActionConst.LANGUAGE_ENGLISH)){
        subCateBreak[0] = 2;
        subCateBreak[1] = 4;
        if(machineSeries.equals("Procyon") && machineType.equals("NasheadCluster")){
        	subCateBreak[2] = 4;
        }else{
            subCateBreak[2] = 3;
        }     
    }else{
        subCateBreak[0] = 2;
        subCateBreak[1] = 4;
        if(machineSeries.equals("Procyon") && machineType.equals("NasheadCluster")){
        	subCateBreak[2] = 4;
        }else{
            subCateBreak[2] = 3;
        }    
    }   
}
%>
<html>
<head>

<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
<META HTTP-EQUIV="expires" CONTENT="0">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<script language="JavaScript" src="../common/common.js"></script>
<link rel="stylesheet" href="../skin/default/menu.css" type="text/css">
</head>
<body>
<bean:define id="allCate" name="menu" property="categoryMap" scope="request" />
<logic:iterate id="cate" name="allCate" indexId="indexId" >
    <table border=0 width=100% class="SiteMapCategoryTitle<%=indexId%>">
        <tr><td nowrap>
        <font class="SiteMapCategoryTitle<%=indexId%>">
        &nbsp;
        <bean:define id="cateObj" name="cate" property="value" />
        <bean:message name="cateObj" property="detailMsgKey" bundle="menuResource/framework" />
        </font>
        </td></tr>
    </table>
    <br>
    <table border=0 width=100%>
        <tr valign=top>
    <logic:iterate id="subCate" name="cateObj" property="subCategoryMap" indexId="subcateId" >
        <logic:equal name="subcateId" value="0">
            <td width="50%">
        </logic:equal>
        <logic:equal name="subcateId" value="<%=Integer.toString(subCateBreak[indexId.intValue()])%>">
            </td>
            <td width="50%">
        </logic:equal>
        <table cellSpacing=0 cellPadding=0 border=0 >
            <tr>
            <td width=2 class="SiteMapBgColor<%=indexId%>"></td>
            <td class="SiteMapSubCategory<%=indexId%>" nowrap
                width=220 height=20>
                <font class="SiteMapSubCategory<%=indexId%>">&nbsp;
                <bean:define id="subCateObj" name="subCate" property="value" />
                <bean:message name="subCateObj" property="msgKey" bundle="menuResource/framework" />
                </font>
            </td>
            <td width=12 height=20 class="SiteMapSubCategory<%=indexId%>">
                <img src="../images/nation/tail.gif">
            </td>
	    <td width=130 height=20 bgcolor="#FFFFFF" ></td>
	    <td width=2 bgcolor="#FFFFFF"></td>
	    </tr>
	    <tr><td width=300 height=2 colspan=5 class="SiteMapBgColor<%=indexId%>"></td></tr>
	    <logic:iterate id="item" name="subCateObj" property="itemMap">
        <bean:define id="itemObj" name="item" property="value" />
	    <tr>
	    <td width=2 class="SiteMapBgColor<%=indexId%>"></td>
	    
	    <logic:equal name="itemObj" property="hasLicense" value="false">
            <td class="NoLicense" nowrap width=300 colspan=3>
            <table border=0 cellSpacing=3 cellPadding=0><tr><td valign=top></td><td>
            <table border="0" cellspacing="0" cellpadding="1" width=330><tr><td width="10">
                <div width="10" height="10"><img src="../images/menu/bk_<%=indexId%>.jpg" width="10" height="10"/></div>
            </td><td>
            <font class="ItemNolicense">
            <bean:message name="itemObj" property="detailMsgKey" bundle="menuResource/framework" />
            </font>
            </td></tr></table>
            </td></tr></table>
            </td>
            </logic:equal>
            
            <logic:equal name="itemObj" property="hasLicense" value="true">
	    <td width=300 colspan=3 class="OnMoveOut" nowrap 
	       onmouseover="this.className='OnMoveOver<%=indexId%>';" 
           onmouseout="this.className='OnMoveOut';"
	       onclick="selectModule('<bean:write name="itemObj" property="msgKey"/>');
                    return false;">
        <table border=0 cellSpacing=3 cellPadding=0><tr><td valign=top>
	    </td><td>
        <table border="0" cellspacing="0" cellpadding="1" width=330><tr><td width="10">
            <div width="10" height="10"><img src="../images/menu/bk_<%=indexId%>.jpg" width="10" height="10"/></div>
        </td><td>     
	    <a href="#" 
	       onclick="if (!isIE()){selectModule('<bean:write name="itemObj" property="msgKey"/>');
	                return false;}">
	    <font class="Item<%=indexId%>"><u>
	    <bean:message name="itemObj" property="detailMsgKey" bundle="menuResource/framework" />
	    </u></font>
	    </a>
	    </td></tr></table>
	    </td></tr></table>
	    </td>
	    </logic:equal>
	    
	    <td width=2 height=2 class="SiteMapBgColor<%=indexId%>"></td>
        </tr>
        </logic:iterate>
        <tr><td width=300 height=2 colspan=5 class="SiteMapBgColor<%=indexId%>"></td></tr>
     </table>
     <br>
     </logic:iterate>
        </td></tr></table>
</logic:iterate>
</body>
</html>