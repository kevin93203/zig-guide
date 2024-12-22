const expect = @import("std").testing.expect;
const std = @import("std");

fn fibonacci(n: u16) u16 {
    if (n == 0 or n == 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

test "comptime blocks" {
    const x = comptime fibonacci(10);
    const y = comptime blk: {
        break :blk fibonacci(10);
    };
    try expect(y == 55);
    try expect(x == 55);
}

test "comptime_int" {
    const a = 12;
    const b = a + 10;

    const c: u4 = a;
    const d: f32 = b;

    try expect(c == 12);
    try expect(d == 22);
}

test "branching on types" {
    const a = 5;
    const b: if (a < 10) f32 else i32 = 5;
    try expect(b == 5);
    try expect(@TypeOf(b) == f32);
}

fn Matrix(
    comptime T: type,
    comptime height: comptime_int,
    comptime width: comptime_int,
) type {
    return [height][width]T;
}

test "returning a type" {
    const a: usize = 5;
    try expect(Matrix(f32, 4, 4) == [4][4]f32);
    try expect(Matrix(i32, 4, 4) == [4][4]i32);
    try expect(Matrix(i32, a, 4) == [a][4]i32);
}

fn GetBiggerInt(comptime T: type) type {
    return @Type(.{ .Int = .{
        .bits = @typeInfo(T).Int.bits + 1,
        .signedness = @typeInfo(T).Int.signedness,
    } });
}

test "@Type" {
    std.debug.print("{}\n", .{@typeInfo(u32)});
    try expect(GetBiggerInt(u8) == u9);
    try expect(GetBiggerInt(i31) == i32);
}

fn Vec(
    comptime count: comptime_int,
    comptime T: type,
) type {
    return struct {
        data: [count]T,
        const Self = @This();

        fn abs(self: Self) Self {
            var tmp = Self{ .data = undefined };
            for (self.data, 0..) |elem, i| {
                tmp.data[i] = if (elem < 0)
                    -elem
                else
                    elem;
            }
            return tmp;
        }

        fn init(data: [count]T) Self {
            return Self{ .data = data };
        }
    };
}

const eql = @import("std").mem.eql;

test "generic vector" {
    const x = Vec(3, f32).init([_]f32{ 10, -10, 5 });
    const y = x.abs();
    try expect(eql(f32, &y.data, &[_]f32{ 10, 10, 5 }));
}

fn plusOne(x: anytype) @TypeOf(x) {
    return x + 1;
}

test "inferred function parameter" {
    try expect(plusOne(@as(u32, 1)) == 2);
    try expect(plusOne(@as(u32, 2)) == 3);
    try expect(plusOne(@as(f32, 1.0)) == 2.0);
}

test "++" {
    var x: [4]u8 = undefined;
    const y = x[0..];

    const a: [6]u8 = [6]u8{ 4, 5, 6, 7, 8, 9 };
    const b = a[0..];

    var new = y ++ b; // copy y & b then concat
    std.debug.print("{*}\n", .{&x});
    std.debug.print("{*}\n", .{&a});
    std.debug.print("{*}\n", .{&b});
    std.debug.print("{*}\n", .{b.ptr});
    std.debug.print("{*}\n", .{&new});
    std.debug.print("{*}\n", .{new.ptr});
    std.debug.print("{d}\n", .{new});
    new[0] = 1;
    std.debug.print("{d}\n", .{new});
    std.debug.print("{d}\n", .{y});

    try expect(new.len == 10);
}

test "**" {
    const pattern = [_]u8{ 0xCC, 0xAA };
    const memory = pattern ** 3;
    try expect(eql(u8, &memory, &[_]u8{ 0xCC, 0xAA, 0xCC, 0xAA, 0xCC, 0xAA }));
}
