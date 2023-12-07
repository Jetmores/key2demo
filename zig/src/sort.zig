///sort do myself
const std = @import("std");
const assert = std.debug.assert;
const mem = std.mem;

//test
const expect = std.testing.expect;
const expectEqual = std.testing.expectEqual;

pub fn main() !void {
    var a = [_]i32{ 9, 3, 1, 5, 2, 7, 3, 8 };
    //insertSort(i32, &a, 0, 8);
    insertSort(i32, a[0..], 0, 8);
    for (&a) |*x| {
        std.debug.print("{d}\t", .{x.*});
        std.debug.print("{*}", .{x});
        std.debug.print("\n", .{});
    }

    {
        @setRuntimeSafety(false);
        const c = [3]u8{ 1, 2, 3 };
        var index: u8 = 5;
        const b = c[index];
        _ = b;
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

test "error union" {
    const maybe_error: AllocationError!u16 = 10;
    //const no_error = maybe_error catch 0;
    const no_error = maybe_error catch |x| return x;

    try expect(@TypeOf(no_error) == u16);
    try expect(no_error == 10);
}

fn failingFunction() error{Oops}!void {
    return error.Oops;
}

test "returning an error" {
    failingFunction() catch |err| {
        try expect(err == error.Oops);
        return;
    };
}

var problems: u32 = 98;

fn failFnCounter() error{Oops}!void {
    errdefer problems += 1;
    try failingFunction();
}

test "errdefer" {
    failFnCounter() catch |err| {
        try expect(err == error.Oops);
        try expect(problems == 99);
        return;
    };
}

fn createFile() !void {
    return error.AccessDenied;
}

test "inferred error set" {
    //type coercion successfully takes place
    //const x: error{AccessDenied}!void = createFile();
    const x: error{AccessDenied}!void = createFile();
    try expect(@TypeOf(x) == (error{AccessDenied}!void));

    //Zig does not let us ignore error unions via _ = x;
    //we must unwrap it with "try", "catch", or "if" by any means
    _ = x catch {};
}

test "switch expression" {
    var x: i8 = 100;
    var y: i8 = 0;
    x = switch (x) {
        -1...1 => -x,
        20, 50 => @divExact(x, y), //runtime y==0 result in crashed,comptime y==0 compile error
        10, 100 => try std.math.divExact(i8, x, 10), //return error
        else => x, //try comment this line
    };
    try expect(x == 10);
}

test "out of bounds" {
    @setRuntimeSafety(false);
    const a = [3]u8{ 1, 2, 3 };
    var index: u8 = 5;
    const b = a[index];
    _ = b;
}

fn asciiToUpper(x: u8) u8 {
    return switch (x) {
        'a'...'z' => x + 'A' - 'a',
        'A'...'Z' => x,
        //else => unreachable,//runtime error,like out of bounds index
        else => 0,
    };
}

test "unreachable switch" {
    try expect(asciiToUpper('a') == 'A');
    try expect(asciiToUpper('A') == 'A');
    //try expect(asciiToUpper('0') == '0');//reached unreachable code
    var c: u8 = 'A';
    var y: u8 = ('A' - '0');
    c = c - y;
    try expect(asciiToUpper(c) == 0);
}

fn increment(num: *u8) void {
    num.* += 1;
}

test "pointers" {
    var x: u8 = 1;
    increment(&x);
    try expect(x == 2);
    try expect(@sizeOf(usize) == @sizeOf(*u8));
    try expect(@sizeOf(isize) == @sizeOf(*u8));
}

test "Basic vector usage" {
    // Vectors have a compile-time known length and base type.
    const a = @Vector(4, i32){ 1, 2, 3, 4 };
    const b = @Vector(4, i32){ 5, 6, 7, 8 };

    // Math operations take place element-wise.
    const c = a + b;

    // Individual vector elements can be accessed using array indexing syntax.
    try expectEqual(12, c[3]);
    try expect(12 == c[3]);
    try expect(std.meta.eql(c, @Vector(4, i32){ 6, 8, 10, 12 }));
}

test "Conversion between vectors, arrays, and slices" {
    // Vectors and fixed-length arrays can be automatically assigned back and forth
    var arr1: [4]f32 = [_]f32{ 1.1, 3.2, 4.5, 5.6 };
    var vec: @Vector(4, f32) = arr1;
    var arr2: [4]f32 = vec;
    try expectEqual(arr1, arr2);

    // You can also assign from a slice with comptime-known length to a vector using .*
    try expect(@TypeOf(arr1[1..3]) == (*[2]f32));
    try expect(@TypeOf(arr1[1..3].*) == ([2]f32));
    try expect(@TypeOf(&arr1) == (*[4]f32));
    const vec2: @Vector(2, f32) = arr1[1..3].*;

    var slice: []const f32 = &arr1;
    var offset: u32 = 1;
    // To extract a comptime-known length from a runtime-known offset,
    // first extract a new slice from the starting offset, then an array of
    // comptime-known length
    const vec3: @Vector(2, f32) = slice[offset..][0..2].*;
    try expectEqual(slice[offset], vec2[0]);
    try expectEqual(slice[offset + 1], vec2[1]);
    try expectEqual(vec2, vec3);
}

test "pointer arithmetic with many-item pointer" {
    const array = [_]i32{ 1, 2, 3, 4 };
    //var ptr: [*]const i32 = &array;
    try expect(@TypeOf(&array) == (*const [4]i32));
    try expect(@TypeOf(array[0..]) == (*const [4]i32));
    var ptr: [*]const i32 = array[0..];

    try expect(ptr[0] == 1);
    ptr += 1;
    try expect(ptr[0] == 2);
}

test "pointer arithmetic with slices" {
    var array = [_]i32{ 1, 2, 3, 4 };
    var length: usize = 0;
    var slice = array[length..array.len];

    try expect(slice[0] == 1);
    try expect(slice.len == 4);

    slice.ptr += 1;
    // now the slice is in an bad state since len has not been updated

    try expect(slice[0] == 2);
    try expect(slice.len == 4);
}

test "@intFromPtr and @ptrFromInt" {
    const ptr: *i32 = @ptrFromInt(0xdeadbee0);
    const addr = @intFromPtr(ptr);
    try expect(@TypeOf(addr) == usize);
    try expect(addr == 0xdeadbee0);
}

test "allowzero" {
    var zero: usize = 0;
    var ptr: *allowzero i32 = @ptrFromInt(zero);
    try expect(@intFromPtr(ptr) == 0);
}
