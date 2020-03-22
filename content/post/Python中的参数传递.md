---
title: Python中的参数传递
date: 2019-05-17T23:47:34+08:00
tags: ['Python', '参数传递']
categories: ['Python']
---

### Python的函数参数传递

先看下面两段代码

```Python
# List - a mutable type
def try_to_change_list_contents(the_list):
    print('got', the_list)
    the_list.append('four')
    print('changed:', the_list)
    the_list = ['one', 'two', 'three', 'four', 'five']
    print('changed:', the_list)
outer_list = ['one', 'two', 'three']
if __name__ == '__main__':
    print('before, outer_list=', outer_list)
    try_to_change_list_contents(outer_list)
    print('after, outer_list=', outer_list)

```

```Python
# String - a immutable type
def try_to_change_string_reference(the_string):
    print('got', the_string)
    the_string = 'In a kingdom by the sea'
    print('set to', the_string)

outer_string = 'It was many and many a year ago'
if __name__ == '__main__':
    print('before, outer_string =', outer_string)
    try_to_change_string_reference(outer_string)
    print('after, outer_string =', outer_string)

```

在Python中所有的变量都可以理解是内存中一个对象的“引用”，或者，也可以看似c中void*的感觉。在理解变量即指针的基础上

Python中的对象又大致可以分为两类，可变对象和不可变对像。可变对象list,dict,set等允许进行原地修改，即对象的引用不变的情况下，引用所指的内容发生变化，例如，list.append()这个方法就是原地修改方法，你不需要用一个容器来接收方法调用的结果;对于不可变对象strings,tuples,numbers他们不能进行原地修改，因为他们是不可变的，所以当修改他们等于说又创建了一个新的对象。

对于上述结论可以通过id来看引用的内存地址来进行验证。

---

当我们在我们定义的函数里想要保存已有的修改时，官方给了我们几种方法[How do I write a function with output parameters (call by reference)?](https://docs.python.org/3/faq/programming.html#how-do-i-write-a-function-with-output-parameters-call-by-reference)

### How do I write a function with output parameters (call by reference)?

Remember that arguments are passed by assignment in Python. Since assignment just creates references to objects, there’s no alias between an argument name in the caller and callee, and so no call-by-reference per se. You can achieve the desired effect in a number of ways.

请记住，在Python中参数是通过赋值传递的，因为赋值仅仅创建对象的引用，所以参数的名字在调用者和被调用者之间是没有别名的，其实是没有引用调用这一说的(引用调用类似于c，c++中`&var`的写法，传入变量的地址，这样就可以将修改过后的值返回到原来的位置)，在Python中可以通过下面几种方法实现。

1. By returning a tuple of the results:

```Python
def func2(a, b):
    a = 'new-value'        # a and b are local names
    b = b + 1              # assigned to new objects
    return a, b            # return new values

x, y = 'old-value', 99
x, y = func2(x, y)
print(x, y)                # output: new-value 100
```

This is almost always the clearest solution.

2. By using global variables. This isn’t thread-safe, and is not recommended.

3. By passing a mutable (changeable in-place) object:

```Python
def func1(a):
    a[0] = 'new-value'     # 'a' references a mutable list
    a[1] = a[1] + 1        # changes a shared object

args = ['old-value', 99]
func1(args)
print(args[0], args[1])    # output: new-value 100
```

4. By passing in a dictionary that gets mutated:

```Python
def func3(args):
    args['a'] = 'new-value'     # args is a mutable dictionary
    args['b'] = args['b'] + 1   # change it in-place

args = {'a': 'old-value', 'b': 99}
func3(args)
print(args['a'], args['b'])
```

5. Or bundle up values in a class instance:

```Python
class callByRef:
    def __init__(self, **args):
        for (key, value) in args.items():
            setattr(self, key, value)

def func4(args):
    args.a = 'new-value'        # args is a mutable callByRef
    args.b = args.b + 1         # change object in-place

args = callByRef(a='old-value', b=99)
func4(args)
print(args.a, args.b)
```

There’s almost never a good reason to get this complicated.

Your best choice is to return a tuple containing the multiple results.

参考:[How do I pass a variable by reference?](https://stackoverflow.com/questions/986006/how-do-i-pass-a-variable-by-reference)