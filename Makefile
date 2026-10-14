CXX ?= clang++
CXXFLAGS += -std=c++17 -O2 $(shell pkg-config --cflags opencv4)

# opencv is static here, so its own modules and the codecs it calls into both
# have to be named; -L dirs come from the dev shell's NIX_LDFLAGS.
LDLIBS := -lopencv_highgui -lopencv_imgcodecs -lopencv_imgproc -lopencv_core \
          -littnotify -ltegra_hal \
          -ljpeg -lpng -ltiff -lwebp -lwebpmux -lwebpdemux -lopenjp2 -lz
LDLIBS += -L$(shell pkg-config --variable=prefix opencv4)/lib/opencv4/3rdparty

# highgui's window backend: Cocoa on darwin, gtk3 everywhere else.
ifeq ($(shell uname),Darwin)
  LDLIBS += -framework Cocoa -framework AppKit
else
  LDLIBS += $(shell pkg-config --libs gtk+-3.0)
endif

demo: main.cc
	$(CXX) $(CXXFLAGS) $< -o $@ $(LDLIBS)

clean:
	rm -f demo

.PHONY: clean
