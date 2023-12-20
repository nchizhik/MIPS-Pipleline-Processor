--Forwarding unit 
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity Forwarding_Unit  is 
port(
    --Input         
        WriteRegM: in std_logic_vector(4 downto 0);
        WriteRegW: in std_logic_vector(4 downto 0);        
        RegWriteM: in std_logic; 
        RegWriteW: in std_logic; 
        RsE: in std_logic_vector(4 downto 0);
        RtE: in std_logic_vector(4 downto 0);
                 
    --Output
        
        Forward_AE: out std_logic_vector(1 downto 0); 
        Forward_BE: out std_logic_vector(1 downto 0);
        Forward_AD: out std_logic;
        Forward_BD: out std_logic    
    ); 

end entity Forwarding_Unit;

architecture arc_FU of Forwarding_Unit is
begin

 Forward_AE <= "10" when (RegWriteM ='1') and (WriteRegM /="00000") and (WriteRegM = RsE) else --Forwards from previous instruction
               "01" when (RegWriteW ='1') and (WriteRegW /="00000") and (WriteRegM /= RsE) and  (WriteRegW = RsE) else --from 2 instructions back
			      "00" ;
 Forward_BE <= "10" when (RegWriteM ='1') and (WriteRegM /="00000") and (WriteRegM = RtE) else --Forwards from previous instruction
               "01" when (RegWriteW ='1') and (WriteRegW /="00000") and (WriteRegM /= RtE) and  (WriteRegW = RtE) else --from 2 instructions back
			      "00" ;
 Forward_AD <= '1' when (RegWriteM='1') and (WriteRegM /="00000") and (WriteRegM = RsE) else -- Branch forward from previous instruction
               '0';
 Forward_BD <= '1' when (RegWriteM='1') and (WriteRegM /="00000") and (WriteRegM = RtE) else -- Branch forward from previous instruction
               '0';
			   

end architecture arc_FU;