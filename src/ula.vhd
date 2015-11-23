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
use ieee.numeric_std.all;

entity ula is 
   generic(largura: natural := 8);
   port(
      entradaA, entradaB: in std_logic_vector(largura-1 downto 0);
      Operacao: in std_logic_vector(2 downto 0);
      saida: out std_logic_vector(largura-1 downto 0);
      zero: out std_logic
   );
end entity;

architecture comportamental of ula is

component somadorSubtrador is
	generic(largura: natural := 8);
	port(
			entradaA, entradaB: in std_logic_vector(largura-1 downto 0);
			carryIn: in std_logic;
			saida: out std_logic_vector(largura-1 downto 0)
   );
end component;

signal saidaSignal, andOr, addSub, slt: std_logic_vector(largura-1 downto 0);

begin

somadorSubtrator: somadorSubtrador generic map (largura) 
											  port map(entradaA, entradaB, Operacao(2), addSub);

andOr <= entradaA and entradaB when Operacao(0)='0' else
			entradaA or entradaB;

slt <= (0 => '1', others => '0') when signed(entradaA) < signed(entradaB) else (others => '0');

saidaSignal <= slt when Operacao="111" else
					andOr when Operacao(1)='0' else
					addSub;

zero <= '1' when saidaSignal=(largura => '0') else '0';

saida <= saidaSignal;
 
end architecture;