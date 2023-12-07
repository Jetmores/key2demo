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
```zig
test "while with continue" {
    var sum: u8 = 0;
    var i: u8 = 0;
    while (i <= 3) : (i += 1) {
        if (i == 2) continue;//or break
        sum += i;
    }
    try expect(sum == 4);
}
```

### for
```zig
test "for" {
    //character literals are equivalent to integer literals
    const string = [_]u8{ 'a', 'b', 'c' };

    for (string) |character| {
        _ = character;
    }

    for (string) |_| {}

    for (string, 0..) |character, index| {
        _ = character;
        _ = index;
    }

    for (string, 0..) |_, index| {
        _ = index;
    }
}
```

### fn
```zig
fn fibonacci(n: u16) u16 {
    if (n == 0 or n == 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

test "function recursion" {
    const x = fibonacci(10);
    try expect(x == 55);
}
```

### defer
```zig
test "multi defer" {
    var x: f32 = 5;
    {
        defer x += 2;
        defer x /= 2;
        try expect(x == 5);
    }
    try expect(x == 4.5);
}
```

### error:like enum
```zig
const FileOpenError = error{
    AccessDenied,
    OutOfMemory,
    FileNotFound,
};
const AllocationError = error{OutOfMemory};

test "coerce error from a subset to a superset" {
    const err: FileOpenError = AllocationError.OutOfMemory;
    try expect(err == FileOpenError.OutOfMemory);
}
```

