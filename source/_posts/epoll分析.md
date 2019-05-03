---
title: epoll性能分析
date: 2019-04-17 15:17:09
tags:
- Linux
- epoll
- IO多路复用
categories:
- Linux
---
本文源自stackoverflow的一个问答,斗胆翻译原文希望能从中收获知识（意译）。本人英语水平有限，如有错误还请指出。
[精彩问答](https://stackoverflow.com/questions/2032598/caveats-of-select-poll-vs-epoll-reactors-in-twisted)

### Question

Everything I’ve read and experienced ( Tornado based apps ) leads me to believe that ePoll is a natural replacement for Select and Poll based networking, especially with Twisted. Which makes me paranoid, its pretty rare for a better technique or methodology not to come with a price.

> 任何我曾阅读和体验的（基于tornado的应用）尤其是Twisted都让我相信，epoll是基于网络的select和poll的自然的替代品。一种更好的技术或方法却不需要付出代价是很罕见的，这让我产生了妄想症。

Reading a couple dozen comparisons between epoll and alternatives shows that epoll is clearly the champion for speed and scalability, specifically that it scales in a linear fashion which is fantastic. That said, what about processor and memory utilization, is epoll still the champ?

> 通过对epoll和其他产品进行几十次比较，可以看出epoll显然是速度和可扩展性方面的佼佼者，特别是它以线性方式进行扩展，这非常棒。也就是说，处理器和内存的利用率如何，epoll仍然是冠军吗？

### Answer

For very small numbers of sockets (varies depending on your hardware, of course, but we’re talking about something on the order of 10 or fewer), select can beat epoll in memory usage and runtime speed. Of course, for such small numbers of sockets, both mechanisms are so fast that you don’t really care about this difference in the vast majority of cases.

> 对于少量的套接字连接（当然，取决于你的硬件的不同，不是我们现在讨论的是10个或者更少），select会在运行时间和内存利用率上打败epoll。当然，对于如此少量的连接，两种机制都快到让你在大多数情况下可以不必在意这个差异。

One clarification, though. Both select and epoll scale linearly. A big difference, though, is that the userspace-facing APIs have complexities that are based on different things. The cost of a select call goes roughly with the value of the highest numbered file descriptor you pass it. If you select on a single fd, 100, then that’s roughly twice as expensive as selecting on a single fd, 50. Adding more fds below the highest isn’t quite free, so it’s a little more complicated than this in practice, but this is a good first approximation for most implementations.

> 有一点需要澄清的是，虽然两者都是线性扩展的，但是一个很大区别是面向用户空间的API具有基于不同事件的复杂性。select调用的成本大致与传递给它的编号最高的文件描述符的值相同。如果在单个fd上select 100， 那么大约是单个fd上select 50的两倍

The cost of epoll is closer to the number of file descriptors that actually have events on them. If you’re monitoring 200 file descriptors, but only 100 of them have events on them, then you’re (very roughly) only paying for those 100 active file descriptors. This is where epoll tends to offer one of its major advantages over select. If you have a thousand clients that are mostly idle, then when you use select you’re still paying for all one thousand of them. However, with epoll, it’s like you’ve only got a few – you’re only paying for the ones that are active at any given time.

> epoll的成本取决于真正有事件发生的文件描述符的数量，如果你正在监测200个文件描述符，但是只有100个有事件发生，那么你粗略的只需为100个活动的文件描述符付出代价，这是epoll相比于select的主要优点之一。如果你有上千个客户都是闲置的，那么如果当你选择select时仍然要为他们付出代价。然而，使用epoll，就好像你只有少数人——你只为那些在任何特定时间都很活跃的人提供服务。

All this means that epoll will lead to less CPU usage for most workloads. As far as memory usage goes, it’s a bit of a toss up. select does manage to represent all the necessary information in a highly compact way (one bit per file descriptor). And the FD_SETSIZE (typically 1024) limitation on how many file descriptors you can use with select means that you’ll never spend more than 128 bytes for each of the three fd sets you can use with select (read, write, exception). Compared to those 384 bytes max, epoll is sort of a pig. Each file descriptor is represented by a multi-byte structure. However, in absolute terms, it’s still not going to use much memory. You can represent a huge number of file descriptors in a few dozen kilobytes (roughly 20k per 1000 file descriptors, I think). And you can also throw in the fact that you have to spend all 384 of those bytes with select if you only want to monitor one file descriptor but its value happens to be 1024, wheras with epoll you’d only spend 20 bytes. Still, all these numbers are pretty small, so it doesn’t make much difference.

> 所有这些意味着，epoll将减少大部分工作负载的的cpu使用量。就内存使用率而言，这就优点麻烦了。select是以高度紧凑的方式（每个文件描述符一位）表示所有必需的信息。fd_setsize（通常为1024）限制了可以与select一起使用的文件描述符的数量，这意味着您将永远不会为可与select一起使用的三个fd集合（读、写、异常）中的每一个花费超过128个字节。与最大384字节相比，epoll有点像猪。每个文件描述符由多字节结构表示。但是，从绝对值来看，它仍然不会占用太多内存。您可以用几十个千字节来表示大量的文件描述符（我认为大约每1000个文件描述符有20K个）。如果您只想监视一个文件描述符，但它的值恰好是1024，而带epoll的只需花费20个字节，那么您还可以抛出这样一个事实：您必须使用select来花费所有384个字节。不过，所有这些数字都很小，所以没什么区别。

And there’s also that other benefit of epoll, which perhaps you’re already aware of, that it is not limited to FD_SETSIZE file descriptors. You can use it to monitor as many file descriptors as you have. And if you only have one file descriptor, but its value is greater than FD_SETSIZE, epoll works with that too, but select does not.

> epoll还有你个好处或许你已经意识到，它不受fd_size文件描述符的限制，你可以使用他来监控尽可能多的文件描述符，如果你只有一个文件描述符，但是它的值大于fd_setsize, 你只能使用epoll，而不能使用select。

Randomly, I’ve also recently discovered one slight drawback to epoll as compared to select or poll. While none of these three APIs supports normal files (ie, files on a file system), select and poll present this lack of support as reporting such descriptors as always readable and always writeable. This makes them unsuitable for any meaningful kind of non-blocking filesystem I/O, a program which uses select or poll and happens to encounter a file descriptor from the filesystem will at least continue to operate (or if it fails, it won’t be because of select or poll), albeit it perhaps not with the best performance.

> 随机地，我最近也发现了一个与select或poll相比，epoll的小缺点。虽然这三个API都不支持普通文件（即文件系统上的文件），但是select和poll显示了这种缺乏支持的情况，即报告描述符总是可读的和总是可写的。这使得它们不适用于任何有意义的非阻塞文件系统I/O，一个使用select或poll并且碰巧遇到文件系统中的文件描述符的程序至少会继续运行（或者如果失败，则不会是因为select或poll），尽管它可能没有最好的性能。

On the other hand, epoll will fail fast with an error (EPERM, apparently) when asked to monitor such a file descriptor. Strictly speaking, this is hardly incorrect. It’s merely signalling its lack of support in an explicit way. Normally I would applaud explicit failure conditions, but this one is undocumented (as far as I can tell) and results in a completely broken application, rather than one which merely operates with potentially degraded performance.

> 另一方面，当要求epoll监视此类文件描述符时，epoll将快速失败，并出现错误（EPERM，显然地）。严格来说，这几乎是不正确的。它只是以一种明确的方式表明它缺乏支持。通常，我会为明确的失败条件鼓掌，但这一个是未记录的（据我所知），会导致完全中断的应用程序，而不是仅仅以可能降低的性能运行的应用程序。

In practice, the only place I’ve seen this come up is when interacting with stdio. A user might redirect stdin or stdout from/to a normal file. Whereas previously stdin and stdout would have been a pipe — supported by epoll just fine — it then becomes a normal file and epoll fails loudly, breaking the application.

>在实践中，我唯一看到这事发生是在与标准IO交互的时候，一个用户可能重定向他的标准输入/输出到一个普通文件。之前的标准输入/输出是由epoll支持的管道，能很好的工作，但是变成普通文件的时候epoll就会失败，使程序崩溃。