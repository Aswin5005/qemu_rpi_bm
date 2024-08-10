
/* Mini UART Registers */
#define AUX_MU_IO_REG	((volatile unsigned int *)0x3F215040)
#define AUX_MU_STAT_REG ((volatile unsigned int *)0x3F215064)

char *str = "Hello World from QEMU\n";

void send_char (char c)
{
	*AUX_MU_IO_REG = c;
	while((*AUX_MU_STAT_REG & (1 << 1)) == 0);
}

int main ()
{
	int i = 0;

	while(str[i] != 0)
	{
		send_char(str[i]);
		i++;
	}

	// Intentionally dereference a reserved memory location
	// which results in Synchronous Exception
	*((unsigned int *)0x7FFFFFFF) = 0xDEADBEEF;

	return 0;
}
















