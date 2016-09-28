/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.biz.framework.menu;

import com.nec.nsgui.model.entity.framework.menu.MenuBaseBean;

/**
 *
 */
public class MachineTypeInitFilter implements Filter {
    private static final String cvsid = "@(#) $Id: MachineTypeInitFilter.java,v 1.1 2004/07/14 01:23:19 het Exp $";
    private String defaultMachineType = "";
    public MachineTypeInitFilter(String defaultMachineType) {
        this.defaultMachineType = defaultMachineType;
    }
    /* (non-Javadoc)
     * @see com.nec.nsgui.model.biz.framework.menu.Filter#filter(com.nec.nsgui.model.entity.framework.menu.MenuBaseBean)
     */
    public MenuBaseBean filter(MenuBaseBean nsmenu) throws Exception {
        if (nsmenu.getMachineType().equals("")) {
            nsmenu.setMachineType(defaultMachineType);
        }
        return nsmenu;
    }

}
