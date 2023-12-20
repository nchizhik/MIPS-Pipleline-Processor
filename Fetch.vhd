library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity Fetch is 
port(
    --Input 
	Clk: in std_logic;
    Reset: in std_logic;
	branch_address: in std_logic_vector(31 downto 0); --after sign extend and shift-left 2 (/32)
    PCSrcD: in std_logic;
    Jump: in std_logic; --plumbus falus dambeldoor
    StallD: in std_logic; --HAZARD UNIT!
	stallF: in std_logic; --HAZARD UNIT!
  --Output
	Memory_out: out std_logic_vector(31 downto 0);-- instr
	PCPlus4_out: out std_logic_vector(31 downto 0)-- pc+4
    ); 

end entity Fetch;

architecture arc_Fetch of Fetch is

component imem is
port(  pc_imem: in  std_logic_vector(31 downto 0);
       instr: out std_logic_vector(31 downto 0)
	);
end component imem;

signal pc_next: std_logic_vector(31 downto 0);
signal pc: std_logic_vector(31 downto 0);
signal instr_out_s: std_logic_vector(31 downto 0);
signal Jump_dst: std_logic_vector(31 downto 0); -- the signal in the input '1' of mux 
signal instr_out_26_sl2:std_logic_vector(27 downto 0); 
signal pc_plus4: std_Logic_vector(31 downto 0);

begin

imem_pmap: imem port map
				(	pc_imem=>pc,
					instr=>instr_out_s
				 );

pc_next <= pc_plus4 when PCSrcD='0' else branch_address when PCSrcD='1' ;
instr_out_26_sl2 <= instr_out_s(25 downto 0) & "00";  -- take only 25-0 bits and do sl2     
pc_plus4<=pc+X"0004";

Jump_dst<=pc_plus4(31 downto 28) & instr_out_26_sl2(25 downto 0) & "00";   
		
process(Clk,Reset)
begin

if falling_Edge(clk) then 

	if stallD='0' then    --stallF='0' = stallD
       
	else
			
			PCPlus4_out<= pc+X"0004";
			Memory_out <= instr_out_s;
	
	 if Jump = '1'  then     pc <= Jump_dst;
    elsif Jump = '0' then   pc <= pc_next;
	 end if;
 

end if;
	
	

end if;

if Reset='1' then 			
PCPlus4_out<=X"00000000";
 Memory_out <=X"00000000";
 pc <=X"00000000";
	end if;

if (PCsrcD = '1' ) then 
            Memory_out <= X"00000000" ;
            PCPlus4_out <= X"00000000" ; 
end if;
end process;
	
end architecture arc_Fetch;
	
	
	