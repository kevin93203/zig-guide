const expect = @import("std").testing.expect;

fn add_five(x: u32) u32 {
    return x + 5;
}

test "function" {
    const y = add_five(0);
    try expect(@TypeOf((y)));
    try expect(y == 5);
}

fn fibonacci(n: u16) u16 {
    if (n == 0 or n == 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

test "function recursion" {
    const x = fibonacci(10);
    try expect(x == 55);
}
