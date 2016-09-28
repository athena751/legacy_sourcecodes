/*
 *      Copyright (c) 2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.model.biz.framework.menu;

import com.nec.nsgui.model.biz.base.RpqLicense;
import com.nec.nsgui.model.biz.framework.ControllerModel;
import com.nec.nsgui.model.entity.framework.FrameworkConst;
import com.nec.nsgui.model.entity.framework.menu.MenuBaseBean;
import com.nec.nsgui.model.entity.framework.menu.ItemBean;

/**
 * 
 */
public class RPQFilter implements Filter, FrameworkConst {
    private static final String cvsid =
        "@(#) $Id: RPQFilter.java,v 1.2 2006/05/16 05:35:52 pangqr Exp $";
    private boolean isCluster = true;

    /**
     * 
     */
    public RPQFilter() throws Exception {
        String machineType = ControllerModel.getInstance().getMachineType();
        if (machineType != null
            && (machineType.equals(MACHINE_TYPE_SINGLE)
                || machineType.equals(MACHINE_TYPE_NASHEADSINGLE))) {
            isCluster = false;
        }
    }

    public MenuBaseBean filter(MenuBaseBean nsmenu) throws Exception {
        if (nsmenu == null || !(nsmenu instanceof ItemBean)) {
            return nsmenu;
        }
        ItemBean item = (ItemBean) nsmenu;
        String key = item.getRpqKey();
        if (key == null || key.equals("")) {
            return item;
        }
        boolean needDisplay = true;
        if (key.startsWith(RPQ_NOT_PREFIX)) {
            needDisplay = false;
            key = key.substring(1);
        }
        String[] keyArray = key.split(MACHINE_TYPE_SEPARATOR);        
        int flag = 1;
        for (int i = 0; i < keyArray.length; i++) {           
            try{
                flag = RpqLicense.getLicense(keyArray[i], 0);
            }catch(Exception e){
            }
            
            try{
                if(flag == 1 && isCluster){
                    flag = RpqLicense.getLicense(keyArray[i], 1);
                }
            }catch(Exception e){
            }
            if(flag == 0) break;               
        }
        if(flag == 0){
            return needDisplay ? item : null;
        }else{
            return needDisplay ? null : item;
        }
    }

}
