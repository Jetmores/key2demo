### ?manpage ?search
1. Chrome-设置-搜索引擎-管理搜索引擎和网站搜素-网站搜索-新增
2. Edge-设置-搜:地址栏和搜索-管理搜索引擎-添加
```
zig
zig
https://ziglang.org/documentation/master/std/#A;std?%s
```

### zig ?collection <https://github.com/ziglang/zig/issues/7782>
1. ArrayList[Aligned][Unmanaged] ->vector
2. MultiArrayList ->结构中各元素组成各自的切片,同字段放一个切片中,便于列遍历(ArrayList是行遍历)
3. SegmentedList 类似ArrayList但避免了预分配耗尽后的拷贝搬迁,类似一半的deque
4. SinglyLinkedList ->forward_list
5. DoublyLinkedList ->list
6. [Auto/String]HashMap[Unmanaged] ->unordered_map/BufMap-BufSet拷贝key后拥有它,特化且带数据所有权StringHashMap
7. *[Auto/String]ArrayHashMap[Unmanaged]* 特化遍历(空间换时间),否则用HashMap
8. <https://github.com/ziglang/std-lib-orphanage/tree/master>
    * std.rb.Tree
    * std.BloomFilter:用来检测一个元素是否在一个集合中,它的优点是空间效率高，查询速度快，缺点是有一定的误判率和删除困难;桶为1 bit(优化空间),多个hash函数将多个bit置为1,以此表示某个key存在(元素越多,冲突概率越大),不存在则一定不存在.(有点类似记忆与神经元)

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

//test "HTTP server handles a chunked transfer coding request"
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

### std.http
1. head  
key,value组合的字段数组,key-index散列表
```zig
pub const HeaderList = std.ArrayListUnmanaged(Field);
pub const HeaderIndexList = std.ArrayListUnmanaged(usize);
pub const HeaderIndex = std.HashMapUnmanaged([]const u8, HeaderIndexList, CaseInsensitiveStringContext, std.hash_map.default_max_load_percentage);
pub const Field = struct {
    name: []const u8,
    value: []const u8,
}
pub const Headers = struct {
    allocator: Allocator,
    list: HeaderList = .{},
    index: HeaderIndex = .{},
}
```