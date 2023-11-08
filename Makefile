# Makefile

# Define the zig executable
ZIG_EXEC = zig

# Define the zig command
ZIG_CMD = build-lib

# Define the source file
SRC = ./src/demo_string.c

# Define the system id
SYSTEM_ID = MacOSX-ARM64

# Define include and library paths
INCLUDE_PATH = /Users/daniels/Library/CloudStorage/OneDrive-Personal/projects/zig-librarylink-crosscompilation/libs/LibraryLink/include
LIBRARY_PATH = /Applications/Mathematica.app/Contents/SystemFiles/Libraries/MacOSX-ARM64

# Define the output
OUT_NAME = demo_string
# Define the output based on the target
ifeq ($(SYSTEM_ID),MacOSX-ARM64)
    OUT_FILE = lib$(OUT_NAME).dylib
    TARGET = aarch64-macos
else ifeq ($(SYSTEM_ID),MacOSX-x86-64)
    OUT_FILE = lib$(OUT_NAME).dylib
    TARGET = x86_64-macos
else ifeq ($(SYSTEM_ID),Linux-x86-64)
    OUT_FILE = lib$(OUT_NAME).so
    TARGET = x86_64-linux
else ifeq ($(SYSTEM_ID),Windows-x86-64)
    OUT_FILE = $(OUT_NAME).dll
    TARGET = x86_64-windows
else
    $(error Unknown target platform)
endif

# Define install name
INSTALL_NAME = -install_name $(OUT_FILE)

# The build target executable
all: $(SRC)
	$(ZIG_EXEC) $(ZIG_CMD) $(SRC) -lc --name $(OUT_NAME) -dynamic -install_name $(OUT_FILE) -target $(TARGET) -I$(INCLUDE_PATH) -L$(LIBRARY_PATH)
	mv *$(OUT_NAME)* ./LibraryResources/$(SYSTEM_ID)/

.PHONY: clean

clean:
	rm -f $(OUT_FILE)
