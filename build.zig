const std = @import("std");

const CrossTarget = std.zig.CrossTarget;

const MathematicaPlatform = struct {
    system_id: []const u8,
    cross_target: CrossTarget,

    pub fn init(system_id: []const u8, arch_os_abi: []const u8) MathematicaPlatform {
        @setEvalBranchQuota(10000);
        const cross_target = CrossTarget.parse(.{ .arch_os_abi = arch_os_abi }) catch unreachable;
        return .{
            .system_id = system_id,
            .cross_target = cross_target,
        };
    }
};

const MathematicaPlatforms = [_]MathematicaPlatform{
    MathematicaPlatform.init("Windows-x86-64", "x86_64-windows"),
    MathematicaPlatform.init("Linux-x86-64", "x86_64-linux"),
    MathematicaPlatform.init("MacOSX-x86-64", "x86_64-macos"),
    MathematicaPlatform.init("MacOSX-ARM64", "aarch64-macos"),
};

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});

    inline for (MathematicaPlatforms) |platform| {
        const lib = b.addSharedLibrary(.{
            .name = "demo_string",
            // In this case the main source file is merely a path, however, in more
            // complicated build scripts, this could be a generated file.
            .root_source_file = .{ .path = "src/demo_string.c" },
            .target = platform.cross_target,
            .optimize = optimize,
        });

        // Link the C library
        lib.linkLibC();

        // Add the path to LibraryLink (and others) include files
        lib.addIncludePath(.{ .path = "./libs/LibraryLink/include" });

        // Add the path to various Wolfram Language libraries, e.g. Wolfram RTL
        lib.addLibraryPath(.{ .path = "/Applications/Mathematica.app/Contents/SystemFiles/Libraries/MacOSX-ARM64" });

        // Install the library, i.e. compile it
        b.installArtifact(lib);
        const lib_artifact = b.addInstallArtifact(
            lib,
            .{
                .dest_dir = .{
                    .override = .{ .custom = "../LibraryResources/" ++ platform.system_id },
                },
            },
        );
        b.getInstallStep().dependOn(&lib_artifact.step);
    }
}
