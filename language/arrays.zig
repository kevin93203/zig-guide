const std = @import("std");

pub fn main() void {
    const a = [_]u8{ 'h', 'e', 'l', 'l', 'o' };
    // const b = [_]u8{ 'w', 'o', 'r', 'l', 'd' };
    const len = a.len;
    std.debug.print("{}", .{len});
}
