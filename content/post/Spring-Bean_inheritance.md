---
title: Learn Spring - Bean配置继承(配置重用)
date: 2018-01-19T14:30:00+08:00
description: "Spring Bean配置继承学习"
categories: ["Spring"]
featuredImage: "attachments/spring-by-pivotal.png"
dropCap: true
displayInMenu: false
displayInList: true
draft: false
---

### 关于Bean配置继承

为了`Bean`配置的复用，`Spring`中有`Bean`配置继承的概念。通过`parent`属性标识从哪个`Bean`继承配置信息。类似于面向对象里的概念，子`Bean`可以覆盖父`Bean`的配置。还可以设置`Bean`配置的 `abstract`属性为`true`，将该`Bean`设置为一个模板，其它`Bean`继承它的模板配置。类似于`Java`中的抽象类，`abstract`的`Bean`不允许实例化。

<!--more-->

### Example

#### 目录结构

![project_tree](/attachments/Spring/BeanInheritance/project_tree.png)

#### Code

##### Beans.xml

```xml
<?xml version = "1.0" encoding = "UTF-8"?>

<beans xmlns = "http://www.springframework.org/schema/beans"
       xmlns:xsi = "http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation = "http://www.springframework.org/schema/beans
   http://www.springframework.org/schema/beans/spring-beans-3.0.xsd">

    <bean id = "helloWorld" class = "me.coolcodes.HelloWorld">
        <property name = "message1" value = "Message1"/>
        <property name = "message2" value = "Message2"/>
    </bean>

    <bean id="helloSpring" class="me.coolcodes.HelloSpring" parent="helloWorld">
        <property name = "message3" value = "Message3"/>
        <property name = "message4" value="Message4"></property>
    </bean>

</beans>
```

`helloSpring`继承了`helloWorld`的配置（即`message1` 和 `message2`)

##### HelloWorld.java

```java
package me.coolcodes;

public class HelloWorld{
    private String message1;
    private String message2;

    public void setMessage1(String message){
        this.message1  = message;
    }

    public void setMessage2(String message){
        this.message2  = message;
    }

    public void getMessage1(){
        System.out.println("World Message : " + message1);
    }

    public void getMessage2(){
        System.out.println("World Message : " + message2);
    }
}
```

##### HelloSpring.java

```java
package me.coolcodes;

public class HelloSpring {
    private String message1;
    private String message2;
    private String message3;
    private String message4;

    public void setMessage1(String message){
        this.message1  = message;
    }

    public void setMessage2(String message){
        this.message2  = message;
    }

    public void setMessage3(String message){
        this.message3  = message;
    }

    public void setMessage4(String message){
        this.message4  = message;
    }

    public void getMessage1(){
        System.out.println("Spring Message : " + message1);
    }

    public void getMessage2(){
        System.out.println("Spring Message : " + message2);
    }

    public void getMessage3(){
        System.out.println("Spring Message : " + message3);
    }

    public void getMessage4(){
        System.out.println("Spring Message : " + message4);
    }
}
```

##### Main.java

```java
package me.coolcodes;

import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class Main {
    public static void main(String[] args) {
        AbstractApplicationContext context = new ClassPathXmlApplicationContext("Beans.xml");
        HelloWorld objA = (HelloWorld) context.getBean("helloWorld");
        HelloSpring objB = (HelloSpring) context.getBean("helloSpring");

        objA.getMessage1();
        objA.getMessage2();

        objB.getMessage1();
        objB.getMessage2();
        objB.getMessage3();
        objB.getMessage4();
    }
}
```

分别输出`HelloWorld`的`message1` 和 `message2`。`HelloSpring`的`message1`、`message2`、`message3`、`message4`。

#### 结果

![result](/attachments/Spring/BeanInheritance/result.png)

`HelloSpring`的`message1`和`message2`的值继承自`HelloWorld`。
