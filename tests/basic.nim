import ../src/libuv

## Based on: https://nikhilm.github.io/uvbook/basics.html

var loop: uv_loop_t
discard uv_loop_init(addr loop)

echo "Now quitting."
discard uv_run(addr loop, UV_RUN_DEFAULT)

discard uv_loop_close(addr loop)
