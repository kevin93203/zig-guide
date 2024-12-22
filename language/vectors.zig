const expect = @import("std").testing.expect;
const std = @import("std");
const meta = @import("std").meta;

test "vector add" {
    // Zig provides vector types for SIMD(performing an operation on multiple pieces of data simultaneously)
    // is not dynamic array like C++
    const x: @Vector(4, f32) = .{ 1, -10, 20, -1 };
    const y: @Vector(4, f32) = .{ 2, 10, 0, 1 };
    const z = x + y;
    std.debug.print("{}\n", .{x});
    std.debug.print("{}\n", .{y});
    std.debug.print("{}\n", .{z});
    try expect(meta.eql(z, @Vector(4, f32){ 3, 0, 20, 0 }));
}

test "vector indexing" {
    const x: @Vector(4, u8) = .{ 255, 0, 255, 0 };
    try expect(x[0] == 255);
}

test "vector * scalar" {
    const x: @Vector(3, f32) = .{ 12.5, 37.5, 2.5 };
    const scalar = @as(@Vector(3, f32), @splat(2));
    std.debug.print("{}\n", .{scalar});
    const y = x * scalar;
    try expect(meta.eql(y, @Vector(3, f32){ 25, 75, 5 }));
}

test "vector looping" {
    // Vectors do not have a len field like arrays
    const x = @Vector(4, u8){ 255, 0, 255, 0 };
    const sum = blk: {
        var tmp: u10 = 0;
        var i: u8 = 0;
        // loop over vector
        while (i < 4) : (i += 1) tmp += x[i];
        break :blk tmp;
    };
    try expect(sum == 510);
}

test "vector coerce" {
    const arr: [4]f32 = @Vector(4, f32){ 1, 2, 3, 4 };
    std.debug.print("{d:.2}\n", .{arr});
}
