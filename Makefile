TARGET = libdspp.a

ifdef DEBUG
CCFLAGS+= -O0 -DAOF_DEBUG_FLAG
else
CCFLAGS+= -O2
endif

CC:=gcc
CXX:=g++
LINK:=g++
AR:=ar

#==================================================================================
CCFLAGS+= -g -Wall -c -fmessage-length=0
RM:= rm -rf

#==================================================================================
vpath %.proto ./pb
SRC_DIR:=.

CPP_SRC_FILES:=$(shell find $(SRC_DIR) -type f -name "*.cpp" )

PROTO_FILES:=$(shell find $(SRC_DIR) -type f -name "*.proto")
PROTO_CC_FILES:=$(patsubst %.proto, %.pb.cc, $(PROTO_FILES))
PROTO_CC_FILES:=$(patsubst ./pb/%, ./src/%, $(PROTO_CC_FILES))
CC_SRC_FILES:=$(PROTO_CC_FILES)

#==================================================================================

LIBS:= 
STATICS_LIBS:=


INCLUDE:=-I.

#==================================================================================
CPP_OBJS:=$(CPP_SRC_FILES:%.cpp=%.o)
CPP_DEPS:=$(CPP_SRC_FILES:%.cpp=%.d)

CC_OBJS:=$(CC_SRC_FILES:%.cc=%.o)
CC_DEPS:=$(CC_SRC_FILES:%.cc=%.d)

OBJS:=$(CPP_OBJS)
OBJS+=$(CC_OBJS)

DEPS:=$(CPP_DEPS)
DEPS+=$(CC_DEPS)
#==================================================================================

all:$(TARGET) 

#==================================================================================

#compile project file
$(TARGET):$(OBJS)
	$(AR) rv $@ $^
	ranlib $@
	@echo -e '\033[32mBuild library file <$@> ......    SUCCESS.\033[0m'

src/%.pb.cc:%.proto
	protoc --cpp_out=./src --python_out=./dspc/dspp -I./pb $<
	

%.o:%.cpp 
	$(CXX) $(CCFLAGS) $(INCLUDE) -MD -MP -MF$(@:%.o=%.d) -MT$(@:%.o=%.d) -o $@  $<

%.o:%.cc 
	$(CXX) $(CCFLAGS) $(INCLUDE) -MD -MP -MF$(@:%.o=%.d) -MT$(@:%.o=%.d) -o $@  $<

install:
	mkdir -p $(PREFIX_BIN)
	install $(TARGET) $(PREFIX_BIN)

clean:
	find -name '*.o' -exec rm -rf {} \;
	find -name '*.d' -exec rm -rf {} \;
	find -name '*.pb.*' -exec rm -rf {} \;
	rm -f $(TARGET)

-include $(DEPS)

.PHONY: clean
