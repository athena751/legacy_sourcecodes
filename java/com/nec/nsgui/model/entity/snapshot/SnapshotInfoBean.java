/*
 *      Copyright (c) 2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.snapshot;

public class SnapshotInfoBean {
    private static final String cvsid =
            "@(#) $Id: SnapshotInfoBean.java,v 1.1 2008/05/28 02:14:12 lil Exp $";
    
    private String name = "";
    private String createTime = "";
    private String status = "";
    private boolean checked = false;

    /**
     * @return Returns the createTime.
     */
    public String getCreateTime() {
        return createTime;
    }
    /**
     * @param createTime The createTime to set.
     */
    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }
    /**
     * @return Returns the name.
     */
    public String getName() {
        return name;
    }
    /**
     * @param name The name to set.
     */
    public void setName(String name) {
        this.name = name;
    }
    /**
     * @return Returns the status.
     */
    public String getStatus() {
        return status;
    }
    /**
     * @param status The status to set.
     */
    public void setStatus(String status) {
        this.status = status;
    }
    /**
     * @return Returns the checked.
     */
    public boolean isChecked() {
        return checked;
    }
    /**
     * @param checked The checked to set.
     */
    public void setChecked(boolean checked) {
        this.checked = checked;
    }

}