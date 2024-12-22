const expect = @import("std").testing.expect;
const std = @import("std");

test "inline for" {
    const types = [_]type{ i32, f32, u8, bool };
    var sum: usize = 0;
    inline for (types) |T| sum += @sizeOf(T);
    try expect(sum == 10);
    // std.debug.print("{}", .{@sizeOf(types)});
}
