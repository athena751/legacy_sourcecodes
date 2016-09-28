#
#       Copyright (c) 2001 NEC Corporation
#
#       NEC SOURCE CODE PROPRIETARY
#
#       Use, duplication and disclosure subject to a source code
#       license agreement with NEC Corporation.
#

# "@(#) $Id: Makefile,v 1.2300 2003/11/24 00:54:32 nsadmin Exp $"

all:	web.xml 
	cp web.xml $(WEBAPPS)/WEB-INF
	find classes -type f -name '*.java' -print | \
	xargs $(JAVAC) -g -deprecation -d $(WEBINF) -classpath $(MYCLASSPATH)
	#cd classes/com/nec/sydney/framework; make $@
	##cd classes/com/nec/sydney/net/soap; make $@
	#cd classes/com/nec/sydney/system; make $@
	#cd classes/com/nec/sydney/service/statistics/config; make $@

clean:
	cd classes/com/nec/sydney/framework; make $@
	cd classes/com/nec/sydney/net/soap; make $@
	cd classes/com/nec/sydney/system; make $@
	cd classes/com/nec/sydney/service/statistics/config; make $@
