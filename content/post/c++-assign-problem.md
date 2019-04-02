---
title: C++赋值问题之不要使用创建临时对象的方式修改包含动态内存的对象
date: 2018-09-30T21:39:28+08:00
description: "C++赋值问题"
categories: ["C++"]
featuredImage: "/img/product_10337_product_shot_wide_image.jpg"
dropCap: true
displayInMenu: false
displayInList: true
draft: false
---

今天在写代码的时候，写了一段类似这样的代码:

```cpp
#include <iostream>
#include <cmath>
using namespace std;

class ClassA{
    public:
        int *arr;

        ClassA(int len){
            arr = new int[len];
        }

        ClassA(){
        }

        ~ClassA(){
            delete [] arr;
        }
};

int main(){
    ClassA var_a;
    ClassA var_b;
    var_a = ClassA(8);
    var_b = ClassA(8);
    cout << var_a.arr<< endl;
    cout << var_b.arr<< endl;
}
```

</br>

<!--more-->


运行结果:
```cpp
0x55b10ca68e70
0x55b10ca68e70
```
居然一毛一样，问题出在哪里。

```cpp
var_a = ClassA(8);
var_b = ClassA(8);
```
这段代码会创建两个临时对象，当然也会new 两次数组，但是把成员变量拷贝给var_a之后，临时对象的析构函数会被调用，new出来的数组也会被delete。对var_b赋值的时候，又创建一个临时对象，再new一个数组，new请求的是堆内存，因为上一个临时对象申请的堆内存已经被释放，所以大概率会分配给本次的new申请，所以出来的两个指针地址是一样的。

结论就是，不要使用这种方式对含有动态内存的类进行赋值。

