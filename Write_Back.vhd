--Write_Back
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity Write_Back is 
port(
    --Input         
        ALUoutW: in std_logic_vector(31 downto 0);
        ReadDataW: in std_logic_vector(31 downto 0);  
        WriteRegW: in std_logic_vector(4 downto 0); -- HAZARD UNIT
        -- control    
        RegWriteW: in std_logic;
        MemToRegW: in std_logic; 
		
		--Output 
        RegWriteW_out: out std_logic;
        WriteRegW_out: out std_logic_vector(4 downto 0); --  output  HAZARD UNIT
        ResultW: out std_logic_vector(31 downto 0) --HAZARD UNIT 	
    ); 
end entity Write_Back;

architecture arc_WB of Write_Back is
begin 

RegWriteW_out<=RegWriteW;
WriteRegW_out<=WriteRegW;

ResultW <=ReadDataW when  MemToRegW='1' else
          ALUoutW   when  MemToRegW='0';



end architecture arc_WB;