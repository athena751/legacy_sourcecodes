/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *      $Id: DisplaySubTab.java,v 1.4 2007/04/26 06:02:17 liul Exp $
 *
 */

package com.nec.nsgui.taglib.nstab;

import java.io.BufferedReader;
import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyContent;
import javax.servlet.jsp.tagext.BodyTagSupport;
import javax.servlet.jsp.tagext.Tag;

import org.apache.struts.taglib.TagUtils;
import org.apache.struts.util.ModuleUtils;
/**
 * class to dislplay each tab's html code 
 * 
 */
public class DisplaySubTab extends BodyTagSupport{


    private String url = null;
    private String tabMessage = "";
    private String enableExportGroup = null;
    private String enableNode = null;
    
    private void init(){
        url = null;
        tabMessage= "";
        enableExportGroup = null;
        enableNode = null;
    }
    
    public DisplaySubTab(){
    	init();
    }

    /**
     * @return
     */
    public String getTabMessage() {
        return tabMessage;
    }

    /**
     * @return
     */
    public String getUrl() {
        return url;
    }

    /**
     * @param string
     */
    public void setTabMessage(String tabMessage) {
        this.tabMessage = tabMessage;
    }

    /**
     * @param string
     */
    public void setUrl(String url) {
        this.url = url;
    }


    public String getEnableExportGroup(){
    	return this.enableExportGroup;
    }
    
    public void setEnableExportGroup(String enableExportGroup){
    	this.enableExportGroup = enableExportGroup;
    }
    
    public String getEnableNode(){
    	return this.enableNode;
    }
    
    public void setEnableNode(String enableNode){
    	this.enableNode = enableNode;
    }

    public int doAfterBody()throws JspException {
	BodyContent		bc = getBodyContent();
	BufferedReader	br = new BufferedReader(bc.getReader());
	String			line = null;
	/****************************************
	 * Collect the message for th displaying
	 * and get rid of the blank lines.
	 */
        tabMessage = "";
	try{
		line = br.readLine();
		while(line != null){
            tabMessage = tabMessage + line.trim();
			line = br.readLine();
		}
	}catch(IOException ex){

	}
	return EVAL_PAGE;
    }

    public int doEndTag() throws JspException{

        HttpServletRequest httpRequest = (HttpServletRequest)pageContext.getRequest();
        String absoluteUrl;
        if(url.startsWith("/")) {
            absoluteUrl = url;
        } else {
           
           absoluteUrl = httpRequest.getContextPath() + TagUtils.getInstance().pageURL(httpRequest, "/" + url, ModuleUtils.getInstance().getModuleConfig(httpRequest));
           
        }

        Tag parent = findAncestorWithClass(this, DisplayTab.class);

        if (parent == null){
        	throw new JspException("[nstab:subtab]  nstab:tab is required!");
        }
        /*********************************************
         *check the attributes of this subtab 
         */
        CheckAttributes();
        /*********************************************
         * prepare for adding subtabinfo to parent tag
         */
        SubTabTagInfo tabinfo = new SubTabTagInfo();
        tabinfo.setUrlString(absoluteUrl);
        tabinfo.setTabMessage(tabMessage);
        tabinfo.setEnableExportGroup(enableExportGroup);
        tabinfo.setEnableNode(enableNode);
		/*********************************************
		 * add this subtabifo to parent
		 */
        DisplayTab tab = (DisplayTab) parent;
        tab.addSubTabTagInfos(tabinfo);

		init();
		return EVAL_PAGE;
    }

	/**************************************************
	*
	*check the following attributes' value
	*     name
	*     sortable : yes|no
	*     th
	*     td
	*/

	private void CheckAttributes() throws JspException {
		if(url == null){
			throw new JspException("[nstab:subtab] Invalid Parameter: url.");
		}
        if((tabMessage==null) || ("".equals(tabMessage.trim()))){
            throw new JspException("[nstab:subtab] Invalid Parameter: tabmessage.");
        }
	}
}