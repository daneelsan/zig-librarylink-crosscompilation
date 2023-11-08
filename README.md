# Wolfram LibraryLink + Zig cross-compilation

A demo that shows how to cross-compile Wolfram Library Link code using zig.

## Build

Tested in zig version:
```shell
$ zig version
0.12.0-dev.1127+32bc07767
```

### Using build.zig

Build the `demo_string` libraries (for each supported platform) using the `build.zig` file:
```shell
$ zig build --summary all
Build Summary: 13/13 steps succeeded
install success
├─ install demo_string success
│  └─ zig build-lib demo_string Debug x86_64-windows cached 14ms MaxRSS:22M
├─ install demo_string cached
│  └─ zig build-lib demo_string Debug x86_64-windows (reused)
├─ install demo_string success
│  └─ zig build-lib demo_string Debug x86_64-linux cached 14ms MaxRSS:22M
├─ install demo_string cached
│  └─ zig build-lib demo_string Debug x86_64-linux (reused)
├─ install demo_string success
│  └─ zig build-lib demo_string Debug x86_64-macos cached 14ms MaxRSS:22M
├─ install demo_string cached
│  └─ zig build-lib demo_string Debug x86_64-macos (reused)
├─ install demo_string success
│  └─ zig build-lib demo_string Debug aarch64-macos cached 14ms MaxRSS:22M
└─ install demo_string cached
   └─ zig build-lib demo_string Debug aarch64-macos (reused)
```

This will build the library for all the supported platforms and install them on `LibraryResources/`.
```shell
$ tree LibraryResources/
LibraryResources/
├── Linux-x86-64
│   └── libdemo_string.so
├── MacOSX-ARM64
│   └── libdemo_string.dylib
├── MacOSX-x86-64
│   └── libdemo_string.dylib
└── Windows-x86-64
    ├── demo_string.dll
    ├── demo_string.lib
    └── demo_string.pdb

5 directories, 6 files
```
### Using ./build.wls

Build the `demo_string` libraries (for each supported platform) using the `build.wls` script (you need to provide the path to the directory containing the zig executable.):
```Mathematica
$ ./build.wls ~/programs/zig-0.12.0-dev.1127+32bc07767/
/Users/daniels/programs/zig-0.12.0-dev.1127+32bc07767/zig cc -shared -o "/Users/daniels/Library/CloudStorage/OneDrive-Personal/projects/zig-librarylink-crosscompilation/LibraryResources/MacOSX-x86-64/Working-m6502-26423-4202438144-1/libdemo_string.dylib" -target x86_64-macos  -I"/Applications/M14.0.0.app/Contents/SystemFiles/IncludeFiles/C" -I"/Applications/M14.0.0.app/Contents/SystemFiles/Links/MathLink/DeveloperKit/MacOSX-ARM64/CompilerAdditions" "/Users/daniels/Library/CloudStorage/OneDrive-Personal/projects/zig-librarylink-crosscompilation/src/demo_string.c"  -F"/Applications/M14.0.0.app/Contents/SystemFiles/Links/MathLink/DeveloperKit/MacOSX-ARM64/CompilerAdditions" -L"/Applications/M14.0.0.app/Contents/SystemFiles/Libraries/MacOSX-ARM64"   2>&1

/Users/daniels/programs/zig-0.12.0-dev.1127+32bc07767/zig cc -shared -o "/Users/daniels/Library/CloudStorage/OneDrive-Personal/projects/zig-librarylink-crosscompilation/LibraryResources/Linux-x86-64/Working-m6502-26423-4202438144-2/libdemo_string.so" -target x86_64-linux  -I"/Applications/M14.0.0.app/Contents/SystemFiles/IncludeFiles/C" -I"/Applications/M14.0.0.app/Contents/SystemFiles/Links/MathLink/DeveloperKit/MacOSX-ARM64/CompilerAdditions" "/Users/daniels/Library/CloudStorage/OneDrive-Personal/projects/zig-librarylink-crosscompilation/src/demo_string.c"  -F"/Applications/M14.0.0.app/Contents/SystemFiles/Links/MathLink/DeveloperKit/MacOSX-ARM64/CompilerAdditions" -L"/Applications/M14.0.0.app/Contents/SystemFiles/Libraries/MacOSX-ARM64"   2>&1

/Users/daniels/programs/zig-0.12.0-dev.1127+32bc07767/zig cc -shared -o "/Users/daniels/Library/CloudStorage/OneDrive-Personal/projects/zig-librarylink-crosscompilation/LibraryResources/Windows-x86-64/Working-m6502-26423-4202438144-3/demo_string.dll" -target x86_64-windows  -I"/Applications/M14.0.0.app/Contents/SystemFiles/IncludeFiles/C" -I"/Applications/M14.0.0.app/Contents/SystemFiles/Links/MathLink/DeveloperKit/MacOSX-ARM64/CompilerAdditions" "/Users/daniels/Library/CloudStorage/OneDrive-Personal/projects/zig-librarylink-crosscompilation/src/demo_string.c"  -F"/Applications/M14.0.0.app/Contents/SystemFiles/Links/MathLink/DeveloperKit/MacOSX-ARM64/CompilerAdditions" -L"/Applications/M14.0.0.app/Contents/SystemFiles/Libraries/MacOSX-ARM64"   2>&1

/Users/daniels/programs/zig-0.12.0-dev.1127+32bc07767/zig cc -shared -o "/Users/daniels/Library/CloudStorage/OneDrive-Personal/projects/zig-librarylink-crosscompilation/LibraryResources/MacOSX-ARM64/Working-m6502-26423-4202438144-4/libdemo_string.dylib" -target aarch64-macos  -I"/Applications/M14.0.0.app/Contents/SystemFiles/IncludeFiles/C" -I"/Applications/M14.0.0.app/Contents/SystemFiles/Links/MathLink/DeveloperKit/MacOSX-ARM64/CompilerAdditions" "/Users/daniels/Library/CloudStorage/OneDrive-Personal/projects/zig-librarylink-crosscompilation/src/demo_string.c"  -F"/Applications/M14.0.0.app/Contents/SystemFiles/Links/MathLink/DeveloperKit/MacOSX-ARM64/CompilerAdditions" -L"/Applications/M14.0.0.app/Contents/SystemFiles/Libraries/MacOSX-ARM64"   2>&1
```

This will also build the library for all the supported platforms and install them on `LibraryResources/`.
```shell
$ tree LibraryResources/
LibraryResources/
├── Linux-x86-64
│   └── libdemo_string.so
├── MacOSX-ARM64
│   └── libdemo_string.dylib
├── MacOSX-x86-64
│   └── libdemo_string.dylib
└── Windows-x86-64
    ├── demo_string.dll
    ├── demo_string.lib
    └── demo_string.pdb

5 directories, 6 files
```

### Using a Makefile

Alternatively, build the library for each platform using the Makefile.
For example, for `Linux-x86-64`:
```shell
$ make SYSTEM_ID=Linux-x86-64
zig build-lib ./src/demo_string.c -lc --name demo_string -dynamic -install_name libdemo_string.so -target x86_64-linux -I/Users/daniels/Library/CloudStorage/OneDrive-Personal/projects/zig-librarylink-crosscompilation/libs/LibraryLink/include -L/Applications/Mathematica.app/Contents/SystemFiles/Libraries/MacOSX-ARM64
mv *demo_string* ./LibraryResources/Linux-x86-64/
```
