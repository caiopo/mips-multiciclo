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

entity memoria is 
   generic(
      larguraMemoria: natural := 8;
      larguraDado: natural := 16;
      bitsEndereco: natural := 4
   );
   port(
      clock, reset: in std_logic;
      EscMem: in std_logic;
      Endereco: in std_logic_vector(2**bitsEndereco-1 downto 0);
      DadoSerEscrito: in std_logic_vector(larguraDado-1 downto 0);
      DadoMem: out std_logic_vector(larguraDado-1 downto 0)
   );
end entity;

architecture comportamental of memoria is
begin
end architecture;
