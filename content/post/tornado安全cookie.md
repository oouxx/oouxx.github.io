---
title: tornado安全cookie
date: 2019-05-07T02:21:39+08:00
tags: ['tornado', 'Secure Cookie', '源码解读']
categories: ['源码解读']
---
### tornado安全cookie

文章源代码过多，参照tornado源码看本文效果更佳

#### Secure Cookies

Cookies 是不安全的，可以被客户端轻易修改和伪造，Tornado 的 Secure Cookies 使用加密签名来验证 Cookie 数据是否被非法修改过，签名后的 Cookie 数据包括时间戳、 HMAC 签名和编码后的 cookie 值等信息。`tornado.web.RequestHandler` 通过 `set_secure_cookie()` 和 `get_secure_cookie()` 方法来设置和获取 Secure Cookies，因为 HMAC 签名密钥是由 `tornado.web.Application` 实例来提供的，所以在实例化 `tornado.web.Application` 时必须在 settings 中提供 `cookie_secret` 参数才能使用安全 Cookies。否则，`self.require_setting("cookie_secret", "secure cookies")` 会抛出未设置 cookie_secret 异常。

cookie_secret 参数是一个随机字节序列，用来制作 HMAC 签名，可以使用下面的代码来生成：

```Python
>>> import base64, uuid
>>> base64.b64encode(uuid.uuid4().bytes + uuid.uuid4().bytes)
```

`set_secure_cookie` 方法是对 `set_cookie` 方法的包装，其中的value值调用`create_signed_value()`实现，需要注意的是`expires_days`这个参数与 get_secure_cookie 方法的 `max_age_days` 参数严格来讲没有必然的联系，我们可以使用一个小于 expires_days 的 `max_age_days` 值在服务端控制安全 Cookie 的有效期（这个是与安全 Cookie 中的时间戳比较得到的，后面会从代码中看到）。

```Python
 def set_secure_cookie(
        self,
        name: str,
        value: Union[str, bytes],
        expires_days: int = 30, # cookie过期时间，默认30天
        version: int = None, # 为了兼容旧版本的签名方式， version=1 使用SHA1签名， version=2 使用SHA256签名
        **kwargs: Any
    ) -> None:
        self.set_cookie(
            name,
            self.create_signed_value(name, value, version=version),
            expires_days=expires_days,
            **kwargs
        )
 def set_cookie(
        self,
        name: str,
        value: Union[str, bytes],
        domain: str = None,
        expires: Union[float, Tuple, datetime.datetime] = None,
        path: str = "/",
        expires_days: int = None,
        **kwargs: Any
    ) -> None:
        # The cookie library only accepts type str, in both python 2 and 3
        name = escape.native_str(name) # 转义为原生字符串
        value = escape.native_str(value)
        if re.search(r"[\x00-\x20]", name + value):
            # Don't let us accidentally inject bad stuff
            raise ValueError("Invalid cookie %r: %r" % (name, value))
        if not hasattr(self, "_new_cookie"):
            self._new_cookie = http.cookies.SimpleCookie()
        if name in self._new_cookie:
            del self._new_cookie[name]
        self._new_cookie[name] = value
        morsel = self._new_cookie[name]
        if domain:
            morsel["domain"] = domain
        if expires_days is not None and not expires:
            expires = datetime.datetime.utcnow() + datetime.timedelta(days=expires_days)
        if expires:
            morsel["expires"] = httputil.format_timestamp(expires)
        if path:
            morsel["path"] = path
        for k, v in kwargs.items():
            if k == "max_age":
                k = "max-age"

            # skip falsy values for httponly and secure flags because
            # SimpleCookie sets them regardless
            # 没有httponly和secure的value值直接跳过，反正SimpleCookie会设置他们
            if k in ["httponly", "secure"] and not v:
                continue

            morsel[k] = v
def create_signed_value(
        self, name: str, value: Union[str, bytes], version: int = None
    ) -> bytes:
        # 检查是否设置cookie_secret,没有设置会报错
        self.require_setting("cookie_secret", "secure cookies")
        secret = self.application.settings["cookie_secret"]
        key_version = None
        if isinstance(secret, dict):
            # 当secret是一个dict时要设置key_version
            if self.application.settings.get("key_version") is None:
                raise Exception("key_version setting must be used for secret_key dicts")
            key_version = self.application.settings["key_version"]

        return create_signed_value(
            secret, name, value, version=version, key_version=key_version
        )
```

`create_signed_value` 函数的代码及相关签名函数如下所示：

```Python
# 指定默认签名版本
DEFAULT_SIGNED_VALUE_VERSION = 2

# 重载了同名方法
def create_signed_value(secret, name, value, version=None, clock=None):
    if version is None:
        version = DEFAULT_SIGNED_VALUE_VERSION
    if clock is None:
        clock = time.time
    timestamp = utf8(str(int(clock())))
    value = base64.b64encode(utf8(value))
    if version == 1:
        signature = _create_signature_v1(secret, name, value, timestamp)
        value = b"|".join([value, timestamp, signature])
        return value
    elif version == 2:
        # The v2 format consists of a version number and a series of
        # length-prefixed fields "%d:%s", the last of which is a
        # signature, all separated by pipes.  All numbers are in
        # decimal format with no leading zeros.  The signature is an
        # HMAC-SHA256 of the whole string up to that point, including
        # the final pipe.
        #
        # The fields are:
        # - format version (i.e. 2; no length prefix)
        # - key version (currently 0; reserved for future key rotation features)
        # - timestamp (integer seconds since epoch)
        # - name (not encoded; assumed to be ~alphanumeric)
        # - value (base64-encoded)
        # - signature (hex-encoded; no length prefix)
        def format_field(s):
            return utf8("%d:" % len(s)) + utf8(s)
        to_sign = b"|".join([
            b"2|1:0",
            format_field(timestamp),
            format_field(name),
            format_field(value),
            b''])
        signature = _create_signature_v2(secret, to_sign)
        return to_sign + signature
    else:
        raise ValueError("Unsupported version %d" % version)

def _create_signature_v1(secret, *parts):
    hash = hmac.new(utf8(secret), digestmod=hashlib.sha1)
    for part in parts:
        hash.update(utf8(part))
    return utf8(hash.hexdigest())


def _create_signature_v2(secret, s):
    hash = hmac.new(utf8(secret), digestmod=hashlib.sha256)
    hash.update(utf8(s))
    return utf8(hash.hexdigest())
```

模块变量 `DEFAULT_SIGNED_VALUE_VERSION` 硬编码指示默认的签名版本是 2，除非调用 set_secure_cookie 时指定版本号。两个版本之间的数据格式看代码就很明确，版本 1 就是简单的 “value|timestamp|signature” 拼接，版本 2 多了几个字段，并且记录值的字符串长度，尤其是预留的 `key_version` 字段为后续轮流使用多个 cookie_secret 提供了支持,并且对整个字符串进行签名（版本 1 仅仅对 value 进行了签名），这样可以大大增加安全系数。这里额外提一下时间戳（timestamp）字段，由于客户端在发送 Cookie 时并不会提供有效期，为了能够准确控制有效期，这里将 Cookie 生成的时间戳写入值当中，以便后续在服务端进行有效期验证。

#### get_secure_cookie 方法

`get_secure_cookie` 方法签名中的 value 参数指的是通过 set_secure_cookie 加密签名后的 Cookie 值，默认是 None 则会从客户端发送回来的 Cookies 中获取指定名称的 Cookie 值作为 value，再进行签名验证，传入的 `max_age_days`，`min_version` 将对 Cookie 做进一步比较验证，验证通过以后返回 base64 解码的 Cookie 值（也就是下面注释中说的不论 python 的版本，返回的是 byte string，与 get_cookie 方法不同。get_cookie 方法在 python3 中返回的是 unicode string。）。

```Python
def get_secure_cookie(self, name, value=None, max_age_days=31, min_version=None):
    self.require_setting("cookie_secret", "secure cookies")
    if value is None:
        value = self.get_cookie(name)
    return decode_signed_value(self.application.settings["cookie_secret"],
                               name, value, max_age_days=max_age_days,
                               min_version=min_version)
```
除了要进行编码还要进行解码`decode_signed_value` 方法的相关代码如下所示：

```Python
DEFAULT_SIGNED_VALUE_MIN_VERSION = 1

# A leading version number in decimal with no leading zeros, followed by a pipe.
_signed_value_version_re = re.compile(br"^([1-9][0-9]*)\|(.*)$")


def decode_signed_value(secret, name, value, max_age_days=31, clock=None, min_version=None):
    if clock is None:
        clock = time.time
    if min_version is None:
        min_version = DEFAULT_SIGNED_VALUE_MIN_VERSION
    if min_version > 2:
        raise ValueError("Unsupported min_version %d" % min_version)
    if not value:
        return None

    # Figure out what version this is.  Version 1 did not include an
    # explicit version field and started with arbitrary base64 data,
    # which makes this tricky.
    value = utf8(value)
    m = _signed_value_version_re.match(value)
    if m is None:
        version = 1
    else:
        try:
            version = int(m.group(1))
            if version > 999:
                # Certain payloads from the version-less v1 format may
                # be parsed as valid integers.  Due to base64 padding
                # restrictions, this can only happen for numbers whose
                # length is a multiple of 4, so we can treat all
                # numbers up to 999 as versions, and for the rest we
                # fall back to v1 format.
                version = 1
        except ValueError:
            version = 1

    if version < min_version:
        return None
    if version == 1:
        return _decode_signed_value_v1(secret, name, value, max_age_days, clock)
    elif version == 2:
        return _decode_signed_value_v2(secret, name, value, max_age_days, clock)
    else:
        return None


def _decode_signed_value_v1(secret, name, value, max_age_days, clock):
    parts = utf8(value).split(b"|")
    if len(parts) != 3:
        return None
    signature = _create_signature_v1(secret, name, parts[0], parts[1])
    if not _time_independent_equals(parts[2], signature):
        gen_log.warning("Invalid cookie signature %r", value)
        return None
    timestamp = int(parts[1])
    if timestamp < clock() - max_age_days * 86400:
        gen_log.warning("Expired cookie %r", value)
        return None
    if timestamp > clock() + 31 * 86400:
        # _cookie_signature does not hash a delimiter between the
        # parts of the cookie, so an attacker could transfer trailing
        # digits from the payload to the timestamp without altering the
        # signature.  For backwards compatibility, sanity-check timestamp
        # here instead of modifying _cookie_signature.
        gen_log.warning("Cookie timestamp in future; possible tampering %r", value)
        return None
    if parts[1].startswith(b"0"):
        gen_log.warning("Tampered cookie %r", value)
        return None
    try:
        return base64.b64decode(parts[0])
    except Exception:
        return None


def _decode_signed_value_v2(secret, name, value, max_age_days, clock):
    def _consume_field(s):
        length, _, rest = s.partition(b':')
        n = int(length)
        field_value = rest[:n]
        # In python 3, indexing bytes returns small integers; we must
        # use a slice to get a byte string as in python 2.
        if rest[n:n + 1] != b'|':
            raise ValueError("malformed v2 signed value field")
        rest = rest[n + 1:]
        return field_value, rest
    rest = value[2:]  # remove version number
    try:
        key_version, rest = _consume_field(rest)
        timestamp, rest = _consume_field(rest)
        name_field, rest = _consume_field(rest)
        value_field, rest = _consume_field(rest)
    except ValueError:
        return None
    passed_sig = rest
    signed_string = value[:-len(passed_sig)]
    expected_sig = _create_signature_v2(secret, signed_string)
    if not _time_independent_equals(passed_sig, expected_sig):
        return None
    if name_field != utf8(name):
        return None
    timestamp = int(timestamp)
    if timestamp < clock() - max_age_days * 86400:
        # The signature has expired.
        return None
    try:
        return base64.b64decode(value_field)
    except Exception:
        return None

if hasattr(hmac, 'compare_digest'):  # python 3.3
    _time_independent_equals = hmac.compare_digest
else:
    def _time_independent_equals(a, b):
        if len(a) != len(b):
            return False
        result = 0
        if isinstance(a[0], int):  # python3 byte strings
            for x, y in zip(a, b):
                result |= x ^ y
        else:  # python2
            for x, y in zip(a, b):
                result |= ord(x) ^ ord(y)
        return result == 0
```

`_signed_value_version_re`正则表达式用于获取签名所用的版本号，对于旧版本（版本 1 ）加密签名的 cookie 数据中没有版本号这个字段，默认取 1。然后与指定的 min_version 进行比较，仅当大于等于 min_version 才进行下一步验证。版本 1 由函数 _decode_signed_value_v1 验证，版本 2 由 函数 _decode_signed_value_v2 验证，这两个函数主要就是按照对应签名格式解析数据，并对目标签名和时间戳等字段进行比较验证。需要说一下的是由于版本 1 的设计缺陷，没有对 timestamp 进行签名，为了尽可能防止攻击者篡改时间戳来进行攻击， _decode_signed_value_v1 函数对 timestamp 执行了额外的检查（timestamp > clock() + 31 * 86400），但这个检查并不能完全杜绝此类攻击。这应该也是重新设计版本 2 的一个原因。

