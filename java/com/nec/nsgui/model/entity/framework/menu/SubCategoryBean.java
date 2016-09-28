/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.framework.menu;

import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;

import com.nec.nsgui.model.entity.framework.FrameworkConst;

/**
 *
 */
public class SubCategoryBean extends MenuBaseBean implements FrameworkConst {
    public static final String cvsid =
        "@(#) $Id: SubCategoryBean.java,v 1.2 2004/07/14 14:06:32 het Exp $";

    private Map itemMap = new LinkedHashMap();

    public SubCategoryBean() {

    }

    public SubCategoryBean(
        String msgKey,
        String detailMsgKey,
        String level,
        String machineType,
        Map itemMap) {
        super(msgKey, detailMsgKey, level, machineType);
        this.itemMap.putAll(itemMap);
    }
    /**
     * 
     * @param item
     */
    public void addItemMap(ItemBean item) {
        itemMap.put(
            item.getMsgKey() + MENU_KEY_SEPARATOR + item.getMachineType(),
            item);
    }
    /**
     * @return
     */
    public Map getItemMap() {
        return itemMap;
    }

    /**
     * @param map
     */
    public void setItemMap(Map map) {
        itemMap = map;
    }
    /**
     * 
     */
    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }
        if (!super.equals(obj)) {
            return false;
        }
        SubCategoryBean subCategory = (SubCategoryBean) obj;
        if (!(subCategory.itemMap.equals(itemMap))) {
            return false;
        }
        return true;
    }
    /**
     * 
     * @param subCategory
     */
    public void merge(SubCategoryBean subCategory) {
        itemMap.putAll(subCategory.itemMap);
    }
    
    public SubCategoryBean getMyClone() {
        Map m = new LinkedHashMap();
        Iterator it = itemMap.keySet().iterator();
        while(it.hasNext()){
            String key = (String)it.next();
            ItemBean item = (ItemBean)itemMap.get(key);
            m.put(key,item.getMyClone());
        }
        return new SubCategoryBean(
            super.getMsgKey(),
            super.getDetailMsgKey(),
            super.getLevel(),
            super.getMachineType(),
            m);
    }
}
