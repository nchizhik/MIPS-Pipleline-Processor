--Decode
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.all;

entity Decode is 
port(
    --Input 
    Clk: in std_logic;
    Reset: in std_logic;			
    PCPlus4D: in std_logic_vector(31 downto 0); 	--after sign extend and shift-left 2 (/32)
    InstrD: in std_logic_vector(31 downto 0); 		--after sign extend and shift-left 2 (/32)
    ResultW: in std_logic_vector(31 downto 0);
    ALUOutM_backwards: in std_logic_vector(31 downto 0);
    RegWriteW_out: in std_logic;
	WriteRegW_out: in std_logic_vector(4 downto 0);
    Forward_BD: in std_logic; --FORWARDING UNIT!
    Forward_AD: in std_logic; --FORWARDING UNIT!
 	BranchD: in std_logic; --CONTROL UNIT!
 
 --Output
    RD1E: out std_logic_vector(31 downto 0); 
    RD2E: out std_logic_vector(31 downto 0); 
    PCSrcD: out std_logic;
    RsD: out std_logic_vector(4 downto 0);
    RtD: out std_logic_vector(4 downto 0);
	RsE: out std_logic_vector(4 downto 0);
    RtE: out std_logic_vector(4 downto 0);
    RdE: out std_logic_vector(4 downto 0);
    PCBranchD: out std_logic_vector(31 downto 0);
    SignImmE: out std_logic_vector(31 downto 0);
	op_out: out std_logic_vector(5 downto 0)  --6opcode bits
    ); 

end entity Decode;

architecture arc_decode of Decode is
component signextention is
port(
	     A : in std_logic_vector(15 downto 0);
        Y : out std_logic_vector(31 downto 0)
	);
	
end component signextention;

component bor is
 port ( 
		clk        : in  std_logic;
		rst        : in  std_logic;
		-- write side
		reg_write  : in  std_logic;
		write_reg  : in  std_logic_vector(4  downto 0);
		write_data : in  std_logic_vector(31 downto 0);
		-- read side
		read_reg1  : in  std_logic_vector(4  downto 0);
		read_data1 : out std_logic_vector(31 downto 0);
		read_reg2  : in  std_logic_vector(4  downto 0);
		read_data2 : out std_logic_vector(31 downto 0)		
	  );
end component bor;	
	
signal s_SignExt: std_logic_vector(15 downto 0);
signal RD1M: std_logic_vector(31 downto 0);
signal RD2M: std_logic_vector(31 downto 0);
signal shift_L2_signed: std_logic_vector(31 downto 0);
signal EqualD: std_logic;
signal SignImmD: std_logic_vector(31 downto 0);
signal forwardAD_out:std_logic_vector(31 downto 0);
signal forwardBD_out:std_logic_vector(31 downto 0);
begin

signextension_pmap: signextention port map
(A => s_SignExt ,
Y => SignImmD --signextend output)
);
bor_pmap: bor port map
(
 clk=>Clk,
 rst=>Reset,
 read_reg1=> InstrD(25 downto 21),
 read_reg2=> InstrD(20 downto 16), 
 reg_write=>RegWriteW_out,
 write_reg=>WriteRegW_out,
 write_data=> ResultW,
 read_data1=>RD1M,
 read_data2=>RD2M
 );

op_out<= InstrD(31 downto 26); 

PCSrcD<= EqualD AND BranchD; --BranchD is from control unit. not yet established 
		
--signextend + shift left 2
s_SignExt<=	InstrD(15 downto 0);
		
--shift_L2_signed   <=  shift_left(std_logic_vector(SignImmD), 2);
shift_L2_signed  <= SignImmD(29 downto 0) & "00";
		
--branch calc.
PCBranchD<= PCPlus4D + shift_L2_signed;

--forwading unit muxes	
forwardAD_out <= RD1M when Forward_AD= '0' else
	              ALUOutM_backwards when Forward_AD= '1';

forwardBD_out <= RD2M when Forward_AD= '0' else
	              ALUOutM_backwards when Forward_AD= '1';
								
--branch equal 
EqualD <= '1' when forwardAD_out = forwardBD_out else '0';

--Hazard Unit
RsD<= InstrD(25 downto 21);
RtD<= InstrD(20 downto 16);	              



process(clk,reset)
begin 
if reset='1' then 
 
else
if falling_Edge(clk) then 
	
	-- fill in all regs to reset. (all of the outputs are destined to be zero?)
	
			   
	
		

		RsE<= InstrD(25 downto 21);
		RtE<= InstrD(20 downto 16);
		RdE<= InstrD(15 downto 11);
		SignImmE <= SignImmD;
      RD1E<= RD1M;
      RD2E<= RD2M;
		
		
		end if;
		end if;


    end process;


end architecture arc_decode;