/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
 
package com.nec.nsgui.model.entity.statis;

public class NodeInfoBean extends NswSamplingInfoBeanBase{
    private static final String cvsid ="@(#) $Id: NodeInfoBean.java,v 1.1 2005/10/18 16:40:52 het Exp $";
    String nickName;
    /**
     * @return
     */
    public String getNickName() {
        return nickName;
    }

    /**
     * @param string
     */
    public void setNickName(String string) {
        nickName = string;
    }

}