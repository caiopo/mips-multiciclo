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

entity somadorSubtrador is
   generic(largura: natural := 8);
   port(
      entradaA, entradaB: in std_logic_vector(largura-1 downto 0);
		carryIn: in std_logic;
      saida: out std_logic_vector(largura-1 downto 0)
   );
end entity;

architecture comportamental of somadorSubtrador is
begin

saida <= std_logic_vector(signed(entradaA)+signed(entradaB)) when carryIn='0' else
			std_logic_vector(signed(entradaA)-signed(entradaB));

end architecture;
