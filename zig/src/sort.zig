///sort do myself
const std = @import("std");
const assert = std.debug.assert;
const eql = std.mem.eql;

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

test "sort case" {
    var b: usize = 0;
    std.debug.print("usize(0-1):{d}\n", .{b -% 1});
    //var e: usize = 8;
    var i = b + 1;
    try expect(usize == @TypeOf(i));
    var a = [_]i32{ 9, 3, 1, 5, 2, 7, 3, 8 };
    try expect(usize == @TypeOf(a.len));
    try expect(1 == 1);
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