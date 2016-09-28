/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
 
package com.nec.nsgui.model.entity.statis;

public class VirtualPathInfoBean extends NswSamplingInfoBeanBase{
    private static final String cvsid =
            "@(#) $Id: VirtualPathInfoBean.java,v 1.1 2005/10/18 16:40:52 het Exp $";
    private String severName;
    private String exportPath;
    /**
     * @return
     */
    public String getExportPath() {
        return exportPath;
    }

    /**
     * @return
     */
    public String getSeverName() {
        return severName;
    }

    /**
     * @param string
     */
    public void setExportPath(String string) {
        exportPath = string;
    }

    /**
     * @param string
     */
    public void setSeverName(String string) {
        severName = string;
    }

}