![](/images/ziggy.svg)
<div style="width:25%"><img src="/images/ziggy.svg" style="max-height:200px"></div>
### ?hello ?world
```zig
const print = @import("std").debug.print;
pub fn main() void {
    print("Hello, world!\n", .{});
}
```
```zig
const std = @import("std");
pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Hello, {s}!\n", .{"world"});
}
```

### ?遍历 ?目录 ?workdir
```zig
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
```

### ?http ?server
```zig
const std = @import("std");
const testing = std.testing;
const http = std.http;
const mem = std.mem;
const net = std.net;
const Uri = std.Uri;
const Allocator = mem.Allocator;
const assert = std.debug.assert;

//const Server = @This();
//const proto = @import("protocol.zig");

//test "HTTP server handles a chunked transfer coding request" {
pub fn main() anyerror!void {
    const builtin = @import("builtin");

    // This test requires spawning threads.
    if (builtin.single_threaded) {
        return error.SkipZigTest;
    }

    const native_endian = comptime builtin.cpu.arch.endian();
    if (builtin.zig_backend == .stage2_llvm and native_endian == .Big) {
        return error.SkipZigTest;
    }

    if (builtin.os.tag == .wasi) return error.SkipZigTest;

    //const allocator = std.testing.allocator;
    const allocator = std.heap.page_allocator;
    //const expect = std.testing.expect;
    //_ = expect;

    const max_header_size = 8192;
    var server = std.http.Server.init(allocator, .{ .reuse_address = true });
    defer server.deinit();

    const address = try std.net.Address.parseIp("127.0.0.1", 8000);
    try server.listen(address);
    const server_port = server.socket.listen_address.in.getPort();
    _ = server_port;

    const server_thread = try std.Thread.spawn(.{}, (struct {
        fn apply(s: *std.http.Server) !void {
            var res = try s.accept(.{
                .allocator = allocator,
                .header_strategy = .{ .dynamic = max_header_size },
            });
            defer res.deinit();
            defer _ = res.reset();
            try res.wait();
            //try expect(res.request.transfer_encoding.? == .chunked);

            const server_body: []const u8 = "message from server!\n";
            res.transfer_encoding = .{ .content_length = server_body.len };
            try res.headers.append("content-type", "text/plain");
            try res.headers.append("connection", "close");
            try res.do();

            //var buf: [128]u8 = undefined;
            //const n = try res.readAll(&buf);
            //try expect(std.mem.eql(u8, buf[0..n], "ABCD"));
            _ = try res.writer().writeAll(server_body);
            try res.finish();
        }
    }).apply, .{&server});

    server_thread.join();
}
```

### zig ?collection
1. ArrayList[Aligned][Unmanaged] ->vector
2. [Auto/String]HashMap[Unmanaged] ->unordered_map
3. SinglyLinkedList ->forward_list
4. ~~TailQueue~~DoublyLinkedList ->list
5. MultiArrayList ->结构中各元素组成各自的切片,同字段放一个切片中,便于列遍历(ArrayList是行遍历)
6. *[Auto/String]ArrayHashMap[Unmanaged]* 建议用HashMap更快

### ?manpage ?search
1. Chrome-设置-搜索引擎-管理搜索引擎和网站搜素-网站搜索-新增
2. Edge-设置-搜:地址栏和搜索-管理搜索引擎-添加
```
zig
zig
https://ziglang.org/documentation/master/std/#A;std?%s
```
