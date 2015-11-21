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


entity multiplexador4x1 is 
   generic(largura: natural := 8);
   port(
      entrada0, entrada1, entrada2, entrada3: in std_logic_vector(largura-1 downto 0);
      selecao: in std_logic_vector(1 downto 0);
      saida: out std_logic_vector(largura-1 downto 0)
   );
end entity;

architecture comportamental of multiplexador4x1 is
begin

saida <= entrada0 when selecao="00" else
			entrada1 when selecao="01" else
			entrada2 when selecao="10" else
			entrada3;

end architecture;