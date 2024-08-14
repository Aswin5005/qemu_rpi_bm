#include "mem.h"

.section ".text.entry"
.global processor_entry

processor_entry:
	MRS		x0, MPIDR_EL1	// Read multiprocessor affinity register
	AND		x0, x0, #0xff	// mask affinity level 0
	CBNZ	x0, inf_loop	// branch to infinite loop for cpu_id 1,2,3

	//CPU 0 continues from here
	BL		setup_kernel_space_mmu
	MOV		x0, SP_TOP		// Set stack pointer address to some higher address
	MOV		sp, x0
	BL		main			// branch to main function
	B		inf_loop


setup_kernel_space_mmu:
	ADRP	x0, page_table_l1	//x0 has PC relative address of page_table_l1
	MOV		x2, x0
	MOV		x1, xzr
	ORR		x1, x1, #3
	LSL		x2, x2, #12
	ORR		x1, x1, x2
	STR		x1, [x0]

	RET










inf_loop:
	b inf_loop

