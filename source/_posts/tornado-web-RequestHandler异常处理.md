---
title: tornado.web.RequestHandler异常处理
date: 2019-05-08 07:23:28
tags:
- Python
- tornado
- 源码解读
categories:
- 源码解读
---

### tornado.web.RequestHandler异常处理

tornado异常处理要从`_handle_request_execption`开始，在tornado中自定义了Finish，HTTPError以及log_exception，send_error方法

```Python
# Logger objects for internal tornado use
access_log = logging.getLogger("tornado.access")
app_log = logging.getLogger("tornado.application")
gen_log = logging.getLogger("tornado.general")

def _handle_request_exception(self, e: BaseException) -> None:
    if isinstance(e, Finish):
        # Not an error; just finish the request without logging.
        if not self._finished:
            # 如果没有结束，调用finish方法结束进程
            self.finish(*e.args)
        return
    try:
        # 调用log_exception记录异常
        self.log_exception(*sys.exc_info())
    except Exception:
        # An error here should still get a best-effort send_error()
        # to avoid leaking the connection.
        app_log.error("Error in exception logger", exc_info=True)
    if self._finished:
        # Extra errors after the request has been finished should
        # be logged, but there is no reason to continue to try and
        # send a response.
        # 已经记录到日志中，直接退出
        return
    # 如果异常e是HTTPError实例，使用e.status_code发送异常，默认使用500错误码
    if isinstance(e, HTTPError):
        self.send_error(e.status_code, exc_info=sys.exc_info())
    else:
        self.send_error(500, exc_info=sys.exc_info())

 def log_exception(
        self,
        typ: "Optional[Type[BaseException]]",
        value: Optional[BaseException],
        tb: Optional[TracebackType],
    ) -> None:
        """Override to customize logging of uncaught exceptions.

        By default logs instances of `HTTPError` as warnings without
        stack traces (on the ``tornado.general`` logger), and all
        other exceptions as errors with stack traces (on the
        ``tornado.application`` logger).

        .. versionadded:: 3.1
        """
        if isinstance(value, HTTPError):
            if value.log_message:
                format = "%d %s: " + value.log_message
                args = [value.status_code, self._request_summary()] + list(value.args)
                gen_log.warning(format, *args)
        else:
            app_log.error(  # type: ignore
                "Uncaught exception %s\n%r",
                self._request_summary(),
                self.request,
                exc_info=(typ, value, tb),
            )
    # request梗概
    def _request_summary(self) -> str:
    return "%s %s (%s)" % (
        self.request.method,
        self.request.uri,
        self.request.remote_ip,
    )
```

send_error方法代码如下：

```Python
def send_error(self, status_code: int = 500, **kwargs: Any) -> None:
    """Sends the given HTTP error code to the browser.

    If `flush()` has already been called, it is not possible to send
    an error, so this method will simply terminate the response.
    If output has been written but not yet flushed, it will be discarded
    and replaced with the error page.

    Override `write_error()` to customize the error page that is returned.
    Additional keyword arguments are passed through to `write_error`.
    """
    if self._headers_written:
        gen_log.error("Cannot send error response after headers written")
        if not self._finished:
            # If we get an error between writing headers and finishing,
            # we are unlikely to be able to finish due to a
            # Content-Length mismatch. Try anyway to release the
            # socket.
            try:
                self.finish()
            except Exception:
                gen_log.error("Failed to flush partial response", exc_info=True)
        return
    self.clear()

    reason = kwargs.get("reason")
    if "exc_info" in kwargs:
        exception = kwargs["exc_info"][1]
        if isinstance(exception, HTTPError) and exception.reason:
            reason = exception.reason
    self.set_status(status_code, reason=reason)
    try:
        self.write_error(status_code, **kwargs)
    except Exception:
        app_log.error("Uncaught exception in write_error", exc_info=True)
    if not self._finished:
        self.finish()
```

send_error()方法回向浏览器返回一个http错误码，但是在send_error之前调用了flush(),那么他就仅仅会终止回复，flush函数的作用是将输出缓存到网络中，如果没有缓存到网络中的话，他就会简单的丢弃并返回错误页面，可以通过覆盖write_error方法自定义错误页面，这个方法根据官方的推荐应该放到一个继承自RequestHandler的子类中，例如

```Python
class BaseHandler(tornado.web.RequestHandler):
    def write_error(self, *args, **kwargs):
        self.write("404.html")
```

`write_error`代码如下：

```Python
def write_error(self, status_code: int, **kwargs: Any) -> None:
        """Override to implement custom error pages.

        ``write_error`` may call `write`, `render`, `set_header`, etc
        to produce output as usual.

        If this error was caused by an uncaught exception (including
        HTTPError), an ``exc_info`` triple will be available as
        ``kwargs["exc_info"]``.  Note that this exception may not be
        the "current" exception for purposes of methods like
        ``sys.exc_info()`` or ``traceback.format_exc``.
        """
        if self.settings.get("serve_traceback") and "exc_info" in kwargs:
            # in debug mode, try to send a tradef write_ceback
            self.set_header("Content-Type", "text/plain")
            for line in traceback.format_exception(*kwargs["exc_info"]):
                self.write(line)
            self.finish()
        else:
            self.finish(
                "<html><title>%(code)d: %(message)s</title>"
                "<body>%(code)d: %(message)s</body></html>"
                % {"code": status_code, "message": self._reason}
            )
```
write_error方法可以调用write,render,set_header像平常一样产生输出。