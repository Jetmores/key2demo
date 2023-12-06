### print log
```zig
std.debug.print("Hello, world!\n", .{});
try std.io.getStdOut().writer().print("Hello, {s}!\n", .{"world"});

占位符:{}默认自适应类型
c
d(还有b,o,x,X)
e(s)
*:指针
?:调试信息
#:打印值的原始16进制


/// The default log level is based on build mode.
pub const default_level: Level = switch (builtin.mode) {
    .Debug => .debug,
    .ReleaseSafe => .info,
    .ReleaseFast, .ReleaseSmall => .err,
};
std.log.debug("A borderline useless debug log message", .{});
std.log.info("Flux capacitor is starting to overheat", .{});
std.log.warn("Warn", .{});
std.log.err("Error", .{});
```

### expect
```zig
const expect = @import("std").testing.expect;

test "if statement" {
    const a = true;
    var x: u16 = 0;
    if (a) {
        x += 1;
    } else {
        x += 2;
    }
    try expect(x == 1);
}
```

### Value assignment ?赋值
```zig
//(const|var) identifier[: type] = value
var variable: u32 = 5000;
var inferred_variable = @as(u32, 5000);
var b: u32 = undefined;

const a = [5]u8{ 'h', 'e', 'l', 'l', 'o' };
const array = [_]u8{ 'h', 'e', 'l', 'l', 'o' };
const length = array.len; // 5
```

### if
```zig
test "if statement expression" {
    const a = true;
    var x: u16 = 0;
    x += if (a) 1 else 2;
    try expect(x == 1);
}
```

### while
