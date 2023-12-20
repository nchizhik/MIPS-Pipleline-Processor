library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity imem is
port ( pc_imem: in std_logic_vector(31 downto 0);
       instr: out std_logic_vector(31 downto 0)
	  );
end entity imem;



architecture arc_imem of imem is
type mem_arr is array (natural range <>) of std_logic_vector(instr'range);
----------------------------------------------------------------------------we need to turn it back to normal>
signal instruction_mem: mem_arr((2**8)-1 downto 0):= 
(
0=>"00100000000010100000000000001111", --addi $t2 $0 0x000f ,  t2<=15
1=>"00100001010010000000000000000111", --addi $t0 $t2 0x0007 ,  t0<=7+15 = 22
2=>"00100001000010110000000000000000", --addi $t3 $t0 0x0000 ,  t3<=t0 =22
3=>"10101101001010100000000000000000", --sw $t2 0x0000($t1) ,  t2 write to mem
4=>"00000001010000000111100000100010", --sub $t7 $t2  $0   ,  t7<=t2= 15
5=>"10101101010010000000000000000000", --sw $t0 0x0000($t2) ,  t0 write to mem
6=>"00000001111010100110000000100010", --sub  $t4 $t7 $t2 ,  t4<=0
7=>"10001101001011100000000000000000", --lw $t6 0x0000($t1)  ,  t6 get the t2 val
8=>"00000000000000000000000000000000", --null
9=>"00010001111010100000000000000000", --beq $t7 $t2 0x0000 , if true return to start, true in this case! --t1 isn't available yet
10=>"00000000000000000000000000000000", --null
11=>"00000000000000000000000000000000", --null
12=>"00000000000000000000000000000000", --null
13=>"00000000000000000000000000000000", --null
others=>(others=>'0')
);
begin
   instr<=instruction_mem(conv_integer(pc_imem(9 downto 2)));
end architecture arc_imem;	 







 

 


