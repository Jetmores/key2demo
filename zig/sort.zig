///sort
const std = @import("std");
const assert = std.debug.assert;
const expect = std.testing.expect;
const eql = std.mem.eql;

pub fn main() void {
    var a = [_]i32{ 9, 3, 1, 5, 2, 7, 3, 8 };
    insertSort(i32, &a, 0, 8);
    for (a) |x| {
        std.debug.print("{3d}", .{x});
    }
    std.debug.print("\n", .{});
}

pub fn insertSort(comptime T: type, items: []T, a: usize, b: usize) void {
    assert(a <= b);

    var i = a + 1;
    //try expect(i32 == @TypeOf(i));
    while (i < b) : (i += 1) {
        var j = i;
        const base: T = items[i];
        while (j > a and items[j - 1] > base) : (j -= 1) {
            items[j] = items[j - 1];
        }
        items[j] = base;
    }
}
