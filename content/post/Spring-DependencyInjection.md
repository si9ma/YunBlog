---
title: Learn Spring - 依赖注入(Dependency Injection)
date: 2018-01-19T17:30:00+08:00
description: "Spring 依赖注入"
categories: ["Spring"]
featuredImage: "attachments/spring-by-pivotal.png"
dropCap: true
displayInMenu: false
displayInList: true
draft: false
---

### 什么是依赖注入

![DependencyInjection](/attachments/Spring/DependencyInjection/DependencyInjection.svg)

面向对象中，系统功能都是通过一系列对象之间的协作完成的。为了降低系统的复杂度，增加代码的复用性，方便测试。应该尽量降低类与类之间的关联度，降低耦合度。类与类之间的关联很多时候是不可避免的。如上图，如果A依赖于B，那么A中的b对象应该怎么实例化呢？两种方法：

- A自己负责b对象的实例化。但这样明显A和B之间的耦合度太高，如果B的实例化方法参数变更，就必须更改A中的代码。
- 由外部进行实例化，然后通过构造方法或set方法传入，即依赖注入（外部把依赖项注入到其中）。这明显好于第一种方法。`Spring`框架就是这么干的。但`Spring`框架是通过`Bean`配置来表达传入的参数的,如上图。

`Spring`中的依赖注入有两种实现方法。即：

- 构造方法
- set方法

<!--more-->

### 通过构造方法实现

#### Bean配置格式

```xml
<bean id="a" class = "me.coolcodes.A">
    <constructor-arg index="0" ref = "b"></constructor-arg>  <!-- "value"用于常量值，"ref"用于其他Bean     还可以用type表示参数数据类型 -->
</bean>

<bean id="b" class = "me.coolcodes.B"></bean>
```

通过`constructor-arg`表示构造函数参数，有几个参数就写几个`constructor-arg`。顺序必须和对应类的构造方法参数顺序一致。为了避免顺序不一致，可以使用`index`属性标识顺序。

还可以把第二个bean放到`constructor-arg`中,变成内部Bean(`inner Bean`)：

```xml
<bean id="a" class = "me.coolcodes.A">
    <constructor-arg index="0">
        <bean id="b" class = "me.coolcodes.B"></bean>
    </constructor-arg>
</bean>
```

#### Example

##### 类图

![classDiagram](/attachments/Spring/DependencyInjection/classDiagram.svg)

##### 目录结构

![constructor_project_tree](/attachments/Spring/DependencyInjection/constructor_project_tree.png)

##### Code

###### Beans.xml

```xml
<?xml version = "1.0" encoding = "UTF-8"?>

<beans xmlns = "http://www.springframework.org/schema/beans"
       xmlns:xsi = "http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation = "http://www.springframework.org/schema/beans
   http://www.springframework.org/schema/beans/spring-beans-3.0.xsd">

    <bean id = "classA" class = "me.coolcodes.ClassA">
        <constructor-arg index="0" ref="classB"></constructor-arg>
    </bean>

    <bean id="classB" class="me.coolcodes.ClassB"></bean>
</beans>
```

`ClassA`依赖于`ClassB`。

###### ClassA.java

```java
package me.coolcodes;

public class ClassA {
    private ClassB classB;

    public ClassA(ClassB classB){
        this.classB = classB;
    }

    public void print(){
        System.out.println("I am ClassA");
        classB.print();
    }
}
```

`ClassA`在构造方法中通过传入的`ClassB`对象设置`classB`。

###### ClassB.java

```java
package me.coolcodes;

public class ClassB {

    public ClassB(){
        // to do
    }

    public void print(){
        System.out.println("I am ClassB");
    }
}
```

###### Main.java

```java
package me.coolcodes;

import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class Main {
    public static void main(String[] args) {
        AbstractApplicationContext context = new ClassPathXmlApplicationContext("Beans.xml");
        ClassA classA = (ClassA) context.getBean("classA");

        classA.print();
    }
}
```

实例化一个`ClassA`对象的时候，`Spring`框架会实例化一个`ClassB`对象，并传给`ClassA`的构造方法。

##### 结果

![result](/attachments/Spring/DependencyInjection/result.png)

### 通过set方法实现

#### Bean配置格式

```xml
<bean id="a" class = "me.coolcodes.A">
    <property name="b" ref="b"></property> <!-- "value"指常量值，"ref"指其他Bean -->
</bean>

<bean id="b" class = "me.coolcodes.B"></bean>
```

`Spring`框架通过`name`调用相应的set方法，并将`ref`或`value`作为参数。

还可以把第二个Bean放到`property`中，变成内部bean（`inner bean`）：

```xml
<bean id="a" class = "me.coolcodes.A">
    <property name="b">
        <bean id="b" class = "me.coolcodes.B"></bean>
    </property>
</bean>
```

#### Example

##### 类图

![classDiagram](/attachments/Spring/DependencyInjection/classDiagram.svg)

##### 目录结构

![project_tree](/attachments/Spring/DependencyInjection/project_tree.png)

##### Code

###### Beans.xml

```xml
<?xml version = "1.0" encoding = "UTF-8"?>

<beans xmlns = "http://www.springframework.org/schema/beans"
       xmlns:xsi = "http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation = "http://www.springframework.org/schema/beans
   http://www.springframework.org/schema/beans/spring-beans-3.0.xsd">

    <bean id = "classA" class = "me.coolcodes.ClassA">
        <property name="classB" ref="classB"></property>
    </bean>

    <bean id="classB" class="me.coolcodes.ClassB"></bean>
</beans>
```

当实例化`ClassA`时，`Spring`框架会创建一个`ClassB`对象，并调用`ClassA`的`setClassB()`方法，以新创建的`ClassB`对象为参数。

###### ClassA.java

```java
package me.coolcodes;

public class ClassA {
    private ClassB classB;

    public ClassA(){
        // to do
    }

    public void setClassB(ClassB classB){
        this.classB = classB;
    }

    public void print(){
        System.out.println("I am ClassA");
        classB.print();
    }
}
```

`setClassB()`方法负责设置`classB`的值。

###### ClassB.java

```java
package me.coolcodes;

public class ClassB {

    public ClassB(){
        // to do
    }

    public void print(){
        System.out.println("I am ClassB");
    }
}
```

###### Main.java

```java
package me.coolcodes;

import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class Main {
    public static void main(String[] args) {
        AbstractApplicationContext context = new ClassPathXmlApplicationContext("Beans.xml");
        ClassA classA = (ClassA) context.getBean("classA");

        classA.print();
    }
}
```

##### 结果

![result](/attachments/Spring/DependencyInjection/result.png)

### 总结

两种方法的本质区别在于一个使用构造方法传参数，一个通过set方法传参数。
