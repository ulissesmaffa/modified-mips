
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.numeric_std.ALL;
library work;
use work.mipspkg.all;

entity datapath is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           muxpc: in STD_LOGIC;
           opcode : out decoded_instruction;
           pcenable: in std_logic;
           pcinc: in std_logic;
           muxmem: in std_logic;
           wmem: in std_logic;
           wri: in std_logic;
           wreg : in std_logic;
           memreg: in std_logic;
           rx: in std_logic;
           muxula: in std_logic_vector(1 downto 0);
           ulaop: in std_logic_vector(1 downto 0);
           zero: out std_logic;
           wulaout: in std_logic;
           data_in: in std_logic_vector(15 downto 0);
           data_out: out std_logic_vector(15 downto 0);
           address_out: out std_logic_vector(7 downto 0);
           mumwmem: in std_logic
          );
end datapath;

architecture Behavioral of datapath is

    type ra is array (0 to 1) of std_logic_vector(15 downto 0);
    signal R : ra;
    
    signal muxpc_out : std_logic_vector(7 downto 0);
    signal pc_out : std_logic_vector(7 downto 0);
    signal muxmem_out : std_logic_vector(7 downto 0);
    signal mem_out : std_logic_vector(15 downto 0);
    signal ri_out : std_logic_vector(15 downto 0);
    signal rd_out : std_logic_vector(15 downto 0);
    signal muxmemreg_out : std_logic_vector(15 downto 0);
    signal reg_out : std_logic_vector(15 downto 0);
    signal rx_out : std_logic_vector(15 downto 0);
    signal muxula_out : std_logic_vector(15 downto 0);
    signal ula_out : std_logic_vector(15 downto 0);
    signal ulareg_out : std_logic_vector(15 downto 0);
    signal add_out : std_logic_vector(7 downto 0);


begin

-- mux pc
muxpc_out <= add_out when muxpc = '0' else 
              ri_out(7 downto 0) when muxpc = '1';
              
opcode <= ILOAD   when ri_out(15 downto 12) = "0000" else
          ISTORE  when ri_out(15 downto 12) = "0001" else
          IADD    when ri_out(15 downto 12) = "0010" else
          ISUB    when ri_out(15 downto 12) = "0011" else
          IJMP    when ri_out(15 downto 12) = "0100" else
          IBZ     when ri_out(15 downto 12) = "0101" else
          IDEC    when ri_out(15 downto 12) = "0110" else
          IADDSW    when ri_out(15 downto 12) = "0111" else
          IHALT   when ri_out(15 downto 12) = "1111";
          
pc: process(clk)
begin 
   if (rst = '1') then
       pc_out <= (others => '0');
   elsif (clk'event and clk = '1') then
       if (pcenable = '1') then
           pc_out <= muxpc_out;
       end if;    
   end if; 
end process pc;


incrementa: process(clk)
begin 
   if (rst = '1') then
       add_out <= (others => '0');
   elsif (clk'event and clk = '1') then
       if (pcinc = '1') then
           add_out <= pc_out + 2;
       end if;    
   end if; 
end process incrementa;

-- mux mem
address_out <= ri_out(7 downto 0) when muxmem = '1' else 
              pc_out when muxmem = '0'; 
              
              
RI: process(clk)
begin 
   if (rst = '1') then
       ri_out <= (others => '0');
   elsif (clk'event and clk = '1') then
       if (wri = '1') then
           ri_out <= data_in;
       end if;    
   end if; 
end process RI; 

REG: process(clk)
begin 
   if (rst = '1') then
       rd_out <= (others => '0');
   elsif (clk'event and clk = '1') then
       if (wreg = '1') then
           if (ri_out(11) = '0') then
               R(0) <= muxmemreg_out;
           elsif (ri_out(11) = '1') then
               R(1) <= muxmemreg_out;
           end if;
       end if;  
   end if; 
end process REG;      

reg_out <= R(0) when ri_out(11) = '0' else
           R(1) when ri_out(11) = '1';

-- mux reg w
muxmemreg_out <= data_in when memreg = '0' else 
              ulareg_out when memreg = '1'; 


RX_REG: process(clk)
begin 
   if (rst = '1') then
       rx_out <= (others => '0');
   elsif (clk'event and clk = '1') then
       if (rx = '1') then
           rx_out <= reg_out;
       end if;    
   end if; 
end process RX_REG;             


-- mux ula 
muxula_out <= (others => '0') when muxula = "01" else 
              data_in(15 downto 0) when muxula = "00" else
              "0000000000000001" when muxula = "10"; 
              
-- ULA
ula_out <= rx_out + muxula_out when ulaop = "00" else
           rx_out - muxula_out when ulaop = "01";
           
zero <= '1' when ula_out = "0000000000000000" else '0';     


data_out <= rx_out when mumwmem = '0' else
            ulareg_out when mumwmem = '1';
 
ULAOUT: process(clk)
begin 
   if (rst = '1') then
       ulareg_out <= (others => '0');
   elsif (clk'event and clk = '1') then
       if (wulaout = '1') then
           ulareg_out <= ula_out;
       end if;    
   end if; 
end process ULAOUT;  
 
end Behavioral;
