import nativesockets, ospaths

const sdkPath = currentSourcePath.parentDir() & "/csources/"

{.passC: "-I " & sdkPath & "include".}
{.passC: "-I " & sdkPath & "src".}
{.passL: "-lws2_32 -lpsapi -liphlpapi -lshell32 -luserenv -luser32".}

{.compile: sdkPath & "src/fs-poll.c".}
{.compile: sdkPath & "src/inet.c".}
{.compile: sdkPath & "src/threadpool.c".}
{.compile: sdkPath & "src/timer.c".}
{.compile: sdkPath & "src/uv-common.c".}
{.compile: sdkPath & "src/uv-data-getter-setters.c".}
{.compile: sdkPath & "src/version.c".}

when defined(windows):
  {.compile: sdkPath & "src/win/async.c".}
  {.compile: sdkPath & "src/win/core.c".}
  {.compile: sdkPath & "src/win/detect-wakeup.c".}
  {.compile: sdkPath & "src/win/dl.c".}
  {.compile: sdkPath & "src/win/error.c".}
  {.compile: sdkPath & "src/win/fs-event.c".}
  {.compile: sdkPath & "src/win/fs.c".}
  {.compile: sdkPath & "src/win/getaddrinfo.c".}
  {.compile: sdkPath & "src/win/getnameinfo.c".}
  {.compile: sdkPath & "src/win/handle.c".}
  {.compile: sdkPath & "src/win/loop-watcher.c".}
  {.compile: sdkPath & "src/win/pipe.c".}
  {.compile: sdkPath & "src/win/poll.c".}
  {.compile: sdkPath & "src/win/process-stdio.c".}
  {.compile: sdkPath & "src/win/process.c".}
  {.compile: sdkPath & "src/win/req.c".}
  {.compile: sdkPath & "src/win/signal.c".}
  {.compile: sdkPath & "src/win/snprintf.c".}
  {.compile: sdkPath & "src/win/stream.c".}
  {.compile: sdkPath & "src/win/tcp.c".}
  {.compile: sdkPath & "src/win/thread.c".}
  {.compile: sdkPath & "src/win/tty.c".}
  {.compile: sdkPath & "src/win/udp.c".}
  {.compile: sdkPath & "src/win/util.c".}
  {.compile: sdkPath & "src/win/winapi.c".}
  {.compile: sdkPath & "src/win/winsock.c".}
else:
  {.compile: sdkPath & "src/unix/async.c".}
  {.compile: sdkPath & "src/unix/core.c".}
  {.compile: sdkPath & "src/unix/detect-wakeup.c".}
  {.compile: sdkPath & "src/unix/dl.c".}
  {.compile: sdkPath & "src/unix/error.c".}
  {.compile: sdkPath & "src/unix/fs-event.c".}
  {.compile: sdkPath & "src/unix/fs.c".}
  {.compile: sdkPath & "src/unix/getaddrinfo.c".}
  {.compile: sdkPath & "src/unix/getnameinfo.c".}
  {.compile: sdkPath & "src/unix/handle.c".}
  {.compile: sdkPath & "src/unix/loop-watcher.c".}
  {.compile: sdkPath & "src/unix/pipe.c".}
  {.compile: sdkPath & "src/unix/poll.c".}
  {.compile: sdkPath & "src/unix/process-stdio.c".}
  {.compile: sdkPath & "src/unix/process.c".}
  {.compile: sdkPath & "src/unix/req.c".}
  {.compile: sdkPath & "src/unix/signal.c".}
  {.compile: sdkPath & "src/unix/snprintf.c".}
  {.compile: sdkPath & "src/unix/stream.c".}
  {.compile: sdkPath & "src/unix/tcp.c".}
  {.compile: sdkPath & "src/unix/thread.c".}
  {.compile: sdkPath & "src/unix/tty.c".}
  {.compile: sdkPath & "src/unix/udp.c".}
  {.compile: sdkPath & "src/unix/util.c".}
  {.compile: sdkPath & "src/unix/unixapi.c".}
  {.compile: sdkPath & "src/unix/unixsock.c".}

when defined(windows):
  import winlean

  type
    uv_pid_t* {.importc.} = cuchar
    uv_uid_t* {.importc.} = cuchar
    uv_gid_t* {.importc.} = cuchar

    uv_buf_t* {.importc} = object
      base*: ptr char
      len*: ULONG

    uv_os_sock_t* {.importc.} = SocketHandle
    uv_os_fd_t* {.importc.} = winlean.Handle
else:
  type
    uv_pid_t* {.importc: "pid_t", header: "<sys/types.h>".} = cint
    uv_uid_t* {.importc: "uid_t", header: "<sys/types.h>".} = cint
    uv_gid_t* {.importc: "gid_t", header: "<sys/types.h>".} = cint

    uv_buf_t* {.importc.} = object
      base*: ptr char
      len*: csize

    uv_os_sock_t* {.importc.} = SocketHandle
    uv_os_fd_t* {.importc.} = cint

#
# UV_ERROR STATE
#

import posix

const
  UV_EOF* = (- 4095)
  UV_UNKNOWN* = (- 4094)
  UV_EAI_ADDRFAMILY* = (- 3000)
  UV_EAI_AGAIN* = (- 3001)
  UV_EAI_BADFLAGS* = (- 3002)
  UV_EAI_CANCELED* = (- 3003)
  UV_EAI_FAIL* = (- 3004)
  UV_EAI_FAMILY* = (- 3005)
  UV_EAI_MEMORY* = (- 3006)
  UV_EAI_NODATA* = (- 3007)
  UV_EAI_NONAME* = (- 3008)
  UV_EAI_OVERFLOW* = (- 3009)
  UV_EAI_SERVICE* = (- 3010)
  UV_EAI_SOCKTYPE* = (- 3011)
  UV_EAI_BADHINTS* = (- 3013)
  UV_EAI_PROTOCOL* = (- 3014)

  O_RDONLY* = 0x0000
  O_WRONLY* = 0x0001
  O_RDWR* = 0x0002
  O_ACCMODE* = 0x0003

# Only map to the system errno on non-Windows platforms. It's apparently
#  a fairly common practice for Windows programmers to redefine errno codes.
#

when defined(E2BIG) and not defined(windows):
  const
    UV_E2BIG* = (- E2BIG)
else:
  const
    UV_E2BIG* = (- 4093)
when defined(EACCES) and not defined(windows):
  const
    UV_EACCES* = (- EACCES)
else:
  const
    UV_EACCES* = (- 4092)
when defined(EADDRINUSE) and not defined(windows):
  const
    UV_EADDRINUSE* = (- EADDRINUSE)
else:
  const
    UV_EADDRINUSE* = (- 4091)
when defined(EADDRNOTAVAIL) and not defined(windows):
  const
    UV_EADDRNOTAVAIL* = (- EADDRNOTAVAIL)
else:
  const
    UV_EADDRNOTAVAIL* = (- 4090)
when defined(EAFNOSUPPORT) and not defined(windows):
  const
    UV_EAFNOSUPPORT* = (- EAFNOSUPPORT)
else:
  const
    UV_EAFNOSUPPORT* = (- 4089)
when defined(EAGAIN) and not defined(windows):
  const
    UV_EAGAIN* = (- EAGAIN)
else:
  const
    UV_EAGAIN* = (- 4088)
when defined(EALREADY) and not defined(windows):
  const
    UV_EALREADY* = (- EALREADY)
else:
  const
    UV_EALREADY* = (- 4084)
when defined(EBADF) and not defined(windows):
  const
    UV_EBADF* = (- EBADF)
else:
  const
    UV_EBADF* = (- 4083)
when defined(EBUSY) and not defined(windows):
  const
    UV_EBUSY* = (- EBUSY)
else:
  const
    UV_EBUSY* = (- 4082)
when defined(ECANCELED) and not defined(windows):
  const
    UV_ECANCELED* = (- ECANCELED)
else:
  const
    UV_ECANCELED* = (- 4081)
when defined(ECHARSET) and not defined(windows):
  const
    UV_ECHARSET* = (- ECHARSET)
else:
  const
    UV_ECHARSET* = (- 4080)
when defined(ECONNABORTED) and not defined(windows):
  const
    UV_ECONNABORTED* = (- ECONNABORTED)
else:
  const
    UV_ECONNABORTED* = (- 4079)
when defined(ECONNREFUSED) and not defined(windows):
  const
    UV_ECONNREFUSED* = (- ECONNREFUSED)
else:
  const
    UV_ECONNREFUSED* = (- 4078)
when defined(ECONNRESET) and not defined(windows):
  const
    UV_ECONNRESET* = (- ECONNRESET)
else:
  const
    UV_ECONNRESET* = (- 4077)
when defined(EDESTADDRREQ) and not defined(windows):
  const
    UV_EDESTADDRREQ* = (- EDESTADDRREQ)
else:
  const
    UV_EDESTADDRREQ* = (- 4076)
when defined(EEXIST) and not defined(windows):
  const
    UV_EEXIST* = (- EEXIST)
else:
  const
    UV_EEXIST* = (- 4075)
when defined(EFAULT) and not defined(windows):
  const
    UV_EFAULT* = (- EFAULT)
else:
  const
    UV_EFAULT* = (- 4074)
when defined(EHOSTUNREACH) and not defined(windows):
  const
    UV_EHOSTUNREACH* = (- EHOSTUNREACH)
else:
  const
    UV_EHOSTUNREACH* = (- 4073)
when defined(EINTR) and not defined(windows):
  const
    UV_EINTR* = (- EINTR)
else:
  const
    UV_EINTR* = (- 4072)
when defined(EINVAL) and not defined(windows):
  const
    UV_EINVAL* = (- EINVAL)
else:
  const
    UV_EINVAL* = (- 4071)
when defined(EIO) and not defined(windows):
  const
    UV_EIO* = (- EIO)
else:
  const
    UV_EIO* = (- 4070)
when defined(EISCONN) and not defined(windows):
  const
    UV_EISCONN* = (- EISCONN)
else:
  const
    UV_EISCONN* = (- 4069)
when defined(EISDIR) and not defined(windows):
  const
    UV_EISDIR* = (- EISDIR)
else:
  const
    UV_EISDIR* = (- 4068)
when defined(ELOOP) and not defined(windows):
  const
    UV_ELOOP* = (- ELOOP)
else:
  const
    UV_ELOOP* = (- 4067)
when defined(EMFILE) and not defined(windows):
  const
    UV_EMFILE* = (- EMFILE)
else:
  const
    UV_EMFILE* = (- 4066)
when defined(EMSGSIZE) and not defined(windows):
  const
    UV_EMSGSIZE* = (- EMSGSIZE)
else:
  const
    UV_EMSGSIZE* = (- 4065)
when defined(ENAMETOOLONG) and not defined(windows):
  const
    UV_ENAMETOOLONG* = (- ENAMETOOLONG)
else:
  const
    UV_ENAMETOOLONG* = (- 4064)
when defined(ENETDOWN) and not defined(windows):
  const
    UV_ENETDOWN* = (- ENETDOWN)
else:
  const
    UV_ENETDOWN* = (- 4063)
when defined(ENETUNREACH) and not defined(windows):
  const
    UV_ENETUNREACH* = (- ENETUNREACH)
else:
  const
    UV_ENETUNREACH* = (- 4062)
when defined(ENFILE) and not defined(windows):
  const
    UV_ENFILE* = (- ENFILE)
else:
  const
    UV_ENFILE* = (- 4061)
when defined(ENOBUFS) and not defined(windows):
  const
    UV_ENOBUFS* = (- ENOBUFS)
else:
  const
    UV_ENOBUFS* = (- 4060)
when defined(ENODEV) and not defined(windows):
  const
    UV_ENODEV* = (- ENODEV)
else:
  const
    UV_ENODEV* = (- 4059)
when defined(ENOENT) and not defined(windows):
  const
    UV_ENOENT* = (- ENOENT)
else:
  const
    UV_ENOENT* = (- 4058)
when defined(ENOMEM) and not defined(windows):
  const
    UV_ENOMEM* = (- ENOMEM)
else:
  const
    UV_ENOMEM* = (- 4057)
when defined(ENONET) and not defined(windows):
  const
    UV_ENONET* = (- ENONET)
else:
  const
    UV_ENONET* = (- 4056)
when defined(ENOSPC) and not defined(windows):
  const
    UV_ENOSPC* = (- ENOSPC)
else:
  const
    UV_ENOSPC* = (- 4055)
when defined(ENOSYS) and not defined(windows):
  const
    UV_ENOSYS* = (- ENOSYS)
else:
  const
    UV_ENOSYS* = (- 4054)
when defined(ENOTCONN) and not defined(windows):
  const
    UV_ENOTCONN* = (- ENOTCONN)
else:
  const
    UV_ENOTCONN* = (- 4053)
when defined(ENOTDIR) and not defined(windows):
  const
    UV_ENOTDIR* = (- ENOTDIR)
else:
  const
    UV_ENOTDIR* = (- 4052)
when defined(ENOTEMPTY) and not defined(windows):
  const
    UV_ENOTEMPTY* = (- ENOTEMPTY)
else:
  const
    UV_ENOTEMPTY* = (- 4051)
when defined(ENOTSOCK) and not defined(windows):
  const
    UV_ENOTSOCK* = (- ENOTSOCK)
else:
  const
    UV_ENOTSOCK* = (- 4050)
when defined(ENOTSUP) and not defined(windows):
  const
    UV_ENOTSUP* = (- ENOTSUP)
else:
  const
    UV_ENOTSUP* = (- 4049)
when defined(EPERM) and not defined(windows):
  const
    UV_EPERM* = (- EPERM)
else:
  const
    UV_EPERM* = (- 4048)
when defined(EPIPE) and not defined(windows):
  const
    UV_EPIPE* = (- EPIPE)
else:
  const
    UV_EPIPE* = (- 4047)
when defined(EPROTO) and not defined(windows):
  const
    UV_EPROTO* = (- EPROTO)
else:
  const
    UV_EPROTO* = (- 4046)
when defined(EPROTONOSUPPORT) and not defined(windows):
  const
    UV_EPROTONOSUPPORT* = (- EPROTONOSUPPORT)
else:
  const
    UV_EPROTONOSUPPORT* = (- 4045)
when defined(EPROTOTYPE) and not defined(windows):
  const
    UV_EPROTOTYPE* = (- EPROTOTYPE)
else:
  const
    UV_EPROTOTYPE* = (- 4044)
when defined(EROFS) and not defined(windows):
  const
    UV_EROFS* = (- EROFS)
else:
  const
    UV_EROFS* = (- 4043)
when defined(ESHUTDOWN) and not defined(windows):
  const
    UV_ESHUTDOWN* = (- ESHUTDOWN)
else:
  const
    UV_ESHUTDOWN* = (- 4042)
when defined(ESPIPE) and not defined(windows):
  const
    UV_ESPIPE* = (- ESPIPE)
else:
  const
    UV_ESPIPE* = (- 4041)
when defined(ESRCH) and not defined(windows):
  const
    UV_ESRCH* = (- ESRCH)
else:
  const
    UV_ESRCH* = (- 4040)
when defined(ETIMEDOUT) and not defined(windows):
  const
    UV_ETIMEDOUT* = (- ETIMEDOUT)
else:
  const
    UV_ETIMEDOUT* = (- 4039)
when defined(ETXTBSY) and not defined(windows):
  const
    UV_ETXTBSY* = (- ETXTBSY)
else:
  const
    UV_ETXTBSY* = (- 4038)
when defined(EXDEV) and not defined(windows):
  const
    UV_EXDEV* = (- EXDEV)
else:
  const
    UV_EXDEV* = (- 4037)
when defined(EFBIG) and not defined(windows):
  const
    UV_EFBIG* = (- EFBIG)
else:
  const
    UV_EFBIG* = (- 4036)
when defined(ENOPROTOOPT) and not defined(windows):
  const
    UV_ENOPROTOOPT* = (- ENOPROTOOPT)
else:
  const
    UV_ENOPROTOOPT* = (- 4035)
when defined(ERANGE) and not defined(windows):
  const
    UV_ERANGE* = (- ERANGE)
else:
  const
    UV_ERANGE* = (- 4034)
when defined(ENXIO) and not defined(windows):
  const
    UV_ENXIO* = (- ENXIO)
else:
  const
    UV_ENXIO* = (- 4033)
when defined(EMLINK) and not defined(windows):
  const
    UV_EMLINK* = (- EMLINK)
else:
  const
    UV_EMLINK* = (- 4032)
# EHOSTDOWN is not visible on BSD-like systems when _POSIX_C_SOURCE is
#  defined. Fortunately, its value is always 64 so it's possible albeit
#  icky to hard-code it.
#

when defined(EHOSTDOWN) and not defined(windows):
  const
    UV_EHOSTDOWN* = (- EHOSTDOWN)
elif not defined(windows):
  const
    UV_EHOSTDOWN* = (- 64)
else:
  const
    UV_EHOSTDOWN* = (- 4031)

#
# TYPE STATE
#

type
  cssize* = int

  FILE* {.importc, header: "stdio.h".}= object

  ###################
  #     uv_loop     #
  ###################
  uv_loop_t* {.importc, noDecl.} = object
    data* : pointer

  uv_run_mode* = enum
    UV_RUN_DEFAULT = 0,
    UV_RUN_ONCE,
    UV_RUN_NOWAIT

  loop_option* = enum
    UV_LOOP_BLOCK_SIGNAL = 0

  uv_walk_cb* = proc(handle: ptr uv_handle_t, arg: pointer) {.cdecl.}

  #####################
  #     uv_handle     #
  #####################
  uv_handle_t* {.importc, noDecl.} = object
    loop* {.importc.}: ptr uv_loop_t
    `type`* {.importc.}: uv_handle_type
    data* : pointer

  uv_handle_type* = enum
    UV_UNKNOWN_HANDLE = 0,
    UV_ASYNC,
    UV_CHECK,
    UV_FS_EVENT,
    UV_FS_POLL,
    UV_HANDLE,
    UV_IDLE,
    UV_NAMED_PIPE,
    UV_POLL,
    UV_PREPARE,
    UV_PROCESS,
    UV_STREAM,
    UV_TCP,
    UV_TIMER,
    UV_TTY,
    UV_UDP,
    UV_SIGNAL,
    UV_FILE,
    UV_HANDLE_TYPE_MAX

  uv_any_handle* {.pure, final, union, importc, header: "uv.h".} = object

  uv_alloc_cb* = proc(handle: ptr uv_handle_t, size: csize, buf: ptr uv_buf_t) {.cdecl.}

  uv_close_cb* = proc(handle: ptr uv_handle_t) {.cdecl.}

  ##################
  #     uv_req     #
  ##################
  uv_req_t* {.importc, noDecl.} = object
    data* : pointer
    `type`* {.importc.} : uv_req_type

  uv_req_type* = enum
    UV_UNKNOWN_REQ = 0,
    UV_REQ,
    UV_CONNECT,
    UV_WRITE,
    UV_SHUTDOWN,
    UV_UDP_SEND,
    UV_FS,
    UV_WORK,
    UV_GETADDRINFO,
    UV_GETNAMEINFO,
    UV_REQ_TYPE_PRIVATE,
    UV_REQ_TYPE_MAX

  uv_any_req* {.pure, final, union, importc, header: "uv.h".} = object

  ####################
  #     uv_timer     #
  ####################
  uv_timer_t* {.importc, noDecl.} = object
    loop* {.importc.}: ptr uv_loop_t
    `type`*{.importc.}: uv_handle_type
    data*: pointer

  uv_timer_cb* = proc(handle: ptr uv_timer_t) {.cdecl.}

  ######################
  #     uv_prepare     #
  ######################
  uv_prepare_t* {.importc, noDecl.} = object
    loop* {.importc.}: ptr uv_loop_t
    `type`* {.importc.}: uv_handle_type
    data* : pointer

  uv_prepare_cb* = proc(handle: ptr uv_prepare_t) {.cdecl.}

  ####################
  #     uv_check     #
  ####################
  uv_check_t* {.importc, noDecl.} = object
    loop* {.importc.}: ptr uv_loop_t
    `type`* {.importc.}: uv_handle_type
    data* : pointer

  uv_check_cb* = proc(handle: ptr uv_check_t) {.cdecl.}

  ###################
  #     uv_idle     #
  ###################
  uv_idle_t* {.importc, noDecl.} = object
    loop* {.importc.}: ptr uv_loop_t
    `type`* {.importc.}: uv_handle_type
    data* : pointer

  uv_idle_cb* = proc(handle: ptr uv_idle_t) {.cdecl.}

  ####################
  #     uv_async     #
  ####################
  uv_async_t* {.importc, noDecl.} = object
    loop* {.importc.}: ptr uv_loop_t
    `type`* {.importc.}: uv_handle_type
    data* : pointer

  uv_async_cb* = proc(handle: ptr uv_async_t) {.cdecl.}

  ###################
  #     uv_poll     #
  ###################
  uv_poll_t* {.importc, noDecl.} = object
    loop* {.importc.}: ptr uv_loop_t
    `type`* {.importc.}: uv_handle_type
    data* : pointer

  uv_poll_cb* = proc(handle: ptr uv_poll_t, status: cint, events: cint) {.cdecl.}

  uv_poll_event* = enum
    UV_READABLE = 1,
    UV_WRITABLE = 2,
    UV_DISCONNECT = 4,
    UV_PRIORITIZED = 8

  #####################
  #     uv_signal     #
  #####################
  uv_signal_t* {.importc, noDecl.} = object
    loop* {.importc.}: ptr uv_loop_t
    `type`* {.importc.}: uv_handle_type
    data* : pointer
    signum* {.importc.}: cint

  uv_signal_cb* = proc(handle: ptr uv_signal_t, signum: cint) {.cdecl.}

  ######################
  #     uv_process     #
  ######################
  uv_process_t* {.importc, noDecl.} = object
    loop* {.importc.}: ptr uv_loop_t
    `type`* {.importc.}: uv_handle_type
    data* : pointer
    pid* {.importc.}: cint

  uv_process_options_t* {.importc, noDecl.} = object
    exit_cb* {.importc.}: uv_exit_cb
    file* {.importc.}: cstring
    args* {.importc.}: cstringArray
    env* {.importc.}: cstringArray
    cwd* {.importc.}: cstring
    flags* {.importc.}: cuint
    stdio_count* {.importc.}: cint
    stdio* {.importc.}: ptr uv_stdio_container_t
    uid* {.importc.}: uv_uid_t
    gid* {.importc.}: uv_gid_t

  uv_process_flags* = enum
    UV_PROCESS_SETUID = 1 shl 0,
    UV_PROCESS_SETGID = 1 shl 1,
    UV_PROCESS_WINDOWS_VERBATIM_ARGUMENTS = 1 shl 2,
    UV_PROCESS_DETACHED = 1 shl 3,
    UV_PROCESS_WINDOWS_HIDE = 1 shl 4

  uv_stdio_container_t* {.importc, noDecl.} = object
    flags* {.importc.}: uv_stdio_flags
    data* {.importc.}: uv_stdio_container_t_data

  uv_stdio_container_t_data* {.pure, final, union, importc, header: "uv.h".} = object
    stream* {.importc.}: ptr uv_stream_t
    fd* {.importc.}: cint

  uv_stdio_flags* = enum
    UV_IGNORE = 0x00,
    UV_CREATE_PIPE = 0x01,
    UV_INHERIT_FD = 0x02,
    UV_INHERIT_STREAM = 0x04,
    UV_READABLE_PIPE = 0x10,
    UV_WRITABLE_PIPE = 0x20

  uv_exit_cb* = proc(handle: ptr uv_process_t, exit_status: int64, term_signal: cint) {.cdecl.}

  #####################
  #     uv_stream     #
  #####################
  uv_stream_t* {.importc, noDecl.} = object
    loop* {.importc.}: ptr uv_loop_t
    `type`* {.importc.}: uv_handle_type
    data* : pointer
    write_queue_size* {.importc.}: csize

  uv_connect_t* {.importc, noDecl.} = object
    `type`* {.importc.}: uv_req_type
    data* : pointer
    handle* {.importc.}: ptr uv_stream_t

  uv_shutdown_t* {.importc, noDecl.} = object
    `type`* {.importc.}: uv_req_type
    data* : pointer
    handle* {.importc.}: ptr uv_stream_t

  uv_write_t* {.importc, noDecl.} = object
    `type`* {.importc.}: uv_req_type
    data* : pointer
    handle* {.importc.}: ptr uv_stream_t
    send_handle* {.importc.}: ptr uv_stream_t

  uv_read_cb* = proc(stream: ptr uv_stream_t, nread: cssize, buf: ptr uv_buf_t) {.cdecl.}
  uv_write_cb* = proc(req: ptr uv_write_t, status: cint) {.cdecl.}
  uv_connect_cb* = proc(req: ptr uv_connect_t, status: cint) {.cdecl.}
  uv_shutdown_cb* = proc(req: ptr uv_shutdown_t, status: cint) {.cdecl.}
  uv_connection_cb* = proc(server: ptr uv_stream_t, status: cint) {.cdecl.}

  ##################
  #     uv_tcp     #
  ##################
  uv_tcp_t* {.importc, noDecl.} = object
    loop* {.importc.}: ptr uv_loop_t
    `type`* {.importc.}: uv_handle_type
    data* : pointer
    write_queue_size* {.importc.}: csize

  ###################
  #     uv_pipe     #
  ###################
  uv_pipe_t* {.importc, noDecl.} = object
    loop* {.importc.}: ptr uv_loop_t
    `type`* {.importc.}: uv_handle_type
    data* : pointer
    write_queue_size* {.importc.}: csize

  ##################
  #     uv_tty     #
  ##################
  uv_tty_t* {.importc, noDecl.} = object
    loop* {.importc.}: ptr uv_loop_t
    `type`* {.importc.}: uv_handle_type
    data* : pointer
    write_queue_size* {.importc.}: csize

  uv_tty_mode_t* = enum
    UV_TTY_MODE_NORMAL,
    UV_TTY_MODE_RAW,
    UV_TTY_MODE_IO

  ##################
  #     uv_udp     #
  ##################
  uv_udp_t* {.importc, noDecl.} = object
    loop* {.importc.}: ptr uv_loop_t
    `type`* {.importc.}: uv_handle_type
    data* : pointer
    send_queue_size* {.importc.}: csize
    send_queue_count* {.importc.}: csize

  uv_udp_send_t* {.importc, noDecl.} = object
    handle* {.importc.}: uv_udp_t

  uv_udp_flags* = enum
    UV_UDP_IPV6ONLY = 1,
    UV_UDP_PARTIAL = 2,
    UV_UDP_REUSEADDR = 4

  uv_udp_send_cb* = proc(req: ptr uv_udp_send_t, status: cint): void {.cdecl.}
  uv_udp_recv_cb* = proc(handle: ptr uv_udp_t, nread: cssize, buf: ptr uv_buf_t, `addr`: ptr nativesockets.SockAddr, flags: cuint): void {.cdecl.}

  uv_membership* = enum
    UV_LEAVE_GROUP = 0,
    UV_JOIN_GROUP

  #######################
  #     uv_fs_event     #
  #######################
  uv_fs_event_t* {.importc, noDecl.} = object
    loop* {.importc.}: ptr uv_loop_t
    `type`* {.importc.}: uv_handle_type
    data* : pointer

  uv_fs_event_cb* = proc(handle: ptr uv_fs_event_t, filename: cstring, events: cint, status: cint): void {.cdecl.}

  uv_fs_event* = enum
    UV_RENAME = 1,
    UV_CHANGE = 2

  uv_fs_event_flags* = enum
    UV_FS_EVENT_WATCH_ENTRY = 1,
    UV_FS_EVENT_STAT = 2,
    UV_FS_EVENT_RECURSIVE = 4

  ######################
  #     uv_fs_poll     #
  ######################
  uv_fs_poll_t* {.importc, noDecl.} = object
    loop* {.importc.}: ptr uv_loop_t
    `type`* {.importc.}: uv_handle_type
    data* : pointer

  uv_fs_poll_cb* = proc(handle: ptr uv_fs_poll_t, status: cint, prev: ptr uv_stat_t, curr: ptr uv_stat_t): void {.cdecl.}

  #################
  #     uv_fs     #
  #################
  uv_fs_t* {.importc, noDecl.} = object
    data* : pointer
    `type`* {.importc.} : uv_req_type
    loop* {.importc.}: ptr uv_loop_t
    fs_type* {.importc.}: uv_fs_type
    path* {.importc.}: cstring
    result* {.importc.}: cssize
    statbuf* {.importc.}: uv_stat_t
    `ptr`* : pointer

  uv_fs_cb* = proc(req: ptr uv_fs_t): void {.cdecl.}

  uv_timespec_t* {.importc, noDecl.} = object
    tv_sec* {.importc.}: clong
    tv_nsec* {.importc.}: clong

  uv_stat_t* {.importc, noDecl.} = object
    st_dev* {.importc.}: uint64
    st_mode* {.importc.}: uint64
    st_nlink* {.importc.}: uint64
    st_uid* {.importc.}: uint64
    st_gid* {.importc.}: uint64
    st_rdev* {.importc.}: uint64
    st_ino* {.importc.}: uint64
    st_size* {.importc.}: uint64
    st_blksize* {.importc.}: uint64
    st_blocks* {.importc.}: uint64
    st_flags* {.importc.}: uint64
    st_gen* {.importc.}: uint64
    st_atim* {.importc.}: uv_timespec_t
    st_mtim* {.importc.}: uv_timespec_t
    st_ctim* {.importc.}: uv_timespec_t
    st_birthtim* {.importc.}: uv_timespec_t

  uv_fs_type* = enum
    UV_FS_UNKNOWN = -1,
    UV_FS_CUSTOM,
    UV_FS_OPEN,
    UV_FS_CLOSE,
    UV_FS_READ,
    UV_FS_WRITE,
    UV_FS_SENDFILE,
    UV_FS_STAT,
    UV_FS_LSTAT,
    UV_FS_FSTAT,
    UV_FS_FTRUNCATE,
    UV_FS_UTIME,
    UV_FS_FUTIME,
    UV_FS_ACCESS,
    UV_FS_CHMOD,
    UV_FS_FCHMOD,
    UV_FS_FSYNC,
    UV_FS_FDATASYNC,
    UV_FS_UNLINK,
    UV_FS_RMDIR,
    UV_FS_MKDIR,
    UV_FS_MKDTEMP,
    UV_FS_RENAME,
    UV_FS_SCANDIR,
    UV_FS_LINK,
    UV_FS_SYMLINK,
    UV_FS_READLINK,
    UV_FS_CHOWN,
    UV_FS_FCHOWN,
    UV_FS_REALPATH,
    UV_FS_COPYFILE

  uv_dirent_type_t* = enum
    UV_DIRENT_UNKNOWN,
    UV_DIRENT_FILE,
    UV_DIRENT_DIR,
    UV_DIRENT_LINK,
    UV_DIRENT_FIFO,
    UV_DIRENT_SOCKET,
    UV_DIRENT_CHAR,
    UV_DIRENT_BLOCK

  uv_dirent_t* {.importc, noDecl.} = object
    name* {.importc.}: cstring
    `type`: uv_dirent_type_t

  ###################
  #     uv_work     #
  ###################
  uv_work_t* {.importc, noDecl.} = object
    data* : pointer
    `type`* {.importc.} : uv_req_type
    loop* {.importc.}: ptr uv_loop_t

  uv_work_cb* = proc(req: ptr uv_work_t): void {.cdecl.}

  uv_after_work_cb* = proc(req: ptr uv_work_t, status: cint): void {.cdecl.}

  ##################
  #     uv_dns     #
  ##################
  uv_getaddrinfo_t* {.importc, noDecl.} = object
    data* : pointer
    `type`* {.importc.}: uv_req_type
    loop* {.importc.}: ptr uv_loop_t
    addrinfo* {.importc.}: ptr nativesockets.Addrinfo

  uv_getaddrinfo_cb* = proc(req: ptr uv_getaddrinfo_t, status: cint, res: ptr nativesockets.Addrinfo): void {.cdecl.}

  uv_getnameinfo_t* {.importc, noDecl.} = object
    data* : pointer
    `type`* {.importc.}: uv_req_type
    loop* {.importc.}: ptr uv_loop_t
    addrinfo* {.importc.}: ptr nativesockets.Addrinfo

  uv_getnameinfo_cb* = proc(req: ptr uv_getnameinfo_t, status: cint, hostname: cstring, service: cstring): void {.cdecl.}

  ##################
  #     uv_lib     #
  ##################
  uv_lib_t* {.importc, noDecl.} = object
    data*: pointer

  #####################
  #     uv_thread     #
  #####################
  uv_thread_t* {.importc, noDecl.} = object
    data*: pointer

  uv_thread_cb* = proc(arg: pointer): void {.cdecl.}

  uv_key_t* {.importc, noDecl.} = object
    data*: pointer

  uv_once_t* {.importc, noDecl.} = object
    data*: pointer

  uv_mutex_t* {.importc, noDecl.} = object
    data*: pointer

  uv_rwlock_t* {.importc, noDecl.} = object
    data*: pointer

  uv_sem_t* {.importc, noDecl.} = object
    data*: pointer

  uv_cond_t* {.importc, noDecl.} = object
    data*: pointer

  uv_barrier_t* {.importc, noDecl.} = object
    data*: pointer

  ###################
  #     uv_misc     #
  ###################
  uv_file* {.importc.} = cint

  uv_malloc_func* = proc(size: csize): pointer {.cdecl.}
  uv_realloc_func* = proc(`ptr`: pointer, size: csize): pointer {.cdecl.}
  uv_calloc_func* = proc(count: csize, size: csize): pointer {.cdecl.}
  uv_free_func* = proc(`ptr`: pointer): void {.cdecl.}

  uv_timeval_t*  {.importc.}  = object
    tv_sec*{.importc.}: clong
    tv_usec*{.importc.}: clong

  uv_rusage_t* {.importc, noDecl.} = object
    ru_utime*{.importc.}: uv_timeval_t
    ru_stime*{.importc.}: uv_timeval_t
    ru_maxrss*{.importc.}: uint64
    ru_ixrss*{.importc.}: uint64
    ru_idrss*{.importc.}: uint64
    ru_isrss*{.importc.}: uint64
    ru_minflt*{.importc.}: uint64
    ru_majflt*{.importc.}: uint64
    ru_nswap*{.importc.}: uint64
    ru_inblock*{.importc.}: uint64
    ru_oublock*{.importc.}: uint64
    ru_msgsnd*{.importc.}: uint64
    ru_msgrcv*{.importc.}: uint64
    ru_nsignal*{.importc.}: uint64
    ru_nvcsw*{.importc.}: uint64
    ru_nivcsw*{.importc.}: uint64

  uv_cpu_times_s* {.importc, noDecl.} = object
    user* {.importc.}: uint64
    nice* {.importc.}: uint64
    sys* {.importc.}: uint64
    idle* {.importc.}: uint64
    irq* {.importc.}: uint64

  uv_cpu_info_t* {.importc, noDecl.} = object
    model* {.importc.}: cstring
    speed* {.importc.}: cint
    cpu_times* {.importc.}: uv_cpu_times_s

  address* {.pure, final, union, importc, header: "uv.h".} = object
    address4* {.importc.}: nativesockets.Sockaddr_in
    address6* {.importc.}: nativesockets.Sockaddr_in6

  netmask* {.pure, final, union, importc, header: "uv.h".} = object
    netmask4* {.importc.}: nativesockets.Sockaddr_in
    netmask6* {.importc.}: nativesockets.Sockaddr_in6

  uv_interface_address_t {.importc, noDecl.} = object
    name* {.importc.}: cstring
    phys_addr* {.importc.}: array[6, cchar]
    is_internal* {.importc.}: cint
    address* {.importc.}: address
    netmask* {.importc.}: netmask

  uv_passwd_t* {.pure, final, union, importc, header: "uv.h".} = object
    username*: cstring
    uid*: clong
    gid*: clong
    shell*: cstring
    homedir*: cstring

#
# PROC STATE
#
####################
#     uv_error     #
####################
proc uv_strerror*(err: cint): cstring {.importc, noDecl.}
proc uv_err_name*(err: cint): cstring {.importc, noDecl.}
proc uv_translate_sys_error*(sys_errno: cint): cint  {.importc, noDecl.}

###################
#     uv_loop     #
###################
proc uv_loop_init*(loop: ptr uv_loop_t): cint {.importc, noDecl.}
proc uv_loop_configure*(loop: ptr uv_loop_t, option: loop_option): cint {.importc, noDecl.}
proc uv_loop_close*(loop: ptr uv_loop_t): cint {.importc, noDecl.}
proc uv_default_loop*(): ptr uv_loop_t {.importc, noDecl.}
proc uv_run*(loop: ptr uv_loop_t, mode: uv_run_mode): cint {.importc, cdecl, header:"uv.h".}
proc uv_loop_alive*(loop: ptr uv_loop_t): cint {.importc, noDecl.}
proc uv_stop*(loop: ptr uv_loop_t): void {.importc, noDecl.}
proc uv_loop_size*(): csize {.importc, noDecl.}
proc uv_backend_fd*(loop: ptr uv_loop_t): cint {.importc, noDecl.}
proc uv_backend_timeout*(loop: ptr uv_loop_t): cint {.importc, noDecl.}
proc uv_now*(loop: ptr uv_loop_t): uint64 {.importc, noDecl.}
proc uv_update_time*(loop: ptr uv_loop_t): void {.importc, noDecl.}
proc uv_walk*(loop: ptr uv_loop_t, walk_cb: uv_walk_cb, arg: pointer): cint {.importc, noDecl.}
proc uv_loop_fork*(loop: ptr uv_loop_t): cint {.importc, noDecl.}
proc uv_loop_get_data*(loop: ptr uv_loop_t): pointer {.importc, noDecl.}
proc uv_loop_set_data*(loop: ptr uv_loop_t, data: pointer): pointer {.importc, noDecl.}
#####################
#     uv_handle     #
#####################
proc uv_is_active*(handle: ptr uv_handle_t): cint {.importc, noDecl.}
proc uv_is_closing*(handle: ptr uv_handle_t): cint {.importc, noDecl.}
proc uv_close*(handle: ptr uv_handle_t, close_cb: uv_close_cb): void {.importc, noDecl.}
proc uv_ref*(handle: ptr uv_handle_t): void {.importc, noDecl.}
proc uv_unref*(handle: ptr uv_handle_t): void {.importc, noDecl.}
proc uv_has_ref*(handle: ptr uv_handle_t): cint {.importc, noDecl.}
proc uv_handle_size*(`type`: ptr uv_handle_type): csize {.importc, noDecl.}
proc uv_send_buffer_size*(handle: ptr uv_handle_t, value: ptr cint): cint {.importc, noDecl.}
proc uv_recv_buffer_size*(handle: ptr uv_handle_t, value: ptr cint): cint {.importc, noDecl.}
proc uv_fileno*(handle: ptr uv_handle_t, fd: ptr uv_os_fd_t): cint {.importc, noDecl.}
proc uv_handle_get_loop*(handle: ptr uv_handle_t): ptr uv_loop_t {.importc, noDecl.}
proc uv_handle_get_data*(handle: ptr uv_handle_t): pointer {.importc, noDecl.}
proc uv_handle_set_data*(handle: ptr uv_handle_t, data: pointer): pointer {.importc, noDecl.}
proc uv_handle_get_type*(handle: ptr uv_handle_t): uv_handle_type {.importc, noDecl.}
proc uv_handle_type_name*(`type`: uv_handle_type): cstring {.importc, noDecl.}
##################
#     uv_req     #
##################
proc uv_cancel*(req: ptr uv_req_t): cint {.importc, noDecl.}
proc uv_req_size*(req: uv_req_t): csize {.importc, noDecl.}
proc uv_req_get_data*(req: ptr uv_req_t): pointer {.importc, noDecl.}
proc uv_req_set_data*(req: ptr uv_req_t, data: pointer): pointer {.importc, noDecl.}
proc uv_req_get_type*(req: ptr uv_req_t): uv_req_type {.importc, noDecl.}
proc uv_req_type_name*(`type`: uv_req_type): cstring {.importc, noDecl.}
####################
#     uv_timer     #
####################
proc uv_timer_init*(loop: ptr uv_loop_t, handle: ptr uv_timer_t): cint {.importc, noDecl.}
proc uv_timer_start*(handle: ptr uv_timer_t, cb: uv_timer_cb, timeout: uint64, repeat: uint64): cint {.importc, noDecl.}
proc uv_timer_stop*(handle: ptr uv_timer_t): cint {.importc, noDecl.}
proc uv_timer_again*(handle: ptr uv_timer_t): cint {.importc, noDecl.}
proc uv_timer_set_repeat*(handle: ptr uv_timer_t, repeat: uint64): void {.importc, noDecl.}
proc uv_timer_get_repeat*(handle: ptr uv_timer_t): uint64 {.importc, noDecl.}
######################
#     uv_prepare     #
######################
proc uv_prepare_init*(loop: ptr uv_loop_t, prepare: ptr uv_prepare_t): cint {.importc, noDecl.}
proc uv_prepare_start*(prepare: ptr uv_prepare_t, cb: uv_prepare_cb): cint {.importc, noDecl.}
proc uv_prepare_stop*(prepare: ptr uv_prepare_t): cint {.importc, noDecl.}
####################
#     uv_check     #
####################
proc uv_check_init*(loop: ptr uv_loop_t, check: ptr uv_check_t): cint {.importc, noDecl.}
proc uv_check_start*(check: ptr uv_check_t, cb: uv_check_cb): cint {.importc, noDecl.}
proc uv_check_stop*(check: ptr uv_check_t): cint {.importc, noDecl.}
###################
#     uv_idle     #
###################
proc uv_idle_init*(loop: ptr uv_loop_t, idle: ptr uv_idle_t): cint {.importc, noDecl.}
proc uv_idle_start*(idle: ptr uv_idle_t, cb: uv_idle_cb): cint {.importc, noDecl.}
proc uv_idle_stop*(idle: ptr uv_idle_t): cint {.importc, noDecl.}
####################
#     uv_async     #
####################
proc uv_async_init*(loop: ptr uv_loop_t, async: ptr uv_async_t, async_cb: uv_async_cb): cint {.importc, noDecl.}
proc uv_async_send*(async: ptr uv_async_t): cint {.importc, noDecl.}
###################
#     uv_poll     #
###################
proc uv_poll_init*(loop: ptr uv_loop_t, handle: ptr uv_poll_t, fd: cint): cint {.importc, noDecl.}
proc uv_poll_init_socket*(loop: ptr uv_loop_t, handle: ptr uv_poll_t, socket: uv_os_sock_t): cint {.importc, noDecl.}
proc uv_poll_start*(handle: ptr uv_poll_t, events: cint, cb: uv_poll_cb): cint {.importc, noDecl.}
proc uv_poll_stop*(poll: ptr uv_poll_t): cint {.importc, noDecl.}
#####################
#     uv_signal     #
#####################
proc uv_signal_init*(loop: ptr uv_loop_t, signal: ptr uv_signal_t): cint {.importc, noDecl.}
proc uv_signal_start_oneshot*(signal: ptr uv_signal_t, cb: uv_signal_cb, signum: cint): cint {.importc, noDecl.}
proc uv_signal_start*(signal: ptr uv_signal_t, cb: uv_signal_cb, signum: cint): cint {.importc, noDecl.}
proc uv_signal_stop*(signal: ptr uv_signal_t): cint {.importc, noDecl.}
######################
#     uv_process     #
######################
proc uv_disable_stdio_inheritance*(): void {.importc, noDecl.}
proc uv_spawn*(loop: ptr uv_loop_t, handle: ptr uv_process_t, options: uv_process_options_t): cint {.importc, noDecl.}
proc uv_process_kill*(handle: ptr uv_process_t, signum: cint): cint {.importc, noDecl.}
proc uv_kill*(pid: cint, signum: cint): cint {.importc, noDecl.}
proc uv_process_get_pid*(handle: ptr uv_process_t): uv_pid_t {.importc, noDecl.}
#####################
#     uv_stream     #
#####################
proc uv_shutdown*(req: ptr uv_shutdown_t, handle: ptr uv_stream_t, cb: uv_shutdown_cb): cint {.importc, noDecl.}
proc uv_listen*(stream: ptr uv_stream_t, backlog: cint, cb: uv_connection_cb): cint {.importc, noDecl.}
proc uv_accept*(server: ptr uv_stream_t, client: ptr uv_stream_t): cint {.importc, noDecl.}
proc uv_read_start*(stream: ptr uv_stream_t, alloc_cb: uv_alloc_cb, read_cb: uv_read_cb): cint {.importc, noDecl.}
proc uv_read_stop*(stream: ptr uv_stream_t): cint {.importc, noDecl.}
proc uv_write*(req: ptr uv_write_t, handle: ptr uv_stream_t, bufs: ptr uv_buf_t, nbufs: cuint, cb: uv_write_cb): cint {.importc, noDecl.}
proc uv_write2*(req: ptr uv_write_t, handle: ptr uv_stream_t, bufs: ptr uv_buf_t, nbufs: cuint, send_handle: ptr uv_stream_t, cb: uv_write_cb): cint {.importc, noDecl.}
proc uv_try_write*(handle: ptr uv_stream_t, bufs: ptr uv_buf_t, nbufs: cuint): cint {.importc, noDecl.}
proc uv_is_readable*(handle: ptr uv_stream_t): cint {.importc, noDecl.}
proc uv_is_writable*(handle: ptr uv_stream_t): cint {.importc, noDecl.}
proc uv_stream_set_blocking*(handle: ptr uv_stream_t, blocking: cint): cint {.importc, noDecl.}
proc uv_stream_get_write_queue_size*(stream: ptr uv_stream_t): csize {.importc, noDecl.}
##################
#     uv_tcp     #
##################
proc uv_tcp_init*(loop: ptr uv_loop_t, handle: ptr uv_tcp_t): cint {.importc, noDecl.}
proc uv_tcp_init_ex*(loop: ptr uv_loop_t, handle: ptr uv_tcp_t, flags: cuint): cint {.importc, noDecl.}
proc uv_tcp_open*(handle: ptr uv_tcp_t, sock: uv_os_sock_t): cint {.importc, noDecl.}
proc uv_tcp_nodelay*(handle: ptr uv_tcp_t, enable: cint): cint {.importc, noDecl.}
proc uv_tcp_keepalive*(handle: ptr uv_tcp_t, enable: cint, delay: cuint): cint {.importc, noDecl.}
proc uv_tcp_simultaneous_accepts*(handle: ptr uv_tcp_t, enable: cint): cint {.importc, noDecl.}
proc uv_tcp_bind*(handle: ptr uv_tcp_t, `addr`: ptr nativesockets.SockAddr, flags: cuint): cint {.importc, noDecl.}
proc uv_tcp_getsockname*(handle: ptr uv_tcp_t, name: ptr nativesockets.SockAddr, namelen: cint): cint {.importc, noDecl.}
proc uv_tcp_getpeername*(handle: ptr uv_tcp_t, name: ptr nativesockets.SockAddr, namelen: cint): cint {.importc, noDecl.}
proc uv_tcp_connect*(req: ptr uv_connect_t, handle: ptr uv_tcp_t, name: ptr nativesockets.SockAddr, cb: uv_connect_cb): cint {.importc, noDecl.}
###################
#     uv_pipe     #
###################
proc uv_pipe_init*(loop: ptr uv_loop_t, handle: ptr uv_pipe_t, ipc: cint): cint {.importc, noDecl.}
proc uv_pipe_open*(handle: ptr uv_pipe_t, file: uv_file): cint {.importc, noDecl.}
proc uv_pipe_bind*(handle: ptr uv_pipe_t, name: cstring): cint {.importc, noDecl.}
proc uv_pipe_connect*(req: ptr uv_connect_t, handle: ptr uv_pipe_t, name: cstring, cb: uv_connect_cb): void {.importc, noDecl.}
proc uv_pipe_getsockname*(handle: ptr uv_pipe_t, buffer: cstring, size: var ptr csize): cint {.importc, noDecl.}
proc uv_pipe_getpeername*(handle: ptr uv_pipe_t, buffer: cstring, size: var ptr csize): cint {.importc, noDecl.}
proc uv_pipe_pending_instances*(handle: ptr uv_pipe_t, count: cint): void {.importc, noDecl.}
proc uv_pipe_pending_count*(handle: ptr uv_pipe_t): cint {.importc, noDecl.}
proc uv_pipe_pending_type*(handle: ptr uv_pipe_t): uv_handle_type {.importc, noDecl.}
proc uv_pipe_chmod*(handle: ptr uv_pipe_t, flags: cint): cint {.importc, noDecl.}
##################
#     uv_tty     #
##################
proc uv_tty_init*(loop: ptr uv_loop_t, handle: ptr uv_tty_t, readable: cint): cint {.importc, noDecl.}
proc uv_tty_set_mode*(handle: ptr uv_tty_t, mode: uv_tty_mode_t): cint {.importc, noDecl.}
proc uv_tty_reset_mode*(): cint {.importc, noDecl.}
proc uv_tty_get_winsize*(handle: ptr uv_tty_t, width: var ptr cint, height: var ptr cint): cint {.importc, noDecl.}
##################
#     uv_udp     #
##################
proc uv_udp_init*(loop: ptr uv_loop_t, handle: ptr uv_udp_t): cint {.importc, noDecl.}
proc uv_udp_init_ex*(loop: ptr uv_loop_t, handle: ptr uv_udp_t, flags: cuint): cint {.importc, noDecl.}
proc uv_udp_open*(handle: ptr uv_udp_t, sock: uv_os_sock_t): cint {.importc, noDecl.}
proc uv_udp_bind*(handle: ptr uv_udp_t, `aadr`: ptr nativesockets.SockAddr, flags: cuint): cint {.importc, noDecl.}
proc uv_udp_getsockname*(handle: ptr uv_udp_t, name: ptr nativesockets.SockAddr, namelen: var ptr cint): cint {.importc, noDecl.}
proc uv_udp_set_membership*(handle: ptr uv_udp_t, multicast_addr: cstring, interface_addr: cstring, membership: uv_membership): cint {.importc, noDecl.}
proc uv_udp_set_multicast_loop*(handle: ptr uv_udp_t, on: cint): cint {.importc, noDecl.}
proc uv_udp_set_multicast_ttl*(handle: ptr uv_udp_t, ttl: cint): cint {.importc, noDecl.}
proc uv_udp_set_broadcast*(handle: ptr uv_udp_t, on: cint): cint {.importc, noDecl.}
proc uv_udp_set_ttl*(handle: ptr uv_udp_t, ttl: cint): cint {.importc, noDecl.}
proc uv_udp_send*(req: ptr uv_udp_send_t, handle: ptr uv_udp_t, bufs: ptr uv_buf_t, nbufs: cuint, `addr`: ptr nativesockets.SockAddr, send_cd: uv_udp_send_cb): cint {.importc, noDecl.}
proc uv_udp_try_send*(handle: ptr uv_udp_t, bufs: ptr uv_buf_t, nbufs: cuint, `addr`: ptr nativesockets.SockAddr): cint {.importc, noDecl.}
proc uv_udp_recv_start*(handle: ptr uv_udp_t, alloc_cb: uv_alloc_cb, recv_cb: uv_udp_recv_cb): cint {.importc, noDecl.}
proc uv_udp_get_send_queue_size*(handle: ptr uv_udp_t): csize {.importc, noDecl.}
proc uv_udp_get_send_queue_count*(handle: ptr uv_udp_t): csize {.importc, noDecl.}
#######################
#     uv_fs_event     #
#######################
proc uv_fs_event_init*(loop: ptr uv_loop_t, handle: ptr uv_fs_event_t): cint {.importc, noDecl.}
proc uv_fs_event_start*(handle: ptr uv_fs_event_t, cb: uv_fs_event_cb, path: cstring, flags: cuint): cint {.importc, noDecl.}
proc uv_fs_event_stop*(handle: ptr uv_fs_event_t): cint {.importc, noDecl.}
proc uv_fs_event_getpath*(handle: ptr uv_fs_event_t, buffer: cstring, size: ptr csize): cint {.importc, noDecl.}
######################
#     uv_fs_poll     #
######################
proc uv_fs_poll_init*(loop: ptr uv_loop_t, handle: ptr uv_fs_poll_t): cint {.importc, noDecl.}
proc uv_fs_poll_start*(handle: ptr uv_fs_poll_t, cb: uv_fs_poll_cb, path: cstring, interval: cuint): cint {.importc, noDecl.}
proc uv_fs_poll_stop*(handle: ptr uv_fs_poll_t): cint {.importc, noDecl.}
proc uv_fs_poll_getpath*(handle: ptr uv_fs_poll_t, buffer: cstring, size: ptr csize): cint {.importc, noDecl.}
#################
#     uv_fs     #
#################
proc uv_fs_req_cleanup*(req: ptr uv_fs_t): void {.importc, noDecl.}
proc uv_fs_close*(loop: ptr uv_loop_t, req: ptr uv_fs_t, file: uv_file, cb: uv_fs_cb): cint {.importc, noDecl.}
proc uv_fs_open*(loop: ptr uv_loop_t, req: ptr uv_fs_t, path: cstring, flags: cint, mode: cint, cb: uv_fs_cb): cint {.importc, noDecl.}
proc uv_fs_read*(loop: ptr uv_loop_t, req: ptr uv_fs_t, file: uv_file, bufs: ptr uv_buf_t, nbufs: cuint, offset: int64, cb: uv_fs_cb): cint {.importc, noDecl.}
proc uv_fs_unlink*(loop: ptr uv_loop_t, req: ptr uv_fs_t, path: cstring, cb: uv_fs_cb): cint {.importc, noDecl.}
proc uv_fs_write*(loop: ptr uv_loop_t, req: ptr uv_fs_t, file: uv_file, bufs: ptr uv_buf_t, nbufs: cuint, offset: int64, cb: uv_fs_cb): cint {.importc, noDecl.}
proc uv_fs_mkdir*(loop: ptr uv_loop_t, req: ptr uv_fs_t, path: cstring, mode: cint, cb: uv_fs_cb): cint {.importc, noDecl.}
proc uv_fs_mkdtemp*(loop: ptr uv_loop_t, req: ptr uv_fs_t, tpl: cstring, cb: uv_fs_cb): cint {.importc, noDecl.}
proc uv_fs_rmdir*(loop: ptr uv_loop_t, req: ptr uv_fs_t, path: cstring, cb: uv_fs_cb): cint {.importc, noDecl.}
proc uv_fs_scandir*(loop: ptr uv_loop_t, req: ptr uv_fs_t, path: cstring, flags: cint, cb: uv_fs_cb): cint {.importc, noDecl.}
proc uv_fs_scandir_next*(req: ptr uv_fs_t, ent: ptr uv_dirent_t): cint {.importc, noDecl.}
proc uv_fs_stat*(loop: ptr uv_loop_t, req: ptr uv_fs_t, path: cstring, cb: uv_fs_cb): cint {.importc, noDecl.}
proc uv_fs_fstat*(loop: ptr uv_loop_t, req: ptr uv_fs_t, file: uv_file, cb: uv_fs_cb): cint {.importc, noDecl.}
proc uv_fs_lstat*(loop: ptr uv_loop_t, req: ptr uv_fs_t, path: cstring, cb: uv_fs_cb): cint {.importc, noDecl.}
proc uv_fs_rename*(loop: ptr uv_loop_t, req: ptr uv_fs_t, path: cstring, newpath: cstring, cb: uv_fs_cb): cint {.importc, noDecl.}
proc uv_fs_fsync*(loop: ptr uv_loop_t, req: ptr uv_fs_t, file: uv_file, cb: uv_fs_cb): cint {.importc, noDecl.}
proc uv_fs_fdatasync*(loop: ptr uv_loop_t, req: ptr uv_fs_t, file: uv_file, cb: uv_fs_cb): cint {.importc, noDecl.}
proc uv_fs_ftruncate*(loop: ptr uv_loop_t, req: ptr uv_fs_t, file: uv_file, offset: int64, cb: uv_fs_cb): cint {.importc, noDecl.}
proc uv_fs_copyfile*(loop: ptr uv_loop_t, req: ptr uv_fs_t, path: cstring, newpath: cstring, flags: cint, cb: uv_fs_cb): cint {.importc, noDecl.}
proc uv_fs_sendfile*(loop: ptr uv_loop_t, req: ptr uv_fs_t, in_fd: uv_file, out_fd: uv_file, in_offset: int64, length: csize, cb: uv_fs_cb): cint {.importc, noDecl.}
proc uv_fs_access*(loop: ptr uv_loop_t, req: ptr uv_fs_t, path: cstring, mode: cint, cb: uv_fs_cb): cint {.importc, noDecl.}
proc uv_fs_chmod*(loop: ptr uv_loop_t, req: ptr uv_fs_t, path: cstring, mode: cint, cb: uv_fs_cb): cint {.importc, noDecl.}
proc uv_fs_fchmod*(loop: ptr uv_loop_t, req: ptr uv_fs_t, file: uv_file, mode: cint, cb: uv_fs_cb): cint {.importc, noDecl.}
proc uv_fs_utime*(loop: ptr uv_loop_t, req: ptr uv_fs_t, path: cstring, atime: cdouble, mtime: cdouble, cb: uv_fs_cb): cint {.importc, noDecl.}
proc uv_fs_futime*(loop: ptr uv_loop_t, req: ptr uv_fs_t, file: uv_file, atime: cdouble, mtime: cdouble, cb: uv_fs_cb): cint {.importc, noDecl.}
proc uv_fs_link*(loop: ptr uv_loop_t, req: ptr uv_fs_t, path: cstring, newpath: cstring, cb: uv_fs_cb): cint {.importc, noDecl.}
proc uv_fs_symlink*(loop: ptr uv_loop_t, req: ptr uv_fs_t, path: cstring, newpath: cstring, flags: cint, cb: uv_fs_cb): cint {.importc, noDecl.}
proc uv_fs_readlink*(loop: ptr uv_loop_t, req: ptr uv_fs_t, path: cstring, cb: uv_fs_cb): cint {.importc, noDecl.}
proc uv_fs_realpath*(loop: ptr uv_loop_t, req: ptr uv_fs_t, path: cstring, cb: uv_fs_cb): cint {.importc, noDecl.}
proc uv_fs_chown*(loop: ptr uv_loop_t, req: ptr uv_fs_t, path: cstring, uid: uv_uid_t, gid: uv_gid_t, cb: uv_fs_cb): cint {.importc, noDecl.}
proc uv_fs_chown*(loop: ptr uv_loop_t, req: ptr uv_fs_t, file: uv_file, uid: uv_uid_t, gid: uv_gid_t, cb: uv_fs_cb): cint {.importc, noDecl.}
proc uv_fs_get_type*(req: ptr uv_fs_t): uv_fs_type {.importc, noDecl.}
proc uv_fs_get_result*(req: ptr uv_fs_t): cssize {.importc, noDecl.}
proc uv_fs_get_ptr*(req: ptr uv_fs_t): pointer {.importc, noDecl.}
proc uv_fs_get_path*(req: ptr uv_fs_t): cstring {.importc, noDecl.}
proc uv_fs_get_statbuf*(req: ptr uv_fs_t): ptr uv_stat_t {.importc, noDecl.}
###################
#     uv_work     #
###################
proc uv_queue_work*(loop: ptr uv_loop_t, req: ptr uv_work_t, work_cb: uv_work_cb, after_work_cb: uv_after_work_cb): cint {.importc, noDecl.}
##################
#     uv_dns     #
##################
proc uv_getaddrinfo*(loop: ptr uv_loop_t, req: ptr uv_getaddrinfo_t, getaddrinfo_cb: uv_getaddrinfo_cb, node: cstring, service: cstring, hints: ptr nativesockets.Addrinfo): cint {.importc, noDecl.}
proc uv_freeaddrinfo*(ai: ptr nativesockets.Addrinfo): void {.importc, noDecl.}
proc uv_getnameinfo*(loop: ptr uv_loop_t, req: ptr uv_getnameinfo_t, getnameinfo_cb: uv_getnameinfo_cb, `addr`: ptr nativesockets.SockAddr, flags: cint): cint {.importc, noDecl.}
##################
#     uv_lib     #
##################
proc uv_dlopen*(filename: cstring, lib: ptr uv_lib_t): cint {.importc, noDecl.}
proc uv_dlclose*(lib: ptr uv_lib_t): void {.importc, noDecl.}
proc uv_dlsym*(lib: ptr uv_lib_t, name: cstring, `ptr`: ptr pointer): cint {.importc, noDecl.}
proc uv_dlerror*(lib: ptr uv_lib_t): cstring {.importc, noDecl.}
#####################
#     uv_thread     #
#####################
proc uv_thread_create*(tid: ptr uv_thread_t, entry: uv_thread_cb, arg: pointer): cint {.importc, noDecl.}
proc uv_thread_self*(): uv_thread_t {.importc, noDecl.}
proc uv_thread_join*(tid: ptr uv_thread_t): cint {.importc, noDecl.}
proc uv_thread_equal*(t1: ptr uv_thread_t, t2: ptr uv_thread_t): cint {.importc, noDecl.}
proc uv_key_create*(key: ptr uv_key_t): cint {.importc, noDecl.}
proc uv_key_delete*(key: ptr uv_key_t): void {.importc, noDecl.}
proc uv_key_get*(key: ptr uv_key_t): void {.importc, noDecl.}
proc uv_key_set*(key: ptr uv_key_t, value: pointer): void {.importc, noDecl.}
proc uv_once*(guard: ptr uv_once_t, callback: proc() {.cdecl.}): void {.importc, noDecl.}
proc uv_mutex_init*(handle: ptr uv_mutex_t): cint {.importc, noDecl.}
proc uv_mutex_init_recursive*(handle: ptr uv_mutex_t): cint {.importc, noDecl.}
proc uv_mutex_destroy*(handle: ptr uv_mutex_t): void {.importc, noDecl.}
proc uv_mutex_lock*(handle: ptr uv_mutex_t): void {.importc, noDecl.}
proc uv_mutex_trylock*(handle: ptr uv_mutex_t): cint {.importc, noDecl.}
proc uv_mutex_unlock*(handle: ptr uv_mutex_t): void {.importc, noDecl.}
proc uv_rwlock_init*(rwlock: ptr uv_rwlock_t): cint {.importc, noDecl.}
proc uv_rwlock_destroy*(rwlock: ptr uv_rwlock_t): void {.importc, noDecl.}
proc uv_rwlock_rdlock*(rwlock: ptr uv_rwlock_t): void {.importc, noDecl.}
proc uv_rwlock_tryrdlock*(rwlock: ptr uv_rwlock_t): cint {.importc, noDecl.}
proc uv_rwlock_rdunlock*(rwlock: ptr uv_rwlock_t): void {.importc, noDecl.}
proc uv_rwlock_wrlock*(rwlock: ptr uv_rwlock_t): void {.importc, noDecl.}
proc uv_rwlock_trywrlock*(rwlock: ptr uv_rwlock_t): cint {.importc, noDecl.}
proc uv_rwlock_wrunlock*(rwlock: ptr uv_rwlock_t): void {.importc, noDecl.}
proc uv_sem_init*(sem: ptr uv_sem_t, value: cuint): cint {.importc, noDecl.}
proc uv_sem_destroy*(sem: ptr uv_sem_t): void {.importc, noDecl.}
proc uv_sem_post*(sem: ptr uv_sem_t): void {.importc, noDecl.}
proc uv_sem_wait*(sem: ptr uv_sem_t): void {.importc, noDecl.}
proc uv_sem_trywait*(sem: ptr uv_sem_t): cint {.importc, noDecl.}
proc uv_cond_init*(cond: ptr uv_cond_t): cint {.importc, noDecl.}
proc uv_cond_destroy*(cond: ptr uv_cond_t): void {.importc, noDecl.}
proc uv_cond_signal*(cond: ptr uv_cond_t): void {.importc, noDecl.}
proc uv_cond_broadcast*(cond: ptr uv_cond_t): void {.importc, noDecl.}
proc uv_cond_wait*(cond: ptr uv_cond_t, mutex: ptr uv_mutex_t): void {.importc, noDecl.}
proc uv_cond_timedwait*(cond: ptr uv_cond_t, mutex: ptr uv_mutex_t, timeout: uint64): cint {.importc, noDecl.}
proc uv_barrier_init*(barrier: ptr uv_barrier_t, count: cuint): cint {.importc, noDecl.}
proc uv_barrier_destroy*(barrier: ptr uv_barrier_t): void {.importc, noDecl.}
proc uv_barrier_wait*(barrier: ptr uv_barrier_t): cint {.importc, noDecl.}
###################
#     uv_misc     #
###################
proc uv_guess_handle*(file: uv_file): uv_handle_type {.importc, noDecl.}
proc uv_replace_allocator*(malloc_func: uv_malloc_func, realloc_func: uv_realloc_func, calloc_func: uv_calloc_func, free_func: uv_free_func): uv_handle_type {.importc, noDecl.}
proc uv_buf_init*(base: cstring, len: cuint): uv_buf_t {.importc, noDecl.}
proc uv_setup_args*(argc: cint, argv: cstringArray): cstringArray {.importc, noDecl.}
proc uv_get_process_title*(buffer: cstring, size: csize): cint {.importc, noDecl.}
proc uv_set_process_title*(title: cstring): cint {.importc, noDecl.}
proc uv_resident_set_memory*(rss: var ptr csize): cint {.importc, noDecl.}
proc uv_uptime*(uptime: var ptr cdouble): cint {.importc, noDecl.}
proc uv_getrusage*(rusage: var ptr uv_rusage_t): cint {.importc, noDecl.}
proc uv_os_getpid*(): uv_pid_t {.importc, noDecl.}
proc uv_os_getppid*(): uv_pid_t {.importc, noDecl.}
proc uv_cpu_info*(cpu_infos: var ptr uv_cpu_info_t, count: ptr cint): cint {.importc, noDecl.}
proc uv_free_cpu_info*(cpu_infos: ptr uv_cpu_info_t, count: ptr cint): void {.importc, noDecl.}
proc uv_interface_addresses*(adresses: var ptr uv_interface_address_t, count: ptr cint): cint {.importc, noDecl.}
proc uv_free_interface_addresses*(adresses: ptr uv_interface_address_t, count: ptr cint): void {.importc, noDecl.}
proc uv_loadavg*(arg: array[3, cdouble]): void {.importc, noDecl.}
proc uv_ip4_addr*(ip: cstring, port: cint, `addr`: ptr nativesockets.nativesockets.Sockaddr_in): cint {.importc, noDecl.}
proc uv_ip6_addr*(ip: cstring, port: cint, `addr`: ptr nativesockets.nativesockets.Sockaddr_in6): cint {.importc, noDecl.}
proc uv_ip4_name*(src: ptr nativesockets.nativesockets.Sockaddr_in, dst: cstring, size: csize): cint {.importc, noDecl.}
proc uv_ip6_name*(src: ptr nativesockets.nativesockets.Sockaddr_in6, dst: cstring, size: csize): cint {.importc, noDecl.}
proc uv_inet_ntop*(af: cint, src: pointer, dst: cstring, size: csize): cint {.importc, noDecl.}
proc uv_inet_pton*(af: cint, src: pointer, dst: pointer): cint {.importc, noDecl.}
proc uv_if_indextoname*(ifindex: cuint, buffer: cstring, size: var ptr csize): cint {.importc, noDecl.}
proc uv_if_indextoiid*(ifindex: cuint, buffer: cstring, size: var ptr csize): cint {.importc, noDecl.}
proc uv_exepath*(buffer: cstring, size: var ptr csize): cint {.importc, noDecl.}
proc uv_cwd*(buffer: cstring, size: var ptr csize): cint {.importc, noDecl.}
proc uv_chdir*(dir: cstring): cint {.importc, noDecl.}
proc uv_os_homedir*(buffer: cstring, size: var ptr csize): cint {.importc, noDecl.}
proc uv_os_tmpdir*(buffer: cstring, size: var ptr csize): cint {.importc, noDecl.}
proc uv_os_get_passwd*(pwd: ptr uv_passwd_t): cint {.importc, noDecl.}
proc uv_os_free_passwd*(pwd: ptr uv_passwd_t): void {.importc, noDecl.}
proc uv_get_total_memory*(): uint64 {.importc, noDecl.}
proc uv_hrtime*(): uint64 {.importc, noDecl.}
proc uv_print_all_handles*(loop: ptr uv_loop_t, stream: ptr FILE): void {.importc, noDecl.}
proc uv_print_active_handles*(loop: ptr uv_loop_t, stream: ptr FILE): void {.importc, noDecl.}
proc uv_os_getenv*(name: cstring, buffer: cstring, size: var ptr csize): cint {.importc, noDecl.}
proc uv_os_setenv*(name: cstring, value: cstring): cint {.importc, noDecl.}
proc uv_os_unsetenv*(name: cstring): cint {.importc, noDecl.}
proc uv_os_gethostname*(name: cstring, size: var ptr csize): cint {.importc, noDecl.}