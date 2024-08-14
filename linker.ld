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
	. = ALIGN(4096);
	page_table_l0 = .;
	. = ALIGN(4096);
	page_table_l1 = .;
	. = ALIGN(4096);
	page_table_l2 = .;
}
