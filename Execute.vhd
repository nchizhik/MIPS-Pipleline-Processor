library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity Execute is 
port(
    --Input 
        
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
end entity Execute;

architecture arc_Execute of Execute is 
component ALU is 
port (  
       SrcAE  : in  std_logic_vector(31 downto 0);
       SrcBE  : in  std_logic_vector(31 downto 0);
       ALUOutE : out std_logic_vector(31 downto 0);
       ALUControlE : in std_logic_vector(2 downto 0)
	  );
end component ALU;


signal SrcAE : std_logic_vector(31 downto 0);
signal SrcBE : std_logic_vector(31 downto 0);
signal WriteDataE : std_logic_vector(31 downto 0);
signal ALUControlE:  std_logic_vector(2 downto 0); --out of small eag    
signal Func : std_logic_vector(5 downto 0); 
signal ALUOutE: std_logic_vector(31 downto 0);
signal WriteRegE: std_logic_vector(4 downto 0);

begin 

ALU_pmap : ALU port map 
(
SrcAE=>SrcAE,
SrcBE=>SrcBE,
ALUOutE=>ALUOutE,
ALUControlE=>ALUControlE
);


Func <= SignImmE(5 downto 0); 

SrcAE <= RD1E when Forward_AE= "00" else  
           ResultW when Forward_AE= "01" else				 
           ALUoutM_backwards when Forward_AE= "10" else				 
           (others => '0');				

WriteDataE <= RD2E when Forward_BE= "00" else 
                ResultW when Forward_BE= "01" else				 
                ALUoutM_backwards when Forward_BE= "10" else				 
                (others => '0');			  


SrcBE <= WriteDataE when ALUSrcE ='0' else 
           SignImmE when ALUSrcE ='1';

WriteRegE <= RtE when RegDstE='0' else 
 			    RdE when RegDstE='1'; 
	
RsE_out <= RsE;
RtE_out <= RtE;



--the small egg!		
ALUControlE<= "010" when ALUOpE= "00" else  --SW/LW =>ADD 
          	 "110" when ALUOpE= "01" else  --BEQ  =>SUB
          	 "010" when ALUOpE= "10" and Func= "100001"  else  --addu
          	 "110" when ALUOpE= "10" and Func= "100010"  else	--sub		
          	 "000" when ALUOpE= "10" and Func= "100100"  else	--and
	          "001" when ALUOpE= "10" and Func= "100101"  else  --or
	          "111" when ALUOpE= "10" and Func= "101010"  else	--slt			 
             (others => '0');



Process(Clk,Reset)
begin
if reset='1' then 
      WriteDataM <= (others => '0'); 
		RegWriteM <= '0';
		MemToRegM <= '0';
		MemWriteM <= '0';
		MemReadM <= '0';
		ALUoutM <=  (others => '0');
	   WriteRegM <= (others => '0');


else
 if falling_Edge(Clk) then


      WriteDataM <= WriteDataE; 
		RegWriteM <= RegWriteE;
		MemToRegM <= MemToRegE;
		MemWriteM <= MemWriteE;
		MemReadM <= MemReadE;
		ALUoutM <=  ALUoutE;
	   WriteRegM <= WriteRegE;


	

end if;
end if;
	end process;
	end architecture arc_Execute;