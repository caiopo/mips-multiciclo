----------------------------------------------------------------------------------
-- Company:   Federal University of Santa Catarina
-- Engineer:  
-- 
-- Create Date:    
-- Design Name: 
-- Module Name:    
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use ieee.std_logic_1164.all;

entity mipsMulticiclo is 
   port(
      clock, reset: in std_logic;
      gpio: inout std_logic_vector(31 downto 0)
   );
end entity;

architecture estrutural of mipsMulticiclo is

component blocoOperativo is
   port(
      clock, reset: in std_logic;
      PCEscCond, PCEsc, IouD, LerMem, EscMem, MemParaReg, IREsc, RegDst, EscReg, ULAFonteA: in std_logic;
      ULAFonteB, ULAOp, FontePC: in std_logic_vector(1 downto 0);
      opcode: out std_logic_vector(5 downto 0)
	);
end component;
 
 
component blocoControle  is
	port(
      clock, reset: in std_logic;
      PCEscCond, PCEsc, IouD, LerMem, EscMem, MemParaReg, IREsc, RegDst, EscReg, ULAFonteA: out std_logic;
      ULAFonteB, ULAOp, FontePC: out std_logic_vector(1 downto 0);
      opcode: in std_logic_vector(5 downto 0)
   );
end component;
 
signal PCEscCond, PCEsc, IouD, LerMem, EscMem, MemParaReg, IREsc, RegDst, EscReg, ULAFonteA: std_logic;
signal ULAFonteB, ULAOp, FontePC: std_logic_vector(1 downto 0);
signal opcode: std_logic_vector(5 downto 0);
 
begin

controle: blocoControle port map (clock, reset, PCEscCond, PCEsc, IouD, LerMem, EscMem, MemParaReg, IREsc, RegDst,
									EscReg, ULAFonteA, ULAFonteB, ULAOp, FONtePC, opcode);

operativo: blocoOperativo port map (clock, reset, PCEscCond, PCEsc, IouD, LerMem, EscMem, MemParaReg, IREsc, RegDst,
									EscReg, ULAFonteA, ULAFonteB, ULAOp, FONtePC, opcode);

end architecture;