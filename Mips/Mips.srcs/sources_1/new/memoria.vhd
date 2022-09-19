--bola corno
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.numeric_std.ALL;
library work;
use work.mipspkg.all;

entity memoria is
    Port ( rst          : in STD_LOGIC;
           clk          : in STD_LOGIC;
           address      : in std_logic_vector(7 downto 0);
           mem_in       : in STD_LOGIC_VECTOR (15 downto 0);
           mem_out      : out STD_LOGIC_VECTOR (15 downto 0);
           wmem         : in std_logic
           );
end memoria;

architecture Behavioral of memoria is
    type memoria is array (0 to 255) of std_logic_vector(7 downto 0);
    signal mem : memoria;

begin

    process(clk)
    begin
        if(rst = '1') then
            
            mem(0) <= "00000000"; -- load r0 32
            mem(1) <= "00100000";
            
            mem(2) <= "01110000";   --  addsw r0 34
            mem(3) <= "00100010";
            
            mem(4) <= "11111000"; -- HALT
            mem(5) <= "00000000";
            
            mem(6) <= "00000000";
            mem(7) <= "00000000";
            
            mem(8) <= "00000000"; 
            mem(9) <= "00000000";
            
            mem(10) <= "00000000"; 
            mem(11) <= "00000000";
            
            mem(12) <= "00000000"; 
            mem(13) <= "00000000";
            
            mem(14) <= "00000000";
            mem(15) <= "00000000";
            
            mem(16) <= "00000000"; 
            mem(17) <= "00000000";
            
            mem(18) <= "00000000"; 
            mem(19) <= "00000000";
            
            mem(20) <= "00000000";
            mem(21) <= "00000000";
            
            mem(22) <= "00000000";
            mem(23) <= "00000000";
            
            mem(24) <= "00000000";
            mem(25) <= "00000000"; 
            
            mem(26) <= "00000000";
            mem(27) <= "00000000";
            
            mem(28) <= "00000000";
            mem(29) <= "00000000";
            
            mem(30) <= "00000000";
            mem(31) <= "00000000";
            
            mem(32) <= "00000000"; -- valor 2 a posi��o 32
            mem(33) <= "00000010";
            
            mem(34) <= "00000000";
            mem(35) <= "00000001";
            
            mem(36) <= "00000000";
            mem(37) <= "00000000";
            
            mem(38) <= "00000000";
            mem(39) <= "00000000";
            
         else
            if(wmem = '0') then
                mem_out <= mem(to_integer(unsigned(address))) & mem(to_integer(unsigned(address + 1)));
             else
                mem(to_integer(unsigned(address + 1))) <= mem_in(7 downto 0); -- escrita
                mem(to_integer(unsigned(address))) <= mem_in(15 downto 8);
            end if;
        end if;
        
    end process;
 
end Behavioral;
