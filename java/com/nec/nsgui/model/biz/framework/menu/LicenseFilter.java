/*
 *      Copyright (c) 2004-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.model.biz.framework.menu;

import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.framework.ControllerModel;
import com.nec.nsgui.model.biz.license.LicenseInfo;
import com.nec.nsgui.model.entity.framework.FrameworkConst;
import com.nec.nsgui.model.entity.framework.menu.MenuBaseBean;
import com.nec.nsgui.model.entity.framework.menu.ItemBean;

/**
 * 
 */
public class LicenseFilter implements Filter, FrameworkConst {

    private static final String cvsid =
        "@(#) $Id: LicenseFilter.java,v 1.5 2005/11/04 02:28:28 zhangj Exp $";
    private boolean isCluster = true;
    private boolean node0IsDown = false;
    private boolean node1IsDown = false;
    
    /**
     * 
     */
    public LicenseFilter() throws Exception {
        String machineType = ControllerModel.getInstance().getMachineType();
        if (machineType != null
            && (machineType.equals(MACHINE_TYPE_SINGLE)
                || machineType.equals(MACHINE_TYPE_NASHEADSINGLE))) {
            isCluster = false;
        }
        try {
            LicenseInfo.getInstance().setLicenseInfo(0);
        } catch (NSException e) {
            node0IsDown = true;
        }
        try {
            if (isCluster) {
                LicenseInfo.getInstance().setLicenseInfo(1);
            }
        } catch (NSException e) {
            node1IsDown = true;
        }
    }

    public MenuBaseBean filter(MenuBaseBean nsmenu) throws Exception {
        if (nsmenu == null || !(nsmenu instanceof ItemBean)) {
            return nsmenu;
        }
        ItemBean item = (ItemBean) nsmenu;
        String key = item.getLicenseKey();
        if (key == null || key.equals("")) {
            item.setHasLicense("true");
            return item;
        }
        int flag = 0;
        try {
            if(!node0IsDown){
                flag = LicenseInfo.getInstance().checkAvailable(0, key, false);
            }
        } catch (NSException e) {
        }
        try {
            if (flag == 0 && isCluster && !node1IsDown) {
                flag = LicenseInfo.getInstance().checkAvailable(1, key, false);
            }
        } catch (NSException e) {
        }

        String hasLicense = (flag == 0) ? "false" : "true";
        
        if( (item.getMsgKey().equals("apply.volumn.gfs"))&&(hasLicense.equals("false")) ){
            return null;
        }
        
        item.setHasLicense(hasLicense);
        return item;
    }

}
