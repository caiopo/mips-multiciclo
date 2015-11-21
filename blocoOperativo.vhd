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

component extensaoSinal is
   generic(
      larguraOriginal: natural := 8;
      larguraExtendida: natural := 8);
   port(
      entrada: in std_logic_vector(larguraOriginal-1 downto 0);
      saida: out std_logic_vector(larguraExtendida-1 downto 0)
   );
end component;

signal zeroULA, enablePC: std_logic;

signal entradaPC, saidaRegPC, saidaMem, saidaMuxPC, saidaRegULA, saidaRegInstr: std_logic_vector(31 downto 0);
signal regLido1, regLido2, saidaRegDadosMem, dadoEscReg, dadoEscMem, saidaRegA, saidaRegB: std_logic_vector(31 downto 0);
signal saidaMuxAULA, saidaMuxBULA, saidaExtensaoSinal, saidaExtensaoSinalDesl, saidaULA: std_logic_vector(31 downto 0);
--signal saidaRegULA : std_logic_vector(31 downto 0);

signal saidaMuxRegSerEscrito: std_logic_vector(4 downto 0);
signal ctrlULA : std_logic_vector(2 downto 0);

signal deslEsq26to28 : std_logic_vector(31 downto 0);

constant quatro : std_logic_vector(31 downto 0) := (3 => '1', others => '0');

begin

enablePC <= PCEsc or (PCEscCond and zeroULA); 

regPC: registrador generic map(32) port map(clock, reset, enablePC, entradaPC, saidaRegPC);

muxPC: multiplexador2x1 generic map(32) port map (saidaRegPC, saidaRegULA, IouD, saidaMuxPC);

mem: memoria port map (clock, LerMem, EscMem, dadoEscMem, saidaMuxPC, saidaMem);

regIntrucao: registrador generic map(32) port map(clock, reset, IREsc, saidaMem, saidaRegInstr);

muxRegSerEscrito: multiplexador2x1 generic map (5) port map(saidaRegInstr(20 downto 16), saidaRegInstr(15 downto 11), RegDst, saidaMuxRegSerEscrito);

bancoReg: bancoRegistradores generic map (32, 5) port map(clock, reset, EscReg, saidaRegInstr(25 downto 21), saidaRegInstr(20 downto 16),
																				saidaMuxRegSerEscrito, regLido1, regLido2);
																				
regDadosMemoria: registrador generic map (32) port map(clock, reset, '1', saidaMem, saidaRegDadosMem);

muxDadoEscReg: multiplexador2x1 generic map(32) port map (saidaRegULA, saidaRegDadosMem, MemParaReg, dadoEscReg);

regA: registrador generic map (32) port map (clock, reset, '1', regLido1, saidaRegA);
regB: registrador generic map (32) port map (clock, reset, '1', regLido2, saidaRegB);

muxAEntradaULA : multiplexador2x1 generic map(32) port map (saidaRegPC, saidaRegA, ULAFonteA, saidaMuxAULA);
muxBEntradaULA: multiplexador4x1 generic map(32) port map (saidaRegB, quatro, saidaExtensaoSinal, saidaExtensaoSinalDesl, ULAFonteB, saidaMuxBULA);

extensorDeSinal : extensaoSinal generic map (16, 32) port map (saidaRegInstr(15 downto 0), saidaExtensaoSinal);
saidaExtensaoSinalDesl <= saidaExtensaoSinal(29 downto 0)&"00";

opULA: OperacaoULA port map(ULAOp, saidaRegInstr(5 downto 0), ctrlULA);

UnLogArit: ula generic map (32) port map (saidaMuxAULA, saidaMuxBULA, ctrlULA, saidaULA, zeroULA);

regSaidaULA: registrador generic map (32) port map (clock, reset, '1', saidaULA, saidaRegULA);

deslEsq26to28 <= saidaRegPC(31 downto 28)&saidaRegInstr(25 downto 0)&"00";

muxSaidaULA: multiplexador4x1 generic map (32) port map (saidaULA, saidaRegULA, deslEsq26to28, (others => '0'), FontePC, entradaPC);

opcode <= saidaRegInstr(31 downto 26);

end architecture;
