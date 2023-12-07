///sort do myself
const std = @import("std");
const assert = std.debug.assert;
const mem = std.mem;

//test
const expect = std.testing.expect;

pub fn main() !void {
    var a = [_]i32{ 9, 3, 1, 5, 2, 7, 3, 8 };
    //insertSort(i32, &a, 0, 8);
    insertSort(i32, a[0..], 0, 8);
    for (&a) |*x| {
        std.debug.print("{d}\t", .{x.*});
        std.debug.print("{*}", .{x});
        std.debug.print("\n", .{});
    }
}

pub fn insertSort(comptime T: type, items: []T, b: usize, e: usize) void {
    assert(b <= e);

    var i = b + 1;
    while (i < e) : (i += 1) {
        var j = i;
        const base: T = items[i];
        while (j > b and items[j - 1] > base) : (j -= 1) {
            items[j] = items[j - 1];
        }
        items[j] = base;
    }
}

test "sort case" {
    var b: usize = 0;
    std.debug.print("usize(0-1):{d}\n", .{b -% 1});
    //var e: usize = 8;
    var i = b + 1;
    try expect(usize == @TypeOf(i));
    var a = [_]i32{ 9, 3, 1, 5, 2, 7, 3, 8 };
    try expect(usize == @TypeOf(a.len));
    insertSort(i32, a[0..], 0, 8);
    try expect(mem.eql(i32, &a, &[_]i32{ 1, 2, 3, 3, 5, 7, 8, 9 }));
}

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

fn fibonacci(n: u16) u16 {
    if (n == 0 or n == 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

test "function recursion" {
    std.debug.print("usize(0-1):{d}\n", .{@as(usize, 0) -% 1});
    const x = fibonacci(10);
    try expect(x == 55);
}

test "multi defer" {
    var x: f32 = 5;
    {
        defer x += 2;
        defer x /= 2;
        try expect(x == 5);
    }
    try expect(x == 4.5);
}

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

test "widening" {
    const a: u16 = 1024;
    const b: u16 = 512;

    const c: u32 = @as(u32, a) * b;
    try std.testing.expect(c == 1024 * 512);
}
