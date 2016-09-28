/*
 *      Copyright (c) 2004-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.biz.framework.menu;

import java.io.InputStream;
import java.lang.reflect.InvocationTargetException;


import com.nec.nsgui.model.entity.framework.menu.CategoryBean;
import com.nec.nsgui.model.entity.framework.menu.ItemBean;
import com.nec.nsgui.model.entity.framework.menu.NSMenusBean;
import com.nec.nsgui.model.entity.framework.menu.SubCategoryBean;
import com.nec.nsgui.model.entity.framework.FrameworkConst;
import org.apache.commons.digester.Digester;

/**
 *
 */
public class NSMenuFactory implements FrameworkConst {
    private static final String cvsid =
        "@(#) $Id: NSMenuFactory.java,v 1.7 2007/08/29 02:06:05 liul Exp $";
    private static NSMenusBean nsMenus = new NSMenusBean();
    /**
     * create a nsmenu instance
     * @return
     * @throws Exception
     */
    public static NSMenusBean createNSMenusInstance(String user) throws Exception {
        FilterList filterList = new FilterList();

        filterList.addFilter(new MachineTypeFilter());
        filterList.addFilter(new VersionFilter());
        //filterList.addFilter(new UserLevelFilter());
        filterList.addFilter(new LicenseFilter());
        filterList.addFilter(new UserFilter(user));
        filterList.addFilter(new RPQFilter());
        filterList.addFilter(new MachineSeriesFilter());
        return createNSMenusInstance(filterList);
    }
    public static NSMenusBean createNSMenusInstance(FilterList filterList)
        throws
            IllegalAccessException,
            InstantiationException,
            InvocationTargetException,
            NoSuchMethodException,
            Exception {
        return filterList.filter(nsMenus.getMyClone());
    }
    /**
     * 
     * @param defaultMachineType
     * @param inputs
     * @throws Exception
     */
    public static void init(String defaultMachineType, InputStream[] inputs)
        throws Exception {
        for (int i = 0; i < inputs.length; i++) {
            nsMenus.merge(parse(inputs[i]));
        }
        FilterList filterList = new FilterList();
        filterList.addFilter(new MachineTypeInitFilter(defaultMachineType));
        nsMenus = filterList.filter(nsMenus);
    }
    /**
     * parse the inputStream and create NSMenusBean object.
     * @param inputStream
     * @return
     * @throws Exception
     */
    private static NSMenusBean parse(InputStream inputStream)
        throws Exception {
        Digester digester = new Digester();
        digester.setValidating(false);
        digester.setUseContextClassLoader(true);
        //parse root and create nsmenus object.
        digester.addObjectCreate(CONFIG_FILE_TAG_NSMENUS, NSMenusBean.class);

        //parse Category and create a CategoryBean object.
        String categoryStr =
            CONFIG_FILE_TAG_NSMENUS
                + CONFIG_FILE_TAG_SEPARATER
                + CONFIG_FILE_TAG_CATEGORY;
        digester.addObjectCreate(categoryStr, CategoryBean.class);
        digester.addSetProperties(categoryStr);
        digester.addSetNext(categoryStr, "addCategoryMap");

        //parse SubCategory and create SubCategoryBean object.
        String subCategoryStr =
            categoryStr
                + CONFIG_FILE_TAG_SEPARATER
                + CONFIG_FILE_TAG_SUBCATEGORY;
        digester.addObjectCreate(subCategoryStr, SubCategoryBean.class);
        digester.addSetProperties(subCategoryStr);
        digester.addSetNext(subCategoryStr, "addSubCategoryMap");

        //parse Item and create ItemBean object.
        String itemStr =
            subCategoryStr + CONFIG_FILE_TAG_SEPARATER + CONFIG_FILE_TAG_ITEM;
        digester.addObjectCreate(itemStr, ItemBean.class);
        digester.addSetProperties(itemStr);
        String hiddenStr =
            itemStr + CONFIG_FILE_TAG_SEPARATER + CONFIG_FILE_TAG_HIDDEN;
        digester.addCallMethod(hiddenStr, "addHiddenMap", 2);
        digester.addCallParam(hiddenStr, 0, "name");
        digester.addCallParam(hiddenStr, 1, "value");
        digester.addSetNext(itemStr, "addItemMap");

        return (NSMenusBean) digester.parse(inputStream);
    }

    public static NSMenusBean getNsMenus() {
        return nsMenus;
    }
}
