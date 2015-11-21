----------------------------------------------------------------------------------
-- Company:   Federal University of Santa Catarina
-- Engineer:  Prof. Dr. Eng. Rafael Luiz Cancian
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

entity blocoOperativo is 
   port(
      clock, reset: in std_logic;
      PCEscCond, PCEsc, IouD, LerMem, EscMem, MemParaReg, IREsc, RegDst, EscReg, ULAFonteA: in std_logic;
      ULAFonteB, ULAOp, FontePC: in std_logic_vector(1 downto 0);
      opcode: out std_logic_vector(5 downto 0)
   );
end entity;

architecture estrutural of blocoOperativo is

component ula is
	generic(largura: natural := 8);
   port(
      entradaA, entradaB: in std_logic_vector(largura-1 downto 0);
      Operacao: in std_logic_vector(2 downto 0);
      saida: out std_logic_vector(largura-1 downto 0);
      zero: out std_logic
   );
end component;

component operacaoULA is
	port(
      ULAOp: in std_logic_vector(1 downto 0);
		funct: in std_logic_vector(5 downto 0);
      Operacao: out std_logic_vector(2 downto 0)
   );
end component;


component memoria is
	port(
		clock: in std_logic;
		ReadMem, WrtMem: in std_logic;
		DataWrt: in std_logic_vector(31 downto 0);
		Address: in std_logic_vector(31 downto 0);
		DataRd: out std_logic_vector(31 downto 0)
	);
end component;


component deslocadorEsquerda is
	generic(largura: natural := 8);
   port(
      entrada: in std_logic_vector(largura-1 downto 0);
      saida: out std_logic_vector(largura-1 downto 0)
   );
end component;


component multiplexador4x1 is
	generic(largura: natural := 8);
   port(
      entrada0, entrada1, entrada2, entrada3: in std_logic_vector(largura-1 downto 0);
      selecao: in std_logic_vector(1 downto 0);
      saida: out std_logic_vector(largura-1 downto 0)
   );
end component;


component multiplexador2x1 is
   generic(largura: natural := 8);
   port(
      entrada0, entrada1: in std_logic_vector(largura-1 downto 0);
      selecao: in std_logic;
      saida: out std_logic_vector(largura-1 downto 0)
   );
end component;


component bancoRegistradores is
   generic(
      largura: natural := 8;
      bitsRegSerLido: natural := 2
   );
   port(
      clock, reset: in std_logic;
      EscReg: in std_logic;
      RegSerLido1, RegSerLido2, RegSerEscrito: in std_logic_vector(bitsRegSerLido-1 downto 0);
      DadoEscrita: in std_logic_vector(largura-1 downto 0);      
      DadoLido1, DadoLido2: out std_logic_vector(largura-1 downto 0)
   );
end component;


component registrador is
   generic(largura: natural := 8);
   port(
      clock, reset: in std_logic;
      en: in std_logic;
      d: in std_logic_vector(largura-1 downto 0); 
      q: out std_logic_vector(largura-1 downto 0)
   );
end component;

component somador is
	generic(largura: natural := 8);
   port(
      entradaA, entradaB: in std_logic_vector(largura-1 downto 0);
		carryIn: in std_logic;
      saida: out std_logic_vector(largura-1 downto 0)
   );
end component;

signal resetPC, resetInstr, resetRedDadosMemoria : std_logic;

signal entradaPC, saidaRegPC, saidaMem, saidaMuxPC, saidaRegULA, saidaRegInstr: std_logic_vector(31 downto 0);

signal regLido1, regLido2, saidaRegDadosMem, dadoEscReg, dadoEscMem: std_logic_vector(31 downto 0);

signal saidaMuxRegSerEscrito: std_logic_vector(4 downto 0);

begin

regPC: registrador generic map(32) port map(clock, resetPC, '1', entradaPC, saidaRegPC);

muxPC: multiplexador2x1 generic map(32) port map (saidaRegPC, saidaRegULA, IouD, saidaMuxPC);

mem: memoria port map (clock, LerMem, EscMem, dadoEscMem, saidaMuxPC, saidaMem); -- TO-DO

regIntrucao: registrador generic map(32) port map(clock, resetInstr, IREsc, saidaMem, saidaRegInstr);

muxRegSerEscrito: multiplexador2x1 generic map (5) port map(saidaRegInstr(20 downto 16), saidaRegInstr(15 downto 11), RegDst, saidaMuxRegSerEscrito);

bancoReg: bancoRegistradores generic map (32, 5) port map(clock, reset, EscReg, saidaRegInstr(25 downto 21), saidaRegInstr(20 downto 16),
																				saidaMuxRegSerEscrito, regLido1, regLido2);
																				
regDadosMemoria: registrador generic map (32) port map(clock, resetRedDadosMemoria, '1', saidaMem, saidaRegDadosMem);

muxDadoEscReg: multiplexador2x1 generic map(32) port map (saidaRegULA, saidaRegDadosMem, MemParaReg, dadoEscReg);



--clock, reset: in std_logic;
--EscReg: in std_logic;
--RegSerLido1, RegSerLido2, RegSerEscrito: in std_logic_vector(bitsRegSerLido-1 downto 0);
--DadoEscrita: in std_logic_vector(largura-1 downto 0);      
--DadoLido1, DadoLido2: out std_logic_vector(largura-1 downto 0);



end architecture;
