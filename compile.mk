VERSION ?= dev
FLAGS += -DVERSION=$(VERSION)

# Generate dependency files alongside the object files
FLAGS += -MMD
# Optimization
FLAGS += -O3 -march=nocona -ffast-math
FLAGS += -Wall
FLAGS += -g
CXXFLAGS += -std=c++11


ifeq ($(ARCH), lin)
	FLAGS += -DARCH_LIN
endif

ifeq ($(ARCH), mac)
	FLAGS += -DARCH_MAC
	CXXFLAGS += -stdlib=libc++
	LDFLAGS += -stdlib=libc++
	MAC_SDK_FLAGS = -mmacosx-version-min=10.7
	FLAGS += $(MAC_SDK_FLAGS)
	LDFLAGS += $(MAC_SDK_FLAGS)
endif

ifeq ($(ARCH), win)
	FLAGS += -DARCH_WIN
	FLAGS += -D_USE_MATH_DEFINES
endif


OBJECTS += $(patsubst %, build/%.o, $(SOURCES))
DEPS = $(patsubst %, build/%.d, $(SOURCES))


# Final targets

$(TARGET): $(OBJECTS)
	$(CXX) -o $@ $^ $(LDFLAGS)

# Object targets

-include $(DEPS)

build/%.c.o: %.c
	@mkdir -p $(@D)
	$(CC) $(FLAGS) $(CFLAGS) -c -o $@ $<

build/%.cpp.o: %.cpp
	@mkdir -p $(@D)
	$(CXX) $(FLAGS) $(CXXFLAGS) -c -o $@ $<

build/%.cc.o: %.cc
	@mkdir -p $(@D)
	$(CXX) $(FLAGS) $(CXXFLAGS) -c -o $@ $<

build/%.m.o: %.m
	@mkdir -p $(@D)
	$(CC) $(FLAGS) $(CFLAGS) -c -o $@ $<
