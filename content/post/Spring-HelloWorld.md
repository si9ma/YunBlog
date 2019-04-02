---
title: Learn Spring - HelloWorld
date: 2018-01-17T14:20:00+08:00
description: "Spring HelloWorld"
categories: ["Spring"]
featuredImage: "attachments/spring-by-pivotal.png"
dropCap: true
displayInMenu: false
displayInList: true
draft: false
---

### 环境准备

- JDK 1.8+
- IntelliJ IDEA
- Spring框架([从Spring网站下载](https://repo.spring.io/release/org/springframework/spring/))

### 新建项目

#### 使用下载的Spring框架新建项目

解压下载的框架，选择`Use Library`，从解压的文件夹的`libs`子文件夹选择需要的模块(也可以选择`Download`等待`IDEA`下载)

<!--more-->

![New Project](../../static/img/Spring/HelloWorld/Spring_HelloWorld_create_new_project.png)

#### 设置项目名

设置项目名为`HelloWorld` 。

![Add Name](../../static/img/Spring/HelloWorld/Spring_HelloWorld_create_new_project_add_name.png)

#### 添加代码

##### 添加`me.coolcodes`包

在`src`文件夹下新建`me.coolcodes`包。

![add new package](../../static/img/Spring/HelloWorld/add_new_package.png)

##### 添加`HelloWorld.java`类

在`me.coolcodes`包中添加`HelloWorld`类

```java
package me.coolcodes;

public class HelloWorld {
    private String message;

    public void setMessage(String message){
        this.message  = message;
    }
    public void getMessage(){
        System.out.println("Your Message : " + message);
    }
}
```

`HelloWorld`类通过`getMessage()`方法打印`message`。

##### 添加`Main.java`类

在`me.coolcodes`包中添加`Main`类

```java
package me.coolcodes;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class Main {
    public static void main(String[] args) {
        ApplicationContext context = new ClassPathXmlApplicationContext("Beans.xml");
        HelloWorld obj = (HelloWorld) context.getBean("helloWorld");
        obj.getMessage();
    }
}
```

- `Main`通过`ClassPathXmlApplicationContext`读取`Beans.xml`文件`new`一个`ApplicationContext`对象。
- `context`通过ID创建一个`Bean`（即HelloWorld对象），并转换成`HelloWorld`对象。
- 调用`HelloWorld`对象的`getMessage()`方法打印`message`。

#### 添加`Bean`文件(Beans.xml)

在`src`文件夹下创建`Beans.xml`配置文件

```xml
<?xml version = "1.0" encoding = "UTF-8"?>

<beans xmlns = "http://www.springframework.org/schema/beans"
   xmlns:xsi = "http://www.w3.org/2001/XMLSchema-instance"
   xsi:schemaLocation = "http://www.springframework.org/schema/beans
   http://www.springframework.org/schema/beans/spring-beans-3.0.xsd">

   <bean id = "helloWorld" class = "me.coolcodes.HelloWorld">
      <property name = "message" value = "Hello World!"/>
   </bean>

</beans>
```

该`xml`文件定义了一个`Bean`，ID为`helloWorld`，对应于`me.coolcodes.HelloWorld`类。`message`对应的值是`Hello World!`。所以`Main`中`context`，通过`getBean()`方法根据ID创建一个`Bean`（即HelloWorld对象）,并通过`HelloWorld`的`setMessage()`方法设置`message`为`Hello World!`。所以最后程序的输出应该是`Hello World!`。

### 运行

#### 运行配置

添加一个新的`Application`配置，配置`Main`类

![run_config](../../static/img/Spring/HelloWorld/run_config.png)

#### 结果

如前面所说，最后输出结果为`Hello World!`

![result](../../static/img/Spring/HelloWorld/result.png)
