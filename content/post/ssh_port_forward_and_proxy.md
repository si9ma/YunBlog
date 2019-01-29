---
title: 通过SSH登录内网机器和访问内网网站
date: 2018-12-28T22:48:48+08:00
description: "SSH穿越学习"
categories: ["Tool"]
featuredImage: "attachments/ssh.jpg"
dropCap: true
displayInMenu: false
displayInList: true
draft: false
---

对于个人用户来说，大部分都是在NAT后面的，没有公共IP。无法直接从外网直接访问内网机器。SSH提供了端口转发功能，可以通过SSH端口转发实现内网的访问。

## NAT

`NAT`主要是用于解决IPv4的IP不够用的问题，也就是多个内网IP对应一个公网IP。对于一个IP来说一共有65536个端口，可以这样做:`内网IP1:7843`的请求过来把它替换成`公网IP:88端口`去访问外部网站，`内网IP2:78778`的请求过来把它替换成`公网IP：82端口`去访问。这样就实现了一个公网IP的复用。`NAT`在内网机器和外网做了一个隔离，外网直接发起的连接并不会转发到内网机器。

## SSH隧道

要想外网访问内网其实很简单，就TCP来说，我内网主动发起一个TCP连接，然后内网机器和外网机器一直保持这个TCP连接，这样外网机器通过这个TCP连接是能连接上内网机器的。SSH就是基于TCP的，内网发起一个SSH请求，然后一直不断，就是一个持久的TCP连接。再配合SSH的端口转发就可以实现外网访问内网。

## 使用SSH访问内网

![未命名文件.png](/attachments/0d9da5fe.png)

### 目标机器B

```sh
ssh -fNCTR 223:localhost:22 root@vps_ip
ssh -fNCTR 1080:localhost:8080 root@vps_ip
```

参数:

- `f`:后台运行
- `N`:不要执行远程命令
- `C`:压缩数据
- `T`:不要进入远程终端

向vps建立一个SSH连接，并且告诉vps上的SSH进行端口转发：`你本地223(1080)端口上的请求都转发到我的22(8080)端口上`
<br>

```sh
ssh -D 8080  root@localhost
```

在本地建8080端口上建立一个sock服务，sock服务用来代理http请求。

### VPS

```sh
ssh -fNCTL *:222:localhost:223 root@localhost
```

把来自任意IP的到222端口的数据转发到223端口

```sh
delegated -P8080 SERVER=https SOCKS=localhost:1080 ADMIN=foo@bar.baz PERMIT="*:*:*"
```

delegated用于将https请求转换成sock请求,具体见[DeleGate](http://www.delegate.org/delegate/)

### 机器A

```sh
ssh root@vps_ip -p 222
```

向vps的222端口发起一个ssh请求

### 浏览器

在Chrome或Firefox中配置http代理为`http://vps_ip:8080`

### 登录目标机器B

{{< sizeimg src="/attachments/719f652e.png" size="50" >}}

<!-- @startuml
start

->
:ssh到vps的222端口>
->
:vps将222端口的请求转发到223端口>
->
:vps通过已经建立的SSH连接转发到机器B的22端口>
->
:连接成功>
->

stop
@enduml -->

### 访问机器B内网网站

{{< sizeimg src="/attachments/032da313.png" size="60" >}}

<!--@startuml
start

->
:浏览器中的请求通过配置的代理转发到vps的8080端口>
->
:delegated把http请求转换成sock请求转发到1080端口>
->
:vps通过已经建立的SSH连接将sock请求转发到机器B的8080端口>
->
:机器B访问网站,返回结果>
->

stop
@enduml -->
