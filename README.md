# opencv_example_make

A minimal OpenCV demo built with a plain Makefile. It opens the image given on
the command line and shows it in a window until a key is pressed.

## Requirements

This needs the dev shell from https://github.com/ormandi/nix_shell_env, which
provides clang 19, pkg-config and a static OpenCV 4.13.0. Nothing here builds
outside it, since the headers and libraries are only on the search path inside
the shell.

## Building

```console
$ nix develop github:ormandi/nix_shell_env
$ make
clang++ -std=c++17 -O2 -I/nix/store/...-opencv-4.13.0/include/opencv4 main.cc \
  -o demo -lopencv_highgui -lopencv_imgcodecs -lopencv_imgproc -lopencv_core \
  -littnotify -ltegra_hal -ljpeg -lpng -ltiff -lwebp -lwebpmux -lwebpdemux \
  -lopenjp2 -lz -L/nix/store/...-opencv-4.13.0/lib/opencv4/3rdparty \
  -framework Cocoa -framework AppKit

$ ./demo test.png
test.png: 64x64, 3 channel(s)
```

## What is going on

OpenCV is linked statically, so the `libopencv_*.a` archives end up inside the
binary; `otool -L demo` (or `ldd` on Linux) lists no OpenCV libraries at all.
Only OpenCV itself is static, so the Makefile also names the image codecs it
calls into (jpeg, png, tiff, webp, openjpeg, zlib), which remain dynamic. The
window backend is Cocoa on macOS and gtk3 elsewhere, which is why the link line
branches on the platform. Note that the macOS window has no close button, so a
keypress is the only way to exit.
