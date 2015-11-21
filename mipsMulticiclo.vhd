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
begin
end architecture;
