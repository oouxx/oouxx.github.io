---
title: go切片的内部结构
date: 2019-06-09 17:13:00
tags:
- go
- 切片
categories:
- go
---

## go切片的内部结构

```c++
struct Slice
{   
    byte*    array;       // actual data
    uintgo    len;        // number of elements
    uintgo    cap;        // allocated number of elements

};
```

>  unsafe.Sizeof(slice)无论如何返回的都是24，因为他返回的是切片描述符的大小.可以理解为定义切片的数据结构，一共三个域，每个域都是8位，所以返回值是24， string虽然不可变类型，但是其内部结构有类似的性质，返回的是16

```c++
struct String
{
        byte*   str;
        intgo   len;
};
```
```go
package main

import (
"fmt"
"unsafe"
)

func main() {
    slice_test := []int{1, 2, 3, 4, 5}
    fmt.Println(unsafe.Sizeof(slice_test))
    fmt.Printf("main:%#v,%#v,%#v\n", slice_test, len(slice_test), cap(slice_test))
    slice_value(slice_test)
    fmt.Printf("main:%#v,%#v,%#v\n", slice_test, len(slice_test), cap(slice_test))
    slice_ptr(&slice_test)
    fmt.Printf("main:%#v,%#v,%#v\n", slice_test, len(slice_test), cap(slice_test))
    fmt.Println(unsafe.Sizeof(slice_test))
}

// 切片传参表面上是值传递，实质为引用传递，因为数据域定义的为byte*类型，append函数不能在原地进行修改，它会创建切片的副本，返回修改后的副本
func slice_value(slice_test []int) {
    slice_test[1] = 100                // 函数外的slice确实有被修改
    slice_test = append(slice_test, 6) // 函数外的不变
    fmt.Printf("slice_value:%#v,%#v,%#v\n", slice_test, len(slice_test), cap(slice_test))
}

// 显式引用传递
func slice_ptr(slice_test *[]int) { // 这样才能修改函数外的slice
    *slice_test = append(*slice_test, 7)
    fmt.Printf("slice_ptr:%#v,%#v,%#v\n", *slice_test, len(*slice_test), cap(*slice_test))
}
```
