/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

import	com.nec.sydney.framework.*;

public class TestOfReporter {
	private static final String	cvsid = "@(#) $Id: TestOfReporter.java.sv,v 1.2300 2003/11/24 00:54:33 nsadmin Exp $";
	public static void	main(String[] av) {
		NSReporter	reporter = NSReporter.getInstance();
		if (av.length > 0) {
			reporter.init(av[0]);
		} else {
			reporter.init();
		}
		reporter.report(NSReporter.DEBUG, "debug");
		reporter.report(NSReporter.INFO, "info");
		reporter.report(NSReporter.WARN, "warn");
		reporter.report(NSReporter.ERROR, "error");
		reporter.report(NSReporter.FATAL, "fatal");
		NSException	ex = new NSException();
		reporter.report(ex);
		System.out.println(ex.where());
	}
}
