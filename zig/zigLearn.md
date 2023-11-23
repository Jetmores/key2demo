### print
```zig
std.debug.print("Hello, world!\n", .{});
try std.io.getStdOut().writer().print("Hello, {s}!\n", .{"world"});
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