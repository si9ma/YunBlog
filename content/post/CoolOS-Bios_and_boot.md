---
title: 自制操作系统(CoolOS) - 操作系统启动过程与BIOS
date: 2017-08-09T09:25:40+08:00
description: "自制操作系统，BIOS和BOOT部分，讲解了计算机的Bios启动过程"
categories: ["CoolOS"]
featuredImage: "attachments/bios.jpeg"
dropCap: true
displayInMenu: false
displayInList: true
draft: false
---

### BIOS

BIOS即Basic input/output system(基本输入输出系统)其实就是一个程序。只不过这个程序存储在了计算机主板的一个ROM芯片上(现在一般用flash芯片,可读可写，方便BIOS的更新)，所以它也是一个固件(firmware)。主要用于计算机启动过程中的硬件初始化和硬件检测，以及操作系统的启动。被认为是计算机启动过程中运行的第一个程序。不过因为BIOS的一些缺点和限制，Intel又开发了EFI（现在的UEFI）来替代BIOS。UEFI相比BIOS有了很大的提升，而且更加灵活。BIOS正逐步被UEFI替代。



<!-- more -->


不过我们今天要说的还是BIOS(".")。

我们个人电脑里面的BIOS由各个供应商提供的，所以每个电脑的BIOS可能是有差异的。BIOS信息在Linux中可用以下命令查看:
```bash
dmidecode bios | less
```
这是我的电脑上的输出：
```bash
# dmidecode 3.1
Getting SMBIOS data from sysfs.
SMBIOS 2.8 present.
94 structures occupying 5414 bytes.
Table at 0x000EDA30.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
        Vendor: Dell Inc.
        Version: 1.2.4
        Release Date: 03/03/2017
        Address: 0xF0000
        Runtime Size: 64 kB
        ROM Size: 16 MB
		......
```
可以看到，我的电脑的BIOS的供应商(vendor)是DELL，因为我的电脑是DELL的。

同时，主板上还有一个用于存储BIOS配置的RAM，叫CMOS。这个RAM也是易失的，但是主板上有一个电池一直给它供电，那样它就变成不易失的了。据说这个电池至少也能撑3-4年。所以说，如果这个电池没电了，那么你的所以BIOS配置都没了，什么启动顺序啦都没了。你要是不给它换电池，BIOS就只能一直使用默认设置咯。

关于BIOS的一些规范可以参考**[BIOS Boot Specification](https://acpica.org/sites/acpica/files/specsbbs101.pdf)**。

### 操作系统启动过程

我们平日里使用的Linux，Windows，Mac系统并不是在按下电源后就立即启动的。我们可以看到,它需要一个启动的过程，少则需要几秒（SSD就是好），多则需要1分多钟。

操作系统的启动主要步骤如下：

- PSU启动及初始化。PSU即Power supply unit(供电单元)。当我们按下计算机开机按钮后，PSU启动。当电压值稳定、设备可接受(+5V)，即PSU准备好给主板和其他设备供电时，PSU向主板发送一个“Power Good”信号。"Power Good"信号由CPU的定时器芯片(timer chip)接收。timer chip控制了CPU的复位线。在接收到"Power Good"信号后，timer chip向CPU发送一个复位信号。

- CPU初始化。CPU收到复位信号后，进行内部初始化。CPU进入一个类似于实模式的特殊模式。在这个模式下，CPU可以访问大于1M的内存**空间**。
```
When the processor is first powered-on, it will be in a special mode similar to
Real Mode, but with the top 12 address lines being asserted high, allowing
boot code to be accessed directly from NVRAM (physical address
0xFFFxxxxx). Upon execution of the first long jump, these 12 address lines
will be driven according to instructions by firmware. If one of the Protected
Modes is not entered before the first long jump, the processor will enter Real
Mode, with only 1MB of addressability. In order for Real Mode to work
without memory, the chipset needs to be able to alias memory below 1MB to
just below 4GB, to continue to access NVRAM. Some chipsets do not have
this aliasing and a forcible switch to a normal operating mode will be required
before performing the first long jump.
```
   以上内容来自 **[Minimal Intel Architecture Boot Loader](https://www.cs.cmu.edu/~410/doc/minimal_boot.pdf)**

   之后，CPU将到特定的位置去找第一条指令。第一条指令为跳转指令，用于跳转到紧接着需要执行的BIOS代码的位置。那么CPU去哪里找这条指令呢？我们称这条指令所在的位置为**[复位向量(reset vector)](https://en.wikipedia.org/wiki/Reset_vector)**。复位向量主要有三种情况：
 - 对于8086处理器，复位向量为FFFF0h。所以为了执行上面说的第一条指令，CPU初始化过程中，会将CS设置为FFFFh，IP设置为0000h。分段地址为FFFFh:0000h。
 - 对于80286处理器，复位向量为00FFFF0h。CS初始化为F000h，IP初始化为FFF0h。分段地址为FFFFh:0000h。
 - 对于80386及之后处理器，复位向量为FFFFFFF0h。CS初始化为F000h，CS的基本部分为FFFF0000h,IP初始化为FFF0h。分段地址为FFFF0000h:FFF0h(由CS基本部分和IP组成)。

  其实,复位向量都会被映射到ROM中,因为这条跳转指令是存储在BIOS中的,并且我们平时所说的那个内存(DRAM)是还没有初始化的。

- 执行BIOS代码。CPU先执行第一条跳转指令(长跳转,far jump)，跳转到实际需要执行的BIOS代码处，开始执行。

- 开机自检(POST)。开机自检(power on self test)过程会初始化、检测一系列计算机的组件。如果遇到错误，比如找不到内存，POST将停止，并显示错误信息。其它一些设备也会有自己的BIOS，这些设备的BIOS在POST过程中也会被执行。

- 拷贝BIOS到内存中。POST完成后，将BIOS拷贝到内存中，以便更快地访问BIOS。

- 启动操作系统。BIOS根据CMOS中的启动优先级确定第一个启动设备IPL(initial program load),然后将启动设备的第一个扇区的内容拷贝到内存的0X7C00处。然后跳转到0X7C00处，执行后续代码。

---

### 参考
[1]**[system Boot Sequence](http://www.pcguide.com/ref/mbsys/bios/bootSequence-c.html)**
[2]**[BIOS-wikipedia](https://en.wikipedia.org/wiki/BIOS)**
[3]**[The Booting Process of the PC](http://www.comptechdoc.org/hardware/pc/pcboot.html)**
[4]**[How Computers Boot Up](http://duartes.org/gustavo/blog/post/how-computers-boot-up/)**
[5]**[Minimal Intel Architecture Boot Loader](https://www.cs.cmu.edu/~410/doc/minimal_boot.pdf)**
