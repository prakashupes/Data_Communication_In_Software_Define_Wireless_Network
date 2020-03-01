COMPONENT=WSNSDNTestAppC
BUILD_EXTRA_DEPS = InitializationMsg.py InitializationMsg.class RoutingMsg.py RoutingMsg.class
CLEAN_EXTRA = InitializationMsg.py InitializationMsg.class InitializationMsg.java RoutingMsg.py RoutingMsg.class RoutingMsg.java

InitializationMsg.py: WSNSDNTest.h
	mig python -target=$(PLATFORM) $(CFLAGS) -python-classname=InitializationMsg WSNSDNTest.h initialization_msg -o $@

InitializationMsg.class: InitializationMsg.java
	javac InitializationMsg.java

InitializationMsg.java: WSNSDNTest.h
	mig java -target=$(PLATFORM) $(CFLAGS) -java-classname=InitializationMsg WSNSDNTest.h initialization_msg -o $@

RoutingMsg.py: WSNSDNTest.h
	mig python -target=$(PLATFORM) $(CFLAGS) -python-classname=RoutingMsg WSNSDNTest.h Controller_Routing_Table -o $@

RoutingMsg.class: RoutingMsg.java
	javac RoutingMsg.java	
 
RoutingMsg.java: WSNSDNTest.h
	mig java -target=$(PLATFORM) $(CFLAGS) -java-classname=RoutingMsg WSNSDNTest.h Controller_Routing_Table -o $@

PFLAGS+=-DRF230_DEF_RFPOWER=0xF

CFLAGS += -DTOSH_DATA_LENGTH=127

include $(MAKERULES)



