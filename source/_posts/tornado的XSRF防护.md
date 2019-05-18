---
title: tornado的XSRF防护
date: 2019-05-08 07:02:22
tags:
- tornado
- XSRF
- 源码解读
categories:
- 源码解读
---
#### XSRF

`XSRF`（Cross-site request forgery，跨站请求伪造），也被简写为 CSRF，发音为”sea surf”，这是一个常见的安全漏洞（这里有一篇写的不错的文章《浅谈CSRF攻击方式》，有兴趣的可以简单了解下）。通常 Synchronizer token pattern 是一种常见的解决方案，该方案利用了第三方站点无法访问 cookie 的限制，为每个客户端设置一个不同的 token，并将其存储在 cookie 中。当用户发起有副作用的 HTTP 请求时，则必须携带一个包含该 token 的参数（也可以通过 Http Header 传递），服务端将对存储在 cookie 和请求参数中的 token 进行比较，以防止潜在的跨站请求伪造。

#### 生成 xsrf_token

tornado.web.RequestHandler 中与生成跨站请求伪造 token 直接相关的是 `xsrf_token` 属性和 `xsrf_form_html` 方法。

xsrf_token 属性在首次访问时会为客户端设置一个名为 _xsrf 的 cookie，其值变为前面所说的 token。token 有两个版本，版本号分别为 1 和 2，若没有在应用中设置 xsrf_cookie_version 参数则默认使用版本 2。版本 2 为每次请求都生成一个随机的掩码，相比较版本 1 而言安全性大大增强。

`xsrf_form_html` 就是返回一个隐藏的 HTML < input/> 元素，用于包含在页面的 Form 元素中以便在 POST 请求时将 token 发送给服务端验证。

详细代码如下所示：

```Python
@property
def xsrf_token(self):
    if not hasattr(self, "_xsrf_token"):
        version, token, timestamp = self._get_raw_xsrf_token()
        output_version = self.settings.get("xsrf_cookie_version", 2)
        if output_version == 1:
            self._xsrf_token = binascii.b2a_hex(token)
        elif output_version == 2:
            mask = os.urandom(4)
            self._xsrf_token = b"|".join([
                b"2",
                binascii.b2a_hex(mask),
                binascii.b2a_hex(_websocket_mask(mask, token)),
                utf8(str(int(timestamp)))])
        else:
            raise ValueError("unknown xsrf cookie version %d",
                             output_version)
        if version is None:
            expires_days = 30 if self.current_user else None
            self.set_cookie("_xsrf", self._xsrf_token,
                            expires_days=expires_days)
    return self._xsrf_token

def xsrf_form_html(self):
    return '<input type="hidden" name="_xsrf" value="' + \
        escape.xhtml_escape(self.xsrf_token) + '"/>'
```

上述两个方法关联的另外几个方法是 `_get_raw_xsrf_token` 和 `_decode_xsrf_token`。首次访问 _get_raw_xsrf_token 方法时，将尝试为当前用户请求生成 token（若已经生成，则直接从 cookie “_xsrf” 中获取），并赋值给 handler 的 `_raw_xsrf_token` 字段。_decode_xsrf_token 方法将 token 解析为 (version, token, timestamp) 元组返回（兼容版本 1 ，版本 1 中没有 version 和 timestamp 字段）。代码很简单，如下所示：

```Python
def _get_raw_xsrf_token(self):
    if not hasattr(self, '_raw_xsrf_token'):
        cookie = self.get_cookie("_xsrf")
        if cookie:
            version, token, timestamp = self._decode_xsrf_token(cookie)
        else:
            version, token, timestamp = None, None, None
        if token is None:
            version = None
            token = os.urandom(16)
            timestamp = time.time()
        self._raw_xsrf_token = (version, token, timestamp)
    return self._raw_xsrf_token

def _decode_xsrf_token(self, cookie):
    m = _signed_value_version_re.match(utf8(cookie))
    if m:
        version = int(m.group(1))
        if version == 2:
            _, mask, masked_token, timestamp = cookie.split("|")
            mask = binascii.a2b_hex(utf8(mask))
            token = _websocket_mask(
                mask, binascii.a2b_hex(utf8(masked_token)))
            timestamp = int(timestamp)
            return version, token, timestamp
        else:
            # Treat unknown versions as not present instead of failing.
            return None, None, None
    else:
        version = 1
        try:
            token = binascii.a2b_hex(utf8(cookie))
        except (binascii.Error, TypeError):
            token = utf8(cookie)
        # We don't have a usable timestamp in older versions.
        timestamp = int(time.time())
        return (version, token, timestamp)
```

#### 检查 xsrf_token

对 xsrf_token 的检查在 `_execute` 方法中委托 `check_xsrf_cookie` 方法进行，代码如下所示：

```Python
async def _execute(
        self, transforms: List["OutputTransform"], *args: bytes, **kwargs: bytes
    ) -> None:
        """Executes this request with the given output transforms."""
        self._transforms = transforms
        try:
            if self.request.method not in self.SUPPORTED_METHODS:
                raise HTTPError(405)
            self.path_args = [self.decode_argument(arg) for arg in args]
            self.path_kwargs = dict(
                (k, self.decode_argument(v, name=k)) for (k, v) in kwargs.items()
            )
            # If XSRF cookies are turned on, reject form submissions without
            # the proper cookie
            if self.request.method not in (
                "GET",
                "HEAD",
                "OPTIONS",
            ) and self.application.settings.get("xsrf_cookies"):
                self.check_xsrf_cookie()

            result = self.prepare()
            if result is not None:
                result = await result
            if self._prepared_future is not None:
                # Tell the Application we've finished with prepare()
                # and are ready for the body to arrive.
                future_set_result_unless_cancelled(self._prepared_future, None)
            if self._finished:
                return

            if _has_stream_request_body(self.__class__):
                # In streaming mode request.body is a Future that signals
                # the body has been completely received.  The Future has no
                # result; the data has been passed to self.data_received
                # instead.
                try:
                    await self.request._body_future
                except iostream.StreamClosedError:
                    return

            method = getattr(self, self.request.method.lower())
            result = method(*self.path_args, **self.path_kwargs)
            if result is not None:
                result = await result
            if self._auto_finish and not self._finished:
                self.finish()
        except Exception as e:
            try:
                self._handle_request_exception(e)
            except Exception:
                app_log.error("Exception in exception handler", exc_info=True)
            finally:
                # Unset result to avoid circular references
                result = None
            if self._prepared_future is not None and not self._prepared_future.done():
                # In case we failed before setting _prepared_future, do it
                # now (to unblock the HTTP server).  Note that this is not
                # in a finally block to avoid GC issues prior to Python 3.4.
                self._prepared_future.set_result(None)

def check_xsrf_cookie(self):
    token = (self.get_argument("_xsrf", None) or
             self.request.headers.get("X-Xsrftoken") or
             self.request.headers.get("X-Csrftoken"))
    if not token:
        raise HTTPError(403, "'_xsrf' argument missing from POST")
    _, token, _ = self._decode_xsrf_token(token)
    _, expected_token, _ = self._get_raw_xsrf_token()
    if not _time_independent_equals(utf8(token), utf8(expected_token)):
        raise HTTPError(403, "XSRF cookie does not match POST argument")
```

`check_xsrf_cookie` 方法代码显示与 cookie 中的 token 进行比较的 token 来源于请求参数 _xsrf 或者 HTTP 头域（`X-Xsrftoken` 或者 `X-Csrftoken`）。目前仅比较 token 值，对其中的 timestamp 和 version 字段不做比较验证。

由上可见，xsrf cookies 的生成仅与是否访问 xsrf_token 属性相关，要进行验证则需要为应用设置 xsrf_cookies 为 True。