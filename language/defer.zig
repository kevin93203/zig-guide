//defer: execute a statement while exiting the current block.

const expect = @import("std").testing.expect;

test "defer" {
    var x: i16 = 5;
    {
        defer x += 2;
        try expect(x == 5);
    }
    try expect(x == 7);
}

test "multi defer" {
    var x: f32 = 5;
    {
        // multiple defers in a single block, they are executed in reverse order.
        defer x += 2; // secod
        defer x /= 2; // first
    }
    try expect(x == 4.5);
}
