---
title: process.fork_process剖析tornado多进程原理
date: 2019-05-06 05:13:31
tags:
- Python
- tornado
categories:
- 源码解读
---
### process.fork_process剖析tornado多进程原理

```Python
def fork_processes(num_processes: Optional[int], max_restarts: int = None) -> int:
    """Starts multiple worker processes.

    If ``num_processes`` is None or <= 0, we detect the number of cores
    available on this machine and fork that number of child
    processes. If ``num_processes`` is given and > 0, we fork that
    specific number of sub-processes.

    Since we use processes and not threads, there is no shared memory
    between any server code.

    Note that multiple processes are not compatible with the autoreload
    module (or the ``autoreload=True`` option to `tornado.web.Application`
    which defaults to True when ``debug=True``).
    When using multiple processes, no IOLoops can be created or
    referenced until after the call to ``fork_processes``.

    In each child process, ``fork_processes`` returns its *task id*, a
    number between 0 and ``num_processes``.  Processes that exit
    abnormally (due to a signal or non-zero exit status) are restarted
    with the same id (up to ``max_restarts`` times).  In the parent
    process, ``fork_processes`` returns None if all child processes
    have exited normally, but will otherwise only exit by throwing an
    exception.

    max_restarts defaults to 100.

    Availability: Unix
    """
    if max_restarts is None:
        max_restarts = 100

    global _task_id
    assert _task_id is None
    if num_processes is None or num_processes <= 0:
        num_processes = cpu_count()
    gen_log.info("Starting %d processes", num_processes)
    children = {}

    def start_child(i: int) -> Optional[int]:
        # fork()类似与在一条路上修了一条支路
        # 对于父进程来说os.fork()返回的是子进程额pid，
        # 对于子进程，自己本身创建成功了return 0
        pid = os.fork()
        if pid == 0:
            # child process
            _reseed_random()
            global _task_id
            _task_id = i
            # return i 剩下的代码全是父进程的
            # ，因为使用了return，但是子进程并未结束
            return i
        else:
            # father process
            children[pid] = i
            return None

    for i in range(num_processes):
        id = start_child(i)
        # if id is not None表示
        # 我们在刚刚生成的那个子进程的上下文里面
        if id is not None:
            return id
    num_restarts = 0
    while children:
        try:
            # 等待子进程的退出或者结束
            pid, status = os.wait()
        except OSError as e:
            if errno_from_exception(e) == errno.EINTR:
                continue
            raise
        # 如果子进程不在队列中直接跳过
        if pid not in children:
            continue
        # 弹出子进程
        id = children.pop(pid)
        # 通过status判断子进程退出的原因
        if os.WIFSIGNALED(status):
            gen_log.warning(
                "child %d (pid %d) killed by signal %d, restarting",
                id,
                pid,
                os.WTERMSIG(status),
            )
        elif os.WEXITSTATUS(status) != 0:
            gen_log.warning(
                "child %d (pid %d) exited with status %d, restarting",
                id,
                pid,
                os.WEXITSTATUS(status),
            )
        else:
            gen_log.info("child %d (pid %d) exited normally", id, pid)
            continue
        num_restarts += 1
        if num_restarts > max_restarts:
            raise RuntimeError("Too many child restarts, giving up")
        new_id = start_child(id)
        if new_id is not None:
            return new_id
    # All child processes exited cleanly, so exit the master process
    # instead of just returning to right after the call to
    # fork_processes (which will probably just start up another IOLoop
    # unless the caller checks the return value).
    sys.exit(0)


def task_id() -> Optional[int]:
    """Returns the current task id, if any.

    Returns None if this process was not created by `fork_processes`.
    """
    global _task_id
    return _task_id
```

### a sample for os module

一个简单的代码示例展示操作系统fork子进程的过程

```Python
import os
import sys

def child_process():
    '''child process'''
    print 'child process is running'
    sys.exit(0)

def parent_process():
    '''parent process'''
    print 'parent process is running'
    print 'waiting for child process'
    exit_stat = os.wait()
    print "waited child process's PID = %d" % (exit_stat[0])
    sys.exit(0)

def main():
    '''main function'''
    try:
    pid = os.fork()
    # 当fork成功时，向父进程返回pid值，向子进程返回0
    if pid > 0:
        '''parent process'''
        parent_process()
    else:
        child_process()
    except OSError, e:
    print os.strerror(e.errno)

if __name__ == '__main__':
    main()
```