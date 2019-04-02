---
title: Learn Spring - BeanPostProcessor
date: 2018-01-18T16:30:00+08:00
description: "Spring BeanPostProcessor"
categories: ["Spring"]
featuredImage: "attachments/spring-by-pivotal.png"
dropCap: true
displayInMenu: false
displayInList: true
draft: false
---

### About BeanPostProcessor

通过`BeanPostProcessor`接口可以实现自己的实例化逻辑。可以在`Bean`实例化的前后添加操作。`ApplicationContext`会自动检测实现了`BeanPostProcessor`接口的`Bean`,并将其注册为`PostProcessor`。

### 工作原理

![BeanPostProcessor_how_works](../../static/img/Spring/BeanPostProcessor/BeanPostProcessor_how_works.svg)

<!--more-->

### Example

#### 目录结构

![project_tree](../../static/img/Spring/BeanPostProcessor/project_tree.png)

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

    public void init(){
        System.out.println("Bean is going through init!");
    }

    public void destroy(){
        System.out.println("Bean will be destroy!");
    }
}
```

##### InitHelloSpring.java

```java
package me.coolcodes;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.BeanPostProcessor;

public class InitHelloSpring implements BeanPostProcessor{
    @Override
    public Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException {
        System.out.println("Before initialization: Hello Spring!");
        return bean;
    }

    @Override
    public Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
        System.out.println("After initialization: Hello Spring!");
        return bean;
    }
}
```

`InitHelloSpring`实现了`BeanPostProcessor`接口，程序运行时会被`ApplicationContext`自动检测，并注册为一个`PostProcessor`。其`postProcessBeforeInitialization()`方法会被在`Bean`实例化前调用，`postProcessAfterInitialization()`方法会被在`Bean`实例化完成后调用。

##### Main.java

```java
package me.coolcodes;

import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class Main {
    public static void main(String[] args) {
        AbstractApplicationContext context = new ClassPathXmlApplicationContext("Beans.xml");
        HelloSpring obj = (HelloSpring) context.getBean("helloSpring");

        obj.getMessage();

        context.registerShutdownHook();
    }
}
```

`ApplicationContext`类的`registerShutdownHook()`确保`destroy`方法能被正确调用。

##### Beans.xml

```xml
<?xml version = "1.0" encoding = "UTF-8"?>

<beans xmlns = "http://www.springframework.org/schema/beans"
       xmlns:xsi = "http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation = "http://www.springframework.org/schema/beans
   http://www.springframework.org/schema/beans/spring-beans-3.0.xsd">

    <bean id = "helloSpring" class = "me.coolcodes.HelloSpring" scope="singleton" init-method="init" destroy-method="destroy">
        <property name = "message" value = "Hello World!"/>
    </bean>

    <bean class="me.coolcodes.InitHelloSpring"></bean>

</beans>
```

为`InitHelloSpring`声明一个`bean`。

### 结果

![result](../../static/img/Spring/BeanPostProcessor/result.png)