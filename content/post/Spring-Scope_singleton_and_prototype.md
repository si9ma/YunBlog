---
title: Learn Spring - Bean Scope属性之singleton和prototype
date: 2018-01-17T16:30:00+08:00
description: "Spring Bean Scope属性"
categories: ["Spring"]
featuredImage: "attachments/spring-by-pivotal.png"
dropCap: true
displayInMenu: false
displayInList: true
draft: false
---

### Scope属性

`Spring Bean`配置中的`Scope`属性用于告诉`Ioc容器`创建`Bean`对象的范围，只能创建一个对象还是能够创建任意个对象。其值可以是`singleton`、`prototype`、`request`、`session`和`global-session`。`request`、`session`和`global-session`只有在web应用中才有效。这里只讲`prototype`和`singleton`。

### singleton和prototype区别

|singleton|prototype|
|-----|:-----|
|只能创建一个Bean实例，Ioc容器会对创建的实例进行缓存，下次请求创建时，返回缓存的实例|可以创建任意个实例|
|默认值|非默认值|

<!--more-->

### Singleton

#### 目录结构

![singleton_dir_tree](../../static/img/Spring/singleton_and_prototype/singleton_dir_tree.png)

#### Code

##### HelloSpring.java

```java
package me.coolcodes;

public class HelloSpring {
    private String message;

    public void setMessage(String message){
        this.message  = message;
    }
    public void getMessage(){
        System.out.println("Your Message : " + message);
    }
}
```

##### Main.java

```java
package me.coolcodes;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class Main {
    public static void main(String[] args) {
        ApplicationContext context = new ClassPathXmlApplicationContext("Beans.xml");
        HelloSpring objA = (HelloSpring) context.getBean("helloSpring");

        objA.setMessage("I am objA");
        objA.getMessage();

        HelloSpring objB = (HelloSpring) context.getBean("helloSpring");
        objB.getMessage();
    }
}
```

先通过`getBean()`创建一个`objA`，设置`message`为`I am objA`。然后再通过`getBean()`创建一个`objB`。如果`objA`和`objB`是不同的对象，最后输出应该是`I am objA \n Hello World!`。反之，如果是同一个对象，最后输出应该是`I am objA \n I am objA`。

##### Beans.xml

设置`scope`为`singleton`

```xml
<?xml version = "1.0" encoding = "UTF-8"?>

<beans xmlns = "http://www.springframework.org/schema/beans"
       xmlns:xsi = "http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation = "http://www.springframework.org/schema/beans
   http://www.springframework.org/schema/beans/spring-beans-3.0.xsd">

    <bean id = "helloSpring" class = "me.coolcodes.HelloSpring" scope="singleton">
        <property name = "message" value = "Hello World!"/>
    </bean>

</beans>
```

##### 结果

![singleton_result](../../static/img/Spring/singleton_and_prototype/singleton_result.png)

从结果可以看出，`objA`和`objB`是同一个对象。

### Prototype

只需要将`Beans.xml`中`scope`的值改为`prototype`

#### 结果

![prototype_result](../../static/img/Spring/singleton_and_prototype/prototype_result.png)

从结果可以看出，`objA`和`objB`是不同的对象。
