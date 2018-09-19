import ../src/libuv

## Based on: https://nikhilm.github.io/uvbook/basics.html

var counter: int64


proc waitForAWhile(handle: ptr uv_idle_t) {.cdecl.} =
  inc counter
  if counter >= 1000000:
    discard uv_idle_stop(handle)


var idler: uv_idle_t
discard uv_idle_init(uv_default_loop(), addr idler)

discard uv_idle_start(addr idler, waitForAWhile)

echo "Idling..."
discard uv_run(uv_default_loop(), UV_RUN_DEFAULT)

discard uv_loop_close(uv_default_loop())
