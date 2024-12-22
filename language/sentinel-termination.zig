const expect = @import("std").testing.expect;
const std = @import("std");

test "sentinel termination" {
    // 表長度為3的u8 array，且結尾符是0 (結尾符不算在長度內)
    const terminated = [3:0]u8{ 3, 2, 1 };
    std.debug.print("{d}\n", .{terminated});
    try expect(terminated.len == 3);
    try expect(@as(*const [4]u8, @ptrCast(&terminated))[3] == 0);
}

test "string literal" {
    // 表長度為3的const u8 array，且結尾符是0 (結尾符不算在長度內)
    try expect(@TypeOf("hello") == *const [5:0]u8);
}

test "C string" {
    const c_string: [*:0]const u8 = "hello"; // * 表示是純指標，沒有len (與C的string概念相同)

    // raise error!
    // std.debug.print("{d}\n", .{c_string.len});

    var array: [5]u8 = undefined;

    var i: usize = 0;
    while (c_string[i] != 0) : (i += 1) {
        array[i] = c_string[i];
    }
    std.debug.print("{s}\n", .{c_string});
    std.debug.print("{s}\n", .{array});
}

test "coercion" {
    const a: [*:0]u8 = undefined;
    const b: [*]u8 = a;

    const c: [5:0]u8 = undefined;
    const d: [5]u8 = c;

    const e: [:0]f32 = undefined;
    const f: []f32 = e;

    _ = .{ b, d, f };
}

test "sentinel terminated slicing" {
    var x = [_:0]u8{255} ** 3;
    std.debug.print("{d}\n", .{x.len});
    const y = x[0..3 :0];
    std.debug.print("{d}\n", .{y.len});
}
