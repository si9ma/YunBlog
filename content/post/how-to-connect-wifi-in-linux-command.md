---
title: 怎么在Linux使用命令行连接WIFI
date: 2018-03-15T19:00:02+08:00
description: "在Linux命令行中连接WIFI"
categories: ["Linux"]
featuredImage: "attachments/linux-1-800x420.jpg"
dropCap: true
displayInMenu: false
displayInList: true
draft: false
---

### 工具

- wpa_supplicant
- dhclient

### 找出网卡设备名称

使用以下命令获取WIFI网卡名称：

```bash
cat /proc/net/wireless | perl -ne '/(\w+):/ && print $1'
```

<!-- more -->

### 启用无线网卡

使用以下命令启用无线网卡:

```bash
ip link set wlan0 up
```

`wlan0`为网卡名称，请自行替换。

### 设置密码

在`/etc/wpa_supplicant.conf`中填入一下内容：

```bash
network={
    ssid="ssid_name"
    psk="password"
}
```

如果是使用`PEAP`认证的WIFI，请填入一下内容：

```bash
network={
  ssid="YOUR_SSID"
  scan_ssid=1
  key_mgmt=WPA-EAP
  identity="YOUR_USERNAME"
  password="YOUR_PASSWORD"
  eap=PEAP
  phase1="peaplabel=0"
  phase2="auth=MSCHAPV2"
}
```

### 连接WIFI

输入命令：

```bash
sudo wpa_supplicant -B -iwlan0 -c/etc/wpa_supplicant.conf -Dwext
sudo dhclient wlan0
```

`wlan0`为网卡名称，请自行替换。

### 测试

```bash
ping www.baidu.com
```

---
