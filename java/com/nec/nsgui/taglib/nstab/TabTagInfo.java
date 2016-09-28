/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *      $Id: TabTagInfo.java,v 1.1 2005/05/17 00:55:36 wangw Exp $
 *
 */

package com.nec.nsgui.taglib.nstab;
import java.util.Vector;

/**
 * class to store the information of entire nstab taglib 
 */

public class TabTagInfo {
	private Vector subTabInfos = null;
	
	public TabTagInfo(){
	}

	public int getSubTabCount(){
		if ( subTabInfos == null)	return 0;
		return subTabInfos.size();
	}

	public void addSubTabTagInfo(SubTabTagInfo subInfo){
		if (subInfo == null)  return;
		if(subTabInfos == null )  subTabInfos = new Vector();
        subTabInfos.add( subInfo );
	}
    
	public SubTabTagInfo getSubTabTagInfo(int idx){
		if(subTabInfos == null) return null;
		if(idx < 0) return null;
		if(idx >= subTabInfos.size()) return null;

		return (SubTabTagInfo)subTabInfos.get(idx);
	}
}