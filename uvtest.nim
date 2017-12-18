import nimuv

var
  idler: uv_idle_t
  count: int64

proc uv_idle_cb(handle: ptr uv_idle_t) {.cdecl.} =
  count += 1
  echo count
  if count > 9:
    discard uv_idle_stop(handle)
    echo "done !"

discard uv_idle_init(uv_default_loop(), idler.addr)
discard uv_idle_start(idler.addr, uv_idle_cb)

echo "libuv idling test start."
discard uv_run(uv_default_loop(), UV_RUN_DEFAULT)

discard uv_loop_close(uv_default_loop())