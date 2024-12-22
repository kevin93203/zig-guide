const expect = @import("std").testing.expect;
const std = @import("std");

test "float widening" {
    const a: f16 = 0;
    const b: f32 = a;
    const c: f128 = b;
    try expect(c == @as(f128, a));
}

test "float_literal" {
    // const floating_point: f64 = 123.0E+77;
    // const another_float: f64 = 123.0;
    // const yet_another: f64 = 123.0e+77;

    const hex_floating_point: f64 = 0x103.70p-5;
    // const another_hex_float: f64 = 0x103.70;
    // const yet_another_hex_float: f64 = 0x103.70P-5;
    std.debug.print("{}\n", .{hex_floating_point});
}

test "int-float conversion" {
    const a: i32 = 0;
    const b = @as(f32, @floatFromInt(a));
    const c = @as(i32, @intFromFloat(b));
    try expect(c == a);
}
