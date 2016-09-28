#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: Makefile,v 1.2300 2003/11/24 00:54:32 nsadmin Exp $"

include	$(SRC)/makefile.rule

JAVAS=MenuConstants.java  	\
	Div.java		\
	FolderDiv.java		\
	ItemDiv.java		\
	NSMenuMaker.java	\
	NSConstant.java		\
	NSException.java	\
	NSReporter.java		\
	NSFilter.java		\
	NSServlet.java		\
	NSUserInfo.java		\
	NSLogin.java		\
	NSLogout.java	

CLASS=$(JAVAS:.java=.class)

all: $(CLASS) report.cfg
	cp report.cfg $(ROOT)/etc

clean: 
	rm -f $(CLASS) TestOfMenuMaker.class

TESTXML=$(SRC)/menus/menu-config/NASAdministrator.xml

TestOfMenuMaker.java: TestOfMenuMaker.java.sv
	mv $< $@

TestOfMenuMaker: TestOfMenuMaker.java $(CLASS) TestOfMenuMaker.class
	$(JAVA_HOME)/bin/java -classpath $(MYCLASSPATH):. TestOfMenuMaker $(TESTXML)
	mv TestOfMenuMaker.java TestOfMenuMaker.java.sv

TestOfReporter.java: TestOfReporter.java.sv
	mv $< $@

TestOfReporter: TestOfReporter.java $(CLASS) TestOfReporter.class
	$(JAVA_HOME)/bin/java -classpath $(MYCLASSPATH):. TestOfReporter
	$(JAVA_HOME)/bin/java -classpath $(MYCLASSPATH):. TestOfReporter report.cfg
	mv TestOfReporter.java TestOfReporter.java.sv
