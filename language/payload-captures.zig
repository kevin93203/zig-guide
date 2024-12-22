const expect = @import("std").testing.expect;
const std = @import("std");

test "optional-if" {
    const maybe_num: ?usize = 10;
    if (maybe_num) |n| {
        try expect(@TypeOf(n) == usize);
        try expect(n == 10);
    } else {
        unreachable;
    }
}

test "error union if" {
    const ent_num: error{UnknownEntity}!u32 = error.UnknownEntity;
    if (ent_num) |entity| {
        try expect(@TypeOf(entity) == u32);
        try expect(entity == 5);
    } else |err| {
        std.debug.print("{}\n", .{err catch {}});
        // unreachable;
    }
}

test "while optional" {
    var i: ?u32 = 10;
    while (i) |num| : (i.? -= 1) {
        // std.debug.print("{}\n", .{num});
        try expect(@TypeOf(num) == u32);
        if (num == 1) {
            i = null;
            break;
        }
    }
    try expect(i == null);
}

var number_left2: u32 = undefined;

fn eventuallyErrorSequence() !u32 {
    return if (number_left2 == 0) error.ReachedZero else blk: {
        number_left2 -= 1;
        break :blk number_left2;
    };
}

test "while error union capture" {
    var sum: u32 = 0;
    number_left2 = 3;
    while (eventuallyErrorSequence()) |value| {
        sum += value;
    } else |err| {
        try expect(err == error.ReachedZero);
    }
    std.debug.print("{}\n", .{sum});
}

test "for capture" {
    const x = [_]i8{ 1, 5, 120, -5 };
    for (x) |v| try expect(@TypeOf(v) == i8);
}

const Info = union(enum) {
    a: u32,
    b: []const u8,
    c,
    d: u32,
};

test "switch capture" {
    const b = Info{ .a = 10 };
    const x = switch (b) {
        .b => |str| blk: {
            try expect(@TypeOf(str) == []const u8);
            break :blk 1;
        },
        .c => 2,
        .a, .d => |num| blk: {
            try expect(@TypeOf(num) == u32);
            break :blk num * 2;
        },
    };
    try expect(x == 20);
}

test "for with pointer capture" {
    var data = [_]u8{ 1, 2, 3 };
    for (&data) |*byte| byte.* += 1;
    std.debug.print("{d}\n", .{data});
    try expect(std.mem.eql(u8, &data, &[_]u8{ 2, 3, 4 }));
}
