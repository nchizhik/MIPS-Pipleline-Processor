--Hazard unit 
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity Hazard_Unit  is 
port(
    --Input         
    RtE: in std_logic_vector(4 downto 0);
    RtD: in std_logic_vector(4 downto 0); 
    RsD: in std_logic_vector(4 downto 0);    
    MemReadE: in std_logic;
    
    
    --Output
    Stall_F : out std_logic ;  -- freeze pc  
    Stall_D : out std_logic ;  -- freeze IF/ID
    FlushE : out std_logic  --bubble maker ID/EX

    ); 
	 
end entity Hazard_Unit;

architecture arc_HU of Hazard_Unit is
begin
 
 Stall_D <= '0' when (MemReadE='1') and (RtE = RsD or RtE = RtD) else '1';
 Stall_F <= '0' when (MemReadE='1') and (RtE = RsD or RtE = RtD) else '1';
 FlushE  <= '1' when (MemReadE='1') and (RtE = RsD or RtE = RtD) else '0';
 

end architecture arc_HU;