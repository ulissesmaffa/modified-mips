----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Bruce Wayne
-- 
-- Create Date: 08.2017 18:59:38
-- Design Name: filha da puta do caralho
-- Module Name: TestBench.vhd
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
library work;
use work.mipspkg.all;

entity teste is
--  Port ( );
end teste;

architecture rtl of teste is
    
    signal clk       : std_logic := '0';
    signal rst       : std_logic := '1';
    signal hlt       : std_logic := '0';
	  
	-- Clock period definitions
	constant clk_period  : time := 10 ns;
	
begin
-------------------------------------------------------
-- Instancia da Unit Under Test (UUT)
-------------------------------------------------------
uut : mips 
	port map (
		clk          => clk,
		rst          => rst,
		hlt         => hlt
	);

-------------------------------------------------------
-- Clock process definitions
-------------------------------------------------------
clk_process : process
begin
	clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
end process;

-------------------------------------------------------
-- Stimulus process 
-------------------------------------------------------
testbench_process_main : process
begin
	wait for 50ns;
	rst <= '0';
	-- fazer uma condi��o para parar a simula��o em caso de halt
end process;

end rtl;
