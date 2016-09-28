/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

import	java.io.*;
import	java.util.*;
import	javax.xml.parsers.*;
import	org.w3c.dom.*;

import	com.nec.sydney.framework.*;

public class	TestOfMenuMaker {
	private static final String	cvsid = "@(#) $Id: TestOfMenuMaker.java.sv,v 1.2300 2003/11/24 00:54:33 nsadmin Exp $";
	public static void	main(String[] av) {
		try {
			Document	root = setMenuXML(av[0]);
			root.normalize();
			FolderDiv	top = new FolderDiv();
			NSMenuMaker	menu = new NSMenuMaker();
			menu.digNode(top, root.getDocumentElement());
			showFolder(top, 0);
			Vector	vec = new Vector();
			int	size = FolderDiv.enList(vec, top, 0);
			System.out.println("--------------");
			System.out.println("size" + size);
			Iterator	it = vec.iterator();
			while (it.hasNext()) {
				Div	div = (Div)it.next();
				printDivInfo(div, div.getDepth());
			}
		} catch (Exception ex) {
			System.out.println(ex);
			ex.printStackTrace();
		}
	}
	public static void	showFolder(FolderDiv folder, int depth) {
		Iterator	it = folder.getIterator();
		while (it.hasNext()) {
			Div	div = (Div)it.next();
			printDivInfo(div, depth);
			if (div instanceof FolderDiv) {
				showFolder((FolderDiv)div, depth+1);
			} 
		}
	}
	private static void	printTab(int n) {
		while (n-- > 0) {
			System.out.print("\t");
		}
	}
	private static void	printDivInfo(Div div, int depth) {
		printTab(depth);
		if (div instanceof FolderDiv) {
			System.out.print("+("+depth+")");
		} else {
			System.out.print("-("+depth+")");
		}
		System.out.println(div.getName()+"("+div.getTip()+")");
		if (div instanceof ItemDiv) {
			printTab(2*depth);
			System.out.println(((ItemDiv)div).getHref()+"("+
					((ItemDiv)div).getHelp() + ")");
		}
	}
	private	static Document	setMenuXML(String f) throws Exception {
		DocumentBuilderFactory factory =
			DocumentBuilderFactory.newInstance(); 
		DocumentBuilder builder = factory.newDocumentBuilder();
		return builder.parse(new File(f));
	}
}
