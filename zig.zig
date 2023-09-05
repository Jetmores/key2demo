?遍历 ?目录
const print=@import("std").debug.print;
const std=@import("std");
pub fn main() !void{
    var home=std.fs.cwd();
    var idir=try home.openIterableDir(".",.{});
    var iter=idir.iterate();
    while(try iter.next()) |e| {
        print("Entry: name={s} kind={any}\n",.{e.name,e.kind});
    }
    idir.close();
}

?hello ?world
const print = @import("std").debug.print;

pub fn main() void {
    print("Hello, world!\n", .{});
}

?hello ?world
const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Hello, {s}!\n", .{"world"});
}