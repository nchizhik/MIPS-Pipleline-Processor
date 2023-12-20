library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity dmem is
 port ( 
		clk        : in  std_logic;
		rst        : in  std_logic;
		address    : in  std_logic_vector(31  downto 0);
		-- write side
		mem_write  : in  std_logic;
		write_data : in  std_logic_vector(31 downto 0);
		-- read side
		mem_read   : in  std_logic;
		read_data  : out std_logic_vector(31 downto 0)	
	  );
end entity dmem;

architecture arc_dmem of dmem is
type m_arr is array (natural range <>) of std_logic_vector(write_data'range);
signal data_mem: m_arr(1023 downto 0);
begin
	write_p: process(clk) is
	begin
		if rising_edge(clk) then
			if(mem_write='1') then
			  data_mem(conv_integer(address(9 downto 0)))<=write_data;
			end if;		
    	end if;	
	end process write_p; 
	
	read_p: process(clk,rst) is
	begin
	    if (rst='1') then
			read_data<=(others=>'0');
		elsif falling_edge(clk) then
			if(mem_read='1') then
			  read_data<=data_mem(conv_integer(address(9 downto 0)));
			end if;		
    	end if;	
	end process read_p; 	
end architecture arc_dmem;	  