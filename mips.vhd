library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;


-- Datapath

Entity Mips is
    Port(clk      : in std_logic;
         rst      : in std_logic);
end entity Mips;

architecture arc_Mips of Mips is 
component Fetch is 
port (
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
	end component Fetch; 
	
component Decode is 
port (
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
	end component Decode; 
	
component Execute is 
port(
		  Clk: in std_logic;
        Reset: in std_logic;
        RD1E: in std_logic_vector(31 downto 0); 
        RD2E: in std_logic_vector(31 downto 0);
        RsE: in std_logic_vector(4 downto 0);
        RtE: in std_logic_vector(4 downto 0);
        RdE: in std_logic_vector(4 downto 0);
        SignImmE: in std_logic_vector(31 downto 0);
        ResultW: in std_logic_vector(31 downto 0);
        Forward_AE: in std_logic_vector (1 downto 0);
        Forward_BE: in std_logic_vector (1 downto 0);
        RegWriteE: in std_logic;
        MemToRegE: in std_logic;
        MemWriteE: in std_logic;  
        MemReadE: in std_logic;        
        ALUOpE: in std_logic_vector(1 downto 0);        
        ALUSrcE: in std_logic;        
        RegDstE: in std_logic;        
        ALUoutM_backwards: in std_logic_vector(31 downto 0);               
    --Output
        
        ALUoutM: out std_logic_vector(31 downto 0);
        WriteDataM: out std_logic_vector(31 downto 0);
        RegWriteM: out std_logic;
        MemToRegM: out std_logic;
        MemWriteM: out std_logic;
	     MemReadM: out std_logic;
		  WriteRegM: out std_logic_vector(4 downto 0);		  
        RsE_out: out std_logic_vector(4 downto 0); --FORWARD UNIT
        RtE_out: out std_logic_vector(4 downto 0) --HAZARD+FORWARD UNIT 

);
end component Execute;

component Memory_Access is 
port(	--Input         
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
        WriteRegW: out std_logic_vector(4 downto 0); 
        ReadDataW: out std_logic_vector(31 downto 0); 
		  ALUoutW: out std_logic_vector(31 downto 0);
        RegWriteW: out std_logic;
        MemToRegW: out std_logic;  
        WriteRegM_out: out std_logic_vector(4 downto 0)  
);
end component Memory_Access;

component Write_Back is 
port(  --Input         
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
end component Write_Back;

component Forwarding_Unit is
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
end component Forwarding_Unit;

component Hazard_Unit is 
port (--Input         
    RtE: in std_logic_vector(4 downto 0);
    RtD: in std_logic_vector(4 downto 0); 
    RsD: in std_logic_vector(4 downto 0);    
    MemReadE: in std_logic;
    
    --Output
    Stall_F : out std_logic ;  -- freeze pc  
    Stall_D : out std_logic ;  -- freeze IF/ID
    FlushE : out std_logic --bubble maker ID/EX 
);
end component Hazard_Unit;

component Control_Unit is 
port (
	clk: in std_logic;
    op: in std_logic_vector(5 downto 0); --InstrD[31:26]
	FlushE: in std_logic;
    RegWriteE:out std_logic;
    MemToRegE:out std_logic;
    MemWriteE:out std_logic;
    MemReadE:out std_logic;
    ALUOpE:out std_logic_vector(1 downto 0);
    ALUSrcE:out std_logic;
    RegDstE:out std_logic;
    BranchD:out std_logic;
    Jump:out std_logic
);
end component Control_Unit;

--signals for all connections
signal Branch_Address_sig, Memory_out_sig, PCPlus4_out_sig, ResultW_sig, ALUOutM_sig, ALUOutW_sig, ALUoutM_backwards_sig, RD1_sig, RD2_sig, SignImmD_sig, WriteDataE_sig, RD_sig: std_logic_vector(31 downto 0); 
signal PCSrcD_sig, Jump_sig, RegWriteW_sig, RegWriteW_out_sig, Forward_BD_sig, Forward_AD_sig, RegWriteE_sig, RegWriteM_sig, MemToRegE_sig, MemToRegM_sig, MemToRegW_sig, MemWriteE_sig, MemWriteM_sig, MemReadE_sig, MemReadM_sig: std_logic;
signal ALUSrcE_sig, RegDstE_sig, StallF_sig, StallD_sig, FlushE_sig, BranchD_sig: std_logic;
signal WriteRegW_sig, WriteRegW_out_sig, WriteRegM_sig, WriteRegM_out_sig, RsD_sig, RtD_sig, RsE_sig, RsE_out_sig, RtE_sig, RtE_out_sig, RdE_sig: std_logic_vector(4 downto 0);
signal Forward_AE_sig, Forward_BE_sig, ALUOp_sig: std_logic_vector(1 downto 0);
signal op_sig: std_logic_vector(5 downto 0);

begin 
	
fetch1: Fetch port map(Clk=>clk, Reset=>rst, Branch_Address=>Branch_Address_sig, PCSrcD=>PCSrcD_sig,Jump=>Jump_sig,
 StallD=> StallD_sig, StallF=>StallF_sig, Memory_out=>Memory_out_sig, PCPlus4_out=>PCPlus4_out_sig);

decode1: Decode port map(Clk=>clk, Reset=>rst, PCPlus4D=>PCPlus4_out_sig, InstrD=>Memory_out_sig, ResultW=>ResultW_sig, 
ALUOutM_backwards=>ALUoutM_backwards_sig, RegWriteW_out=> RegWriteW_out_sig, WriteRegW_out=> WriteRegW_out_sig, Forward_BD=>Forward_BD_sig,
Forward_AD=>Forward_AD_sig, BranchD=> BranchD_sig, RD1E=>RD1_sig, RD2E=> RD2_sig, PCSrcD=>PCSrcD_sig, RsD=>RsD_sig,
 RtD=>RtD_sig, RsE=>RsE_sig, RtE=>RtE_sig, RdE=>RdE_sig, PCBranchD=>Branch_Address_sig, SignImmE=> SignImmD_sig,
 op_out=>op_sig);

execute1: Execute port map(Clk=>clk, Reset=>rst, RD1E=>RD1_sig, RD2E=>RD2_sig, RsE=>RsE_sig, RtE=>RtE_sig, RdE=>RdE_sig,
SignImmE=> SignImmD_sig, ResultW=>ResultW_sig, Forward_AE=>Forward_AE_sig, Forward_BE=>Forward_BE_sig, RegWriteE=>RegWriteE_sig,
MemToRegE=>MemToRegE_sig, MemWriteE=> MemWriteE_sig, MemReadE=>MemReadE_sig, ALUOpE=>ALUOp_sig, ALUSrcE=>ALUSrcE_sig,
RegDstE=>RegDstE_sig, ALUoutM_backwards=>ALUoutM_backwards_sig, ALUoutM=> ALUOutM_sig, WriteDataM=> WriteDataE_sig,
RegWriteM=> RegWriteM_sig, MemToRegM=>MemToRegM_sig, MemWriteM=> MemWriteM_sig, MemReadM=>MemReadM_sig, WriteRegM=>WriteRegM_sig,
RsE_out=>RsE_out_sig, RtE_out=>RtE_out_sig);
 		  
memory_access1: Memory_Access port map(Clk=>clk, Reset=>rst, ALUoutM=>ALUOutM_sig, WriteDataM=>WriteDataE_sig,
WriteRegM=>WriteRegM_sig, RegWriteM=> RegWriteM_sig, MemToRegM=> MemToRegM_sig, MemWriteM=> MemWriteM_sig,MemReadM=>MemReadM_sig,
ALUoutM_backwards=>ALUoutM_backwards_sig, WriteRegW=> WriteRegW_sig, ReadDataW=> RD_sig, ALUoutW=>ALUOutW_sig, RegWriteW=> RegWriteW_sig,
MemToRegW=> MemToRegW_sig, WriteRegM_out=> WriteRegM_out_sig);
	
write_back1: Write_Back port map(ALUoutW=> ALUOutW_sig, ReadDataW=>RD_sig, WriteRegW=> WriteRegW_sig, RegWriteW=> RegWriteW_sig,
MemToRegW=> MemToRegW_sig, RegWriteW_out=> RegWriteW_out_sig, WriteRegW_out=> WriteRegW_out_sig, ResultW=> ResultW_sig);

forwarding_unit1: Forwarding_Unit port map(  WriteRegM=> WriteRegM_out_sig, WriteRegW=> WriteRegW_out_sig,RegWriteM=> RegWriteM_sig,
 RegWriteW=>RegWriteW_sig, RsE=> RsE_out_sig, RtE=>RtE_out_sig, Forward_AE=> Forward_AE_sig, Forward_BE=> Forward_BE_sig,Forward_AD=> Forward_AD_sig,
Forward_BD=>Forward_BD_sig);

hazard_unit1: Hazard_Unit port map(RtE=>RtE_sig, RtD=> RtD_sig, RsD=> RsD_sig, MemReadE=>MemReadE_sig,
Stall_F=>StallF_sig, Stall_D=>StallD_sig, FlushE=>FlushE_sig);

control_unit1: Control_Unit port map(clk=> clk, op=> op_sig, FlushE=>FlushE_sig, RegWriteE=> RegWriteE_sig, MemToRegE=>MemToRegE_sig,
MemWriteE=> MemWriteE_sig, MemReadE=> MemReadE_sig, ALUOpE=>ALUOp_sig, ALUSrcE=> ALUSrcE_sig,
RegDstE=> RegDstE_sig, BranchD=> BranchD_sig,  Jump=> Jump_sig);


process(clk,rst)
begin 
if rst='1' then 
 
else
if falling_Edge(clk) then 
	

		end if;
		end if;


    end process;







end architecture arc_Mips;