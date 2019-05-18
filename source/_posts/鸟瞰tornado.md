---
title: 鸟瞰tornado
date: 2019-05-06 02:17:48
tags:
- Python
- tornado
- 源码解读
categories:
- 源码解读
---
## 鸟瞰tornado

### Web framework

- tornado.web — RequestHandler and Application classes
- tornado.template — Flexible output generation
- tornado.routing — Basic routing implementation
- tornado.escape — Escaping and string manipulation
- tornado.locale — Internationalization support
- tornado.websocket — Bidirectional communication to the browser

### HTTP servers and clients

- tornado.httpserver — Non-blocking HTTP server
- tornado.httpclient — Asynchronous HTTP client
- tornado.httputil — Manipulate HTTP headers and URLs
- tornado.http1connection – HTTP/1.x client/server implementation

### Asynchronous networking

- tornado.ioloop — Main event loop
- tornado.iostream — Convenient wrappers for non-blocking sockets
- tornado.netutil — Miscellaneous network utilities
- tornado.tcpclient — IOStream connection factory
- tornado.tcpserver — Basic IOStream-based TCP server

### Coroutines and concurrency

- tornado.gen — Generator-based coroutines
- tornado.locks – Synchronization primitives
- tornado.queues – Queues for coroutines
- tornado.process — Utilities for multiple processes

### Integration with other services

- tornado.auth — Third-party login with OpenID and OAuth
- tornado.wsgi — Interoperability with other Python frameworks and servers
- tornado.platform.caresresolver — Asynchronous DNS Resolver using C-Ares
- tornado.platform.twisted — Bridges between Twisted and Tornado
- tornado.platform.asyncio — Bridge between asyncio and Tornado

### Utilities

- tornado.autoreload — Automatically detect code changes in development
- tornado.concurrent — Work with Future objects
- tornado.log — Logging support
- tornado.options — Command-line parsing
- tornado.testing — Unit testing support for asynchronous code
- tornado.util — General-purpose utilities

### 源码文件

```
.
├── auth.py
├── autoreload.py
├── concurrent.py
├── curl_httpclient.py
├── escape.py
├── gen.py
├── http1connection.py
├── httpclient.py
├── httpserver.py
├── httputil.py
├── __init__.py
├── ioloop.py
├── iostream.py
├── _locale_data.py
├── locale.py
├── locks.py
├── log.py
├── netutil.py
├── options.py
├── platform/
├── process.py
├── __pycache__/
├── py.typed
├── queues.py
├── routing.py
├── simple_httpclient.py
├── source.txt
├── speedups.c
├── speedups.pyi
├── tcpclient.py
├── tcpserver.py
├── template.py
├── test/
├── testing.py
├── util.py
├── web.py
├── websocket.py
└── wsgi.py

3 directories, 35 files
```