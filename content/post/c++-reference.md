---
title: C++之引用
date: 2018-09-09T07:00:00+08:00
description: "C++ 引用学习"
categories: ["C++"]
featuredImage: "/img/product_10337_product_shot_wide_image.jpg"
dropCap: true
displayInMenu: false
displayInList: true
draft: false
---

很久没写博客了，感觉自己很久没有静下心来认真学习了，今天一起合租的舍友都走了，一个人静下心来学习了一天，写写博客。

### 引用

引用是C++较C新增的一个概念，今天简单研究了下引用的实现。

<!-- more -->

先写一小段代码看看：
```cpp
#include <iostream>

int main(void) {
    using namespace std;

    int a = 5;
    int & d=a;
    d=8;

    cout << d;
    cout << a;
}
```

看一下它的汇编代码，有点长，就只看跟引用有关那一部分吧：
```x86asm
    movl    $5, -20(%rbp)
    leaq    -20(%rbp), %rax
    movq    %rax, -16(%rbp)
    movq    -16(%rbp), %rax
    movl    $8, (%rax)
```
从汇编代码中可以看出来，引用也占用了内存空间了，并且这个引用里面存的是变量a的地址（`leaq`取址)。

诶，怎么有点像指针呢，那再写一段代码看看：
```cpp
#include <iostream>

int main(void) {
    using namespace std;

    int a = 5;
    int *d= &a;
    *d=8;

    cout << *d;
    cout << a;
}
```

汇编一下；
```x86asm
movl	$5, -20(%rbp)
leaq	-20(%rbp), %rax
movq	%rax, -16(%rbp)
movq	-16(%rbp), %rax
movl	$8, (%rax)
```

诶，巧了，一毛一样，不太确定，diff一下
```bash
diff -y pointer.s reference.s | colordiff
```

```x86asm
.file   "pointer.cpp"                                 |         .file   "reference.cpp"
```

诶，只有第一行不一样。

### SO

所以，C++里面的引用和指针实现是类似的，都是存了地址。只是它们的语法定义、声明方式和使用方式不一样而已，但这些区别只是对编译器来说有区别，它们最终的汇编代码是一样哒。

---
