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
use ieee.numeric_std.all;
entity blocoControle  is 
   port(
      clock, reset: in std_logic;
      PCEscCond, PCEsc, IouD, LerMem, EscMem, MemParaReg, IREsc, RegDst, EscReg, ULAFonteA: out std_logic;
      ULAFonteB, ULAOp, FontePC: out std_logic_vector(1 downto 0);
      opcode: in std_logic_vector(5 downto 0)
   );
end entity;

architecture FSMcomportamental of blocoControle is
	type state is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9);
	signal next_state, actual_state : state;
	constant lw : std_logic_vector(5 downto 0) := "100011";
	constant sw : std_logic_vector(5 downto 0) := "101011";
	constant tipoR : std_logic_vector(5 downto 0) := "000000"; 
	constant beq : std_logic_vector(5 downto 0) := "000100";
	constant jump : std_logic_vector(5 downto 0) := "000010";
begin
-- state register
	process(clock,reset)
	begin
		if reset = '1' then 
			actual_state <= s0;
		elsif rising_edge(clock) then
			actual_state <= next_state;
		end if;
	end process;
-- next state logig
	process(opcode,clock)
	begin
		case actual_state is
			when s0 => 
				next_state <= s1;
			when s1 =>
				if opcode = tipoR then
					next_state <= s6;
				elsif (opcode = lw) or (opcode = sw) then
					next_state <= s2;
				elsif opcode = beq then
					next_state <= s8;
				elsif opcode = jump then
					next_state <= s9;
				end if;
			when s2 =>
				if opcode = lw then
					next_state <= s3;
				else 
					next_state <= s5;
				end if;
			when s3 =>
				next_state <= s4;
			when s4 => 
				next_state <= s0;
			when s5 =>
				next_state <= s0;
			when s6 =>
				next_state <= s7;
			when s7 =>
				next_state <= s0;
			when s8 =>
				next_state <= s0;
			when s9 =>
				next_state <= s0;
		end case;
	end process;
-- output logic
process(clock, actual_state)
	begin
	PCEscCond <= '0';
	PCEsc <= '0';
	IouD <= '0';
	LerMem <= '0';
	EscMem <= '0';
	MemParaReg <= '0';
	IREsc <= '0';
	RegDst <= '0';
	EscReg <= '0';
	ULAFonteA <= '0';
	ULAFonteB <= "00";
	ULAOp <= "00";
	FontePC <= "00";
	
	case actual_state is
		when s0 => 
			LerMem <= '1';
			ULAFonteA <= '0';
			IouD <= '0';
			IREsc <= '1';
			ULAFonteB <= "01";
			ULAOp <= "00";
			PCEsc <= '1';
			FontePC <= "00";
		when s1 =>
			ULAFonteA <= '0';
			ULAFonteB <= "11";
			ULAOp <= "00";
		when s2 =>
			ULAFonteA <= '1';
			ULAFonteB <= "10";
			ULAOp <= "00";
		when s3 =>
			LerMem <= '1';
			IouD <= '1';
		when s4 =>
			EscReg <= '1';
			MemParaReg <= '1';
			RegDst <= '0';
		when s5 =>
			EscMem <= '1';
			IouD <= '1';
		when s6 =>
			ULAFonteA <= '1';
			ULAFonteB <= "00";
			ULAOp <= "10";
		when s7 =>
			RegDst <= '1';
			EscReg <= '1';
			MemParaReg <= '0';
		when s8 =>
			ULAFonteA <= '1';
			ULAFonteB <= "00";
			ULAOp <= "01";
			PCEscCond <= '1';
			PCEsc <= '0';
			FontePC <= "01";
		when s9 =>
			PCEsc <= '1';
			FontePC <= "10";
		end case;
end process;
end architecture;
