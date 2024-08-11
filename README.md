## Emulating RaspberryPi-3B with QEMU
This example let's you get started with a simple baremetal boot of RaspberryPi-3B on QEMU-9.0.90.

### QEMU
QEMU is a free and open source project which lets you emulate various hardware platforms.
You can quickly setup QEMU with the below mentioned steps
~~~
1. wget https://download.qemu.org/qemu-9.1.0-rc1.tar.xz
2. tar xvJf qemu-9.1.0-rc1.tar.xz
3. cd qemu-9.1.0-rc1
4. ./configure
5. make
~~~
These steps are also mentioned in the QEMU website, you can also refer from there.

### Building the source

For building the sources, I'm using ARM GNU Toolchain which provides free and open source tools like gnu-gcc(compiler), gnu-as(assembler), gnu-ld(linker), gnu-objdump(a tool which you can use to disassemble), gnu-gdb(A free debugger)

You can download it from :
~~~
https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads/13-2-rel1
~~~
I'm using Ubuntu 22.04.4 LTS on a x86_64 host machine through Oracle VM Virtualbox, so I have downloaded the below mentioned tarball
**arm-gnu-toolchain-13.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz** 

GDB might require some prerequisites like Python3.8 and libncursesw5 shared library, please follow the instructions below to get it fixed
**https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads/13-2-rel1#installing-on-linux**

### Exploring the Source
I was googling about where the kernel is loaded in memory for RaspberryPi-3b and found out to be at address **0x80000**.
I have also confirmed with GDB, which you can see below,



