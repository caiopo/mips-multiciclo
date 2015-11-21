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

entity bancoRegistradores is 
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
end entity;

architecture comportamental of bancoRegistradores is 
	type TypeBancoRegistradores is array(0 to 2**bitsRegSerLido) of std_logic_vector(largura-1 downto 0);
	signal actual_state, next_state: TypeBancoRegistradores;
begin

-- state register
StateRegister: process(clock, reset)
begin
	if reset = '1' then
		for i in actual_state'range loop
			actual_state(i) <= (others => '0');
		end loop;
	elsif rising_edge(clock) then
		actual_state <= next_state;
	end if;
end process;

-- next state logic
NextStateLogic: process(actual_state, EscReg, RegSerEscrito, DadoEscrita) is
begin
	next_state <= actual_state;
	for i in actual_state'range loop
		if EscReg = '1' then
			if i = to_integer(unsigned(RegSerEscrito)) then
				next_state(i) <= DadoEscrita; 
			end if;
		end if;
	end loop;
end process;

-- output logic
DadoLido1 <= actual_state(to_integer(unsigned(RegSerLido1)));
DadoLido2 <= actual_state(to_integer(unsigned(RegSerlido2)));

end architecture;
