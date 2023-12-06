const std = @import("std");

//pub const default_level: Level = switch (builtin.mode) {
//    .Debug => .debug,
//    .ReleaseSafe => .info,
//    .ReleaseFast, .ReleaseSmall => .err,
//};

pub const std_options = struct {
    // Set the log level to info
    //pub const log_level = .info;
    pub const log_level = std.log.default_level;

    // Define logFn to override the std implementation
    pub const logFn = myLogFn;
};

pub fn myLogFn(
    comptime level: std.log.Level,
    comptime scope: @TypeOf(.EnumLiteral),
    comptime format: []const u8,
    args: anytype,
) void {
    // Ignore all non-error logging from sources other than
    // .my_project, .nice_library and the default
    const scope_prefix = "(" ++ switch (scope) {
        .my_project, .nice_library, std.log.default_log_scope => @tagName(scope),
        else => if (@intFromEnum(level) <= @intFromEnum(std.log.Level.err))
            @tagName(scope)
        else
            return,
    } ++ "): ";

    const prefix = "[" ++ comptime level.asText() ++ "] " ++ scope_prefix;

    // Print the message to stderr, silently ignoring any errors
    std.debug.getStderrMutex().lock();
    defer std.debug.getStderrMutex().unlock();
    const stderr = std.io.getStdErr().writer();
    nosuspend stderr.print(prefix ++ format ++ "\n", args) catch return;
}

pub fn main() void {
    // Using the default scope:
    std.log.debug("A borderline useless debug log message", .{}); // Won't be printed as log_level is .info
    std.log.info("Flux capacitor is starting to overheat", .{});
    std.log.warn("Warn", .{});
    std.log.err("Error", .{});

    // Using scoped logging:
    const my_project_log = std.log.scoped(.my_project);
    const nice_library_log = std.log.scoped(.nice_library);
    const verbose_lib_log = std.log.scoped(.verbose_lib);

    my_project_log.debug("Starting up", .{}); // Won't be printed as log_level is .info
    my_project_log.info("Starting up", .{});
    nice_library_log.warn("Something went very wrong, sorry", .{});
    nice_library_log.err("Error", .{});
    verbose_lib_log.warn("Added 1 + 1: {}", .{1 + 1}); // Won't be printed as it gets filtered out by our log function
}
