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
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoria is 
	port(
		clock: in std_logic;
		ReadMem, WrtMem: in std_logic;
		DataWrt: in std_logic_vector(31 downto 0);
		Address: in std_logic_vector(31 downto 0);
		DataRd: out std_logic_vector(31 downto 0)
	);
end;

architecture mem of memoria is 
	component bram IS
	PORT(
		address		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
	END component;

begin

--	geraBRAMs: for i in 0 to 3 generate
--	BRAM0: bram	PORT map (address(9 DOWNTO 2)&std_logic_vector(to_unsigned(i, 2)), 
--								 clock,DataWrt(((i+1)*8)-1 downto i*8), WrtMem,DataRd(((i+1)*8)-1 downto i*8));
--	end generate;


BRAM0: bram port map ("00"&address(9 downto 2), clock, DataWrt, WrtMem, DataRd);


end architecture;