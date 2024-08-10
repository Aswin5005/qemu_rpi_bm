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

