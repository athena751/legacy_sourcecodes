/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.filesystem;

import java.util.Vector;

import com.nec.sydney.atom.admin.base.NSUtil;
import com.nec.sydney.beans.base.APISOAPClient;
import com.nec.sydney.beans.base.TemplateBean;

public class MountPointSelectBean extends TemplateBean{
    private static final String     cvsid = "@(#) $Id: MountPointSelectBean.java,v 1.2301 2007/04/26 06:24:33 fengmh Exp $";
    //member variable
    private Vector dirList;
    private String hexpath;
    private String codepage;
    private String level;
    private String mpoint;
    private String fsType;
    private int dirType;
   

    //constructor
    public MountPointSelectBean() {
    }

    //set/get function
    public Vector getDirList() {
        return this.dirList;
    }
    
    public String getHexpath() throws Exception{
        if (this.hexpath == null) {
//modify by maojb on 2003.9.3 for cifs mapd use
            String from = request.getParameter("from");
            if (from == null) {
                if (this.codepage != null) {
                    this.hexpath = NSUtil.str2hStr("/export",this.codepage);
                }
            } else {
                this.hexpath = "/etc";
            }
        }
        return this.hexpath;
    }
    public void setHexpath(String hexpath) {
        this.hexpath = hexpath;
    }

    public String getCodepage() {
        return this.codepage;
    }
    public void setCodepage(String codepage) {
        this.codepage = codepage;
    }
    
    public String getLevel() {
        return this.level;
    }
    public void setLevel(String level) {
        this.level = level;
    }

    public String getMpoint() {
        return this.mpoint;
    }
    public void setMpoint(String mpoint) {
        this.mpoint = mpoint;
    }

    public String getFsType() {
        return this.fsType;
    }
    public void setFsType(String fsType) {
        this.fsType = fsType;
    }

    public int getDirType() {
        return this.dirType;
    }

    public void onDisplay() throws Exception {
        String frameNo = request.getParameter("frameNo");
        if (frameNo.equals("1")) {
//modify by maojb on 2003.9.3 for cifs mapd use
            String from = request.getParameter("from");
            String type = request.getParameter("type");
            if (from == null) {
                
            } else {
                hexpath = getHexpath();
                dirList = APISOAPClient.getDirList(hexpath,type,target);
            }
        }
    }
}//end class