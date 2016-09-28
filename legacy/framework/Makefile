#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: Makefile,v 1.2300 2003/11/24 00:54:31 nsadmin Exp $"

include $(SRC)/makefile.rule

FILES=index.html	\
	login.jsp	\
	logout.jsp	\
	relogin.jsp	\
	main.jsp	\
	action.html	\
	controll.html	\
	menu.jsp	\
	errorPage.jsp	\
	notfound.html

all:	WEB-INF images lib $(FILES)
	cd WEB-INF; make $@
	cd images; make $@
	cd lib; make $@
	install -o $(OWNER) -m $(MODE) $(FILES) $(WEBAPPS)
	cp WEB-INF/classes/com/nec/sydney/framework/report.cfg $(ETC)

clean:
	cd WEB-INF; make $@
