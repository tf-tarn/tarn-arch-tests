void _start()
{
  /* Initialize the stack and frame pointers. */
  asm ("ldi.l  $sp, 0x30000");
  asm ("ldi.l  $fp, 0x0");

  /* Call main()  */
  main();

  /* Terminate execution.  */
  asm ("bad");
}

int main()
{
  return 0x555;
}

int x; /* because the sim requires a .bss section. */
