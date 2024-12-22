const Window = opaque {
    fn show(self: *Window) void {
        show_window(self);
    }
};
const Button = opaque {};

extern fn show_window(*Window) callconv(.C) void;

test "opaque" {
    // const ok_button: *Button = undefined;
    // show_window(ok_button);

    const main_window: *Window = undefined;
    main_window.show();
}
