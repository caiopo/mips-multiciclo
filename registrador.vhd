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

entity registrador is
   generic(largura: natural := 8);
   port(
      clock, reset: in std_logic;
      en: in std_logic;
      d: in std_logic_vector(largura-1 downto 0);
      q: out std_logic_vector(largura-1 downto 0)
   );
end entity;

architecture comportamental of registrador is
begin

process(clock, reset)
begin
	if reset='1' then
		q <= (others => '0');
	elsif rising_edge(clock) and en = '1' then
		q <= d;
	end if;
end process;

end architecture;
