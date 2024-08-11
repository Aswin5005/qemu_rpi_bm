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

So you need to provide the Image base address at 0x80000 in the **linker** file  
~~~
SECTIONS
{
	. = 0x80000;
	.text.entry : { *(.text.entry) }
	.text : { *(.text) }
	.rodata : { *(.rodata) }
	.data : { *(.data) }
	. = ALIGN(0x8);
	bss_begin = .;
	.bss : { *(.bss*) } 
	bss_end = .;
}
~~~

##### Execution Entry
RaspberryPi-3b uses BCM2837 SoC which has Quad core **Cortex-A53** CPU Cluster, so obviously the architecture is ARMv8-A. So you have to refer the ARMv8-A Technical Reference Manual then and there to understand the architecture.  
https://developer.arm.com/documentation/ddi0487/latest/

~~~
.section ".text.entry"
.global processor_entry

processor_entry:
	mrs  x0, MPIDR_EL1	// Read multiprocessor affinity register
	and  x0, x0, #0xff	// mask affinity level 0
	cbnz x0, inf_loop	// branch to infinite loop for cpu_id 1,2,3

	//CPU 0 continues from here
	mov  x0, #0xA0000	// Set stack pointer address to some higher address
	mov  sp, x0
	bl   main			// branch to main function
	b inf_loop

inf_loop:
	b inf_loop
~~~

Since there are 4x CPUs, we are not going to use all 4 in this example, we will just use **CPU0**  
For that we need to read the MPIDR_EL1 Register to get the CPU ID. Once we get the CPU ID, apart from CPU0 all other CPUs are branched to an infinite loop.
Then for CPU0 we set the Stack Pointer to some arbitarily little bit higher address (here I just used 0xA0000)  
Now we branch to the main() function where I use Mini UART to print a **Hello World from QEMU** message.  
Note: I didn't setup the UART registers and still if I use the UART buffer to send the characters its working, so that means the bootloader might be setting up the UART already before the Kernel entry.

Also I intentionally dereference a reserved memory region to demonstrate a **Synchronous Exception** which
you can refer to ***/src/main.c***

#### Building the Source**
You can just run **make all** to build the sources and **make clean** to clean the sources

## Emulating with QEMU
You can start QEMU for AArch64 with ***qemu-system-aarch64****, which is located in the **/build** folder of QEMU installation directory  
I have added a shell script to start QEMU from terminal,
~~~
qemu-system-aarch64 -s -S -machine raspi3b -nographic -kernel kernel8.img -serial null -serial mon:stdio
~~~

**Description of the Flags**  
-s              shorthand for -gdb tcp::1234  
-S              freeze CPU at startup  
-kernel         built kernel image  
-nographic      disable graphical output and redirect serial I/Os to console  
-machine        select the hardware to be emulated  
-serial dev     redirect the serial port to char device 'dev'  

I have included **start.sh** script to start the QEMU to load the built kernel8.img to RaspberryPi-3b.  
Once you execute this script, you will see the terminal like this  



