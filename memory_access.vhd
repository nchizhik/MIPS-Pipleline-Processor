--Memory_Access
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity Memory_Access is 
port(
		--Input         
        Clk: in std_logic;
        Reset: in std_logic;
        ALUoutM: in std_logic_vector(31 downto 0);
        WriteDataM: in std_logic_vector(31 downto 0);
        WriteRegM: in std_logic_vector(4 downto 0);  
        RegWriteM: in std_logic;
        MemToRegM: in std_logic;
        MemWriteM: in std_logic;        
        MemReadM: in std_logic;   
		  
		--Output      
        ALUoutM_backwards: out std_logic_vector(31 downto 0);
        ReadDataW: out std_logic_vector(31 downto 0); 
		ALUoutW: out std_logic_vector(31 downto 0);
		WriteRegW: out std_logic_vector(4 downto 0); 
        WriteRegM_out: out std_logic_vector(4 downto 0);  
        RegWriteW: out std_logic;
        MemToRegW: out std_logic  
        		  
    ); 
end entity Memory_Access;


architecture arc_Memory_Access of Memory_Access is
 
component Dmem
port( 	clk        : in  std_logic;
		rst        : in  std_logic;
		address    : in  std_logic_vector(31  downto 0);
		-- write side
		mem_write  : in  std_logic;
		write_data : in  std_logic_vector(31 downto 0);
		-- read side
		mem_read   : in  std_logic;
		read_data  : out std_logic_vector(31 downto 0)	
);
end component Dmem;

signal ReadDataM: std_logic_vector(31 downto 0);

begin

dmem_pmap: Dmem port map
(
 clk=>Clk,
 rst=>Reset,
 address=>ALUoutM,
 mem_write=>MemWriteM,
 write_data=>WriteDataM,
 mem_read=> MemReadM,
 read_data=>ReadDataM
 );
 
 
ALUoutM_backwards <= ALUoutM;
WriteRegM_out <= WriteRegM;
 
 
process(Clk,Reset)
begin
if Reset='1' then 
RegWriteW<= '0';
MemToRegW<= '0';
WriteRegW<= (others => '0');
ALUoutW<=(others => '0');
ReadDataW <=(others => '0'); 

else
   if falling_Edge(Clk) then 


   RegWriteW<=RegWriteM;
   MemToRegW<=MemToRegM;
   WriteRegW<= WriteRegM;
ALUoutW<=ALUoutM;
ReadDataW <= ReadDataM;


end if;
end if;

end process;
end architecture arc_Memory_Access;
 
