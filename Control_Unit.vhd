--Control Unit
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

---all the dont care in the list are '0'!!!
  

entity Control_Unit is
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
end entity Control_Unit;


architecture arc_CtrlUnit of Control_Unit is

signal RegWriteD: std_logic;
signal MemToRegD: std_logic;
signal MemWriteD: std_logic;
signal MemReadD: std_logic;
signal ALUOpD: std_logic_vector(1 downto 0);
signal ALUSrcD: std_logic;
signal RegDstD: std_logic;

begin

RegWriteD <= '1' when (op ="000000" or op ="100011" or op="001000") else   -- Rtype or lw or addi
             '0' when (op = "000100" or op = "101011" or op = "000010" );   --beq sw jump

MemToRegD <= '1' when (op ="100011") else         --lw
             '0' when (op ="000100" or op ="101011" or op ="000010" or op ="000000" or op = "001000");                --beq sw jump Rtype addi

MemWriteD <= '1' when op ="101011" else              --sw
             '0' when (op ="000100" or op =X"100011" or op ="000010" or op ="000000" or op = "001000");                --beq lw jump Rtype addi

MemReadD  <= '1' when op ="100011" else            --lw
             '0' when (op ="000100" or op ="101011"  or op ="000010" or op ="000000" or op = "001000");                 --beq sw jump Rtype addi

ALUOpD  <=  "10" when op ="000000" else              -- Rtype
            "01" when op ="000100" else            --beq
            "00" when (op ="000010" or op ="101011" or op ="100011" or op="001000");      --lw sw addi

ALUSrcD <=     '0' when (op ="000000" or op ="000100") else   -- Rtype beq
            '1' when (op ="000010" or op ="101011" or op ="100011" or op="001000");     --lw sw


RegDstD <=  '1' when op ="000000" else                    -- Rtype
            '0' when (op ="000100" or op ="101011" or op ="000010" or op ="100011" or op="001000");                     --beq sw lw jump 

BranchD <=  '1' when op ="000100" else                -- beq
            '0' when (op ="100011" or op ="101011" or op ="000010" or op ="000000" or op="001000");                     -- sw lw jump Rtype

Jump <=     '1' when op ="000010" else 
            '0' when (op ="100011" or op ="101011" or op ="000100" or op ="000000" or op="001000");	
 
 process (clk,FlushE)   
 begin 
 if FlushE='1' then 
  RegWriteE <= '0';
 MemToRegE <= '0';
 MemWriteE <= '0';
 MemReadE <= '0';
 ALUOpE <= "00";
 ALUSrcE <= '0';
 RegDstE <= '0';
 else
 
 if falling_Edge(Clk) then
 RegWriteE <= RegWriteD;
 MemToRegE <= MemToRegD;
 MemWriteE <= MemWriteD;
 MemReadE <= MemReadD;
 ALUOpE <= ALUOpD;
 ALUSrcE <= ALUSrcD;
 RegDstE <= RegDstD;
 
 end if;
 end if;
 end process;    


    
end architecture arc_CtrlUnit;