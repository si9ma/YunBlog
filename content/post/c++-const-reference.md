---
title: C++之const引用
date: 2018-09-09T08:00:00+08:00
description: "C++ const引用学习"
categories: ["C++"]
featuredImage: "/img/product_10337_product_shot_wide_image.jpg"
dropCap: true
displayInMenu: false
displayInList: true
draft: false
---

C++里面的引用都必须指向有址可寻的左值，那么怎么才能赋非左值呢，那就是const引用。

## const 引用

对于引用，当所赋的值为:
- 非左值
- 数据类型不匹配

的时候，应该创建临时变量。

把这个临时变量赋给引用是不合理的，因为按理来说通过引用是能修改数据的，但是如果数据类型不一致导致创建了临时变量，最后修改的是临时变量的数据，而不是我们所想修改的数据。

但是把临时变量赋给const引用是合理的，反正都不能改数据。

<!-- more -->

写段代码看看:
```cpp
#include <iostream>

int main(void) {
    using namespace std;

    const int &a = 5;
}
```

汇编一下:
```x86asm
	movl	$5, %eax
	movl	%eax, -20(%rbp)
	leaq	-20(%rbp), %rax
	movq	%rax, -16(%rbp)
```

可以看到，创建了临时变量，并把临时变量的地址赋给引用。

---
