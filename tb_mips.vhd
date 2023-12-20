library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity tb_mips is 
end entity tb_mips;

architecture arc_tb_mips of tb_mips is 
component mips is 
port (   clk      : in std_logic;
         rst   : in std_logic);
end component mips;

signal clk:  std_logic:='0';
signal rst: std_logic:='0';

   -- Clock period definition
   constant clk_period : time := 40 ns;
 begin 
 u1: mips PORT MAP (clk,rst);
  
   -- Clock process definitions
   clk_process :process
   begin
		clk <= '1';
		wait for clk_period/2;
		clk <= '0';
		wait for clk_period/2;
   end process;
   
      stim_proc: process
	
   begin		
		
		rst <= '1';
	    wait for 1 ns;
		rst <= '0';		
	    wait;
	  
   end process;
end architecture arc_tb_mips;
-----------------------------------------------------------------------------------