const std = @import("std");
const net = std.net;
const mode = std.io.evented;

//疑惑:一次nc和ctrl+c之后,echo就不可用(设置非阻塞亦如此)
pub fn main() !void {
    const localhost = try net.Address.parseIp("127.0.0.1", 9000);
    var server = net.StreamServer.init(.{
        .reuse_address = true,
    });
    defer server.deinit();

    try server.listen(localhost);
    while (true) {
        var conn = try server.accept();
        defer conn.stream.close();
        errdefer conn.stream.close();
        echo(conn) catch {
            continue;
        };
    }
}

fn echo(conn: net.StreamServer.Connection) !void {
    if (std.io.is_async) {
        std.debug.print("io is async\n", .{});
    }
    while (true) {
        var buffer: [8096]u8 = undefined;
        std.debug.print("in read\n", .{});
        var n = try conn.stream.reader().read(buffer[0..]);
        std.debug.print("out read:{d}\n", .{n});
        if (n == 0) {
            break;
        }
        _ = try conn.stream.writer().write(buffer[0..n]);
    }
}
