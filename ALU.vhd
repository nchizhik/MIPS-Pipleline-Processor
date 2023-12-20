library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity ALU is 
port(
       SrcAE  : in  std_logic_vector(31 downto 0);
       SrcBE  : in  std_logic_vector(31 downto 0);
       ALUOutE : out std_logic_vector(31 downto 0);
       ALUControlE : in std_logic_vector(2 downto 0)
    );
end entity ALU;


architecture arc_ALU of ALU is
begin 
ALUOutE <= (SrcAE AND SrcBE) when ALUControlE =  "000" else
           (SrcAE OR SrcBE)  when ALUControlE =  "001" else
		   (SrcAE + SrcBE)   when ALUControlE =  "010" else
		   (SrcAE - SrcBE)   when ALUControlE =  "110" else 
		   
		   x"00000000" when (ALUControlE =  "111") and (SrcAE >= SrcBE) else
		   x"00000001" when (ALUControlE =  "111") and (SrcAE < SrcBE) else		 
			 			
			
           (others => '0');



end architecture arc_ALU;