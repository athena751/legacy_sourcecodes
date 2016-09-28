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
 * The interface of nsmenus filters.
 */
public interface Filter {
    public static final String cvsid = "@(#) $Id: Filter.java,v 1.2 2004/07/14 04:53:54 het Exp $";
    /**
     * remove and modify the menu items in nsmenu
     * @param nsmenu - menu items which can be filtered
     * @return nsmenus after filtered
     * @throws Exception 
     */
    public MenuBaseBean filter(MenuBaseBean nsmenu) throws Exception;
}
