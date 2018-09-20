import ../src/libuv, os


proc on_read(req: ptr uv_fs_t) {.cdecl.}


var
  open_req: uv_fs_t
  read_req: uv_fs_t
  write_req: uv_fs_t
  buffer = newString(1024)

  iov: uv_buf_t


proc on_write(req: ptr uv_fs_t) {.cdecl.} =
  if req.result < 0:
    echo "Write error: ", uv_strerror((cint)req.result)
  else:
    discard uv_fs_read(uv_default_loop(), addr read_req, cast[uv_file](open_req.result), addr iov, 1, -1, on_read)


proc on_read(req: ptr uv_fs_t) =
  if req.result < 0:
    echo "Read error: ", uv_strerror((cint)req.result)
  elif req.result == 0:
    var close_req: uv_fs_t
    # synchronous
    discard uv_fs_close(uv_default_loop(), addr close_req, cast[uv_file](open_req.result), nil)
  elif req.result > 0:
    iov.len = int32 req.result
    discard uv_fs_write(uv_default_loop(), addr write_req, 1, addr iov, 1, -1, on_write)


proc on_open(req: ptr uv_fs_t) {.cdecl.} =
  # The request passed to the callback is the same as the one the call setup
  # function was passed.
  assert(req == addr open_req)
  if req.result >= 0:
    iov = uv_buf_init(cstring buffer, cuint buffer.len)
    discard uv_fs_read(uv_default_loop(), addr read_req, cast[uv_file](req.result), addr iov, 1, -1, on_read)
  else:
      echo "Opening error: ", uv_strerror((cint)req.result)


echo paramStr(1)
discard uv_fs_open(uv_default_loop(), addr open_req, paramStr(1), O_RDONLY, 0, on_open)
discard uv_run(uv_default_loop(), UV_RUN_DEFAULT)

uv_fs_req_cleanup(addr open_req)
uv_fs_req_cleanup(addr read_req)
uv_fs_req_cleanup(addr write_req)

