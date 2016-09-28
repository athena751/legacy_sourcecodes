/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.biz.framework.menu;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.nec.nsgui.model.entity.framework.menu.CategoryBean;
import com.nec.nsgui.model.entity.framework.menu.ItemBean;
import com.nec.nsgui.model.entity.framework.menu.MenuBaseBean;
import com.nec.nsgui.model.entity.framework.menu.NSMenusBean;
import com.nec.nsgui.model.entity.framework.menu.SubCategoryBean;

/**
 * The filter list which contained many filters.
 */
public class FilterList {
	private static final String cvsid = "@(#) $Id: FilterList.java,v 1.2 2005/06/13 08:05:43 liuyq Exp $";

	private List nsMenuFilters = new ArrayList();

	/**
	 * Add one filter to filter list.
	 * 
	 * @param filter
	 */
	public void addFilter(Filter filter) {
		nsMenuFilters.add(filter);
	}

	/**
	 * According to filter list do filter on every menu item.
	 * 
	 * @param nsMenus
	 *            root of nsmenus
	 * @return nsmenus after filtered
	 * @throws Exception
	 */
	public NSMenusBean filter(NSMenusBean nsMenus) throws Exception {
		nsMenus.setCategoryMap(mapFilter(nsMenus.getCategoryMap()));
		return nsMenus;
	}

	/**
	 * filter every menu item map.
	 * 
	 * @param map
	 * @return menus after filtered
	 * @throws Exception
	 */
	private Map mapFilter(Map map) throws Exception {
		Map newMap = new LinkedHashMap();
		// get keys
		Iterator it = map.keySet().iterator();
		// for every key
		while (it.hasNext()) {
			// get key and value(menubse object)
			String key = (String) it.next();
			MenuBaseBean menubase = (MenuBaseBean) map.get(key);
			// do filter in the filter list on menubase object
			menubase = filter(menubase);
			if (menubase == null) { // if return value is null, remove this menu
				// newMap.remove(key);
			} else { // else get sub map , and do filter in sub item.
				Map subMap;
				if (menubase instanceof CategoryBean) {
					subMap = ((CategoryBean) menubase).getSubCategoryMap();
					((CategoryBean) menubase)
							.setSubCategoryMap(mapFilter(subMap));
				} else if (menubase instanceof SubCategoryBean) {
					subMap = ((SubCategoryBean) menubase).getItemMap();
					((SubCategoryBean) menubase).setItemMap(mapFilter(subMap));
					if (((SubCategoryBean) menubase).getItemMap() == null
							|| ((SubCategoryBean) menubase).getItemMap()
									.isEmpty()) {
						menubase = null;
					}
				} else if (menubase instanceof ItemBean) {
					// do nothing.
				}
				// put back the menubase to map.
				if (menubase != null) {
					newMap.put(key, menubase);
				}
			}
		}
		return newMap;
	}

	/**
	 * filter menubase object according to every filter in filter list.
	 * 
	 * @param menubase
	 * @return
	 * @throws Exception
	 */
	private MenuBaseBean filter(MenuBaseBean menubase) throws Exception {
		for (int i = 0; i < nsMenuFilters.size(); i++) {
			Filter filter = (Filter) nsMenuFilters.get(i);
			menubase = filter.filter(menubase);
			if (menubase == null) {
				break;
			}
		}
		return menubase;
	}
}
