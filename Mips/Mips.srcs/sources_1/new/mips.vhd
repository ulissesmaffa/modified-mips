
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.mipspkg.all;

entity mips is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           hlt : out std_logic
           );
end mips;

architecture Behavioral of mips is

   signal muxpc     : std_logic;
   signal opcode      : decoded_instruction;
   signal pcenable  : std_logic;
   signal pcinc     : std_logic;
   signal muxmem    : std_logic;
   signal wmem      : std_logic;
   signal wri       : std_logic;
   signal wreg      : std_logic;
   signal memreg    : std_logic;
   signal rx        : std_logic;
   signal muxula    : std_logic_vector(1 downto 0);
   signal ulaop     : std_logic_vector(1 downto 0);
   signal zero      : std_logic;
   signal wulaout   : std_logic;
   signal address   : std_logic_vector(7 downto 0);
   signal mem_in    : STD_LOGIC_VECTOR (15 downto 0);
   signal mem_out   : STD_LOGIC_VECTOR (15 downto 0);
   signal mumwmem   : std_logic;
begin

    controle : control_unit
        port map(
           clk      => clk,
           rst      => rst,
           hlt      => hlt,
           opcode   => opcode,
           muxpc    => muxpc,
           pcenable => pcenable,
           pcinc    => pcinc,
           muxmem   => muxmem,
           wmem     => wmem,
           wri      => wri,
           wreg     => wreg,
           memreg   => memreg,
           rx       => rx,
           muxula   => muxula,
           ulaop    => ulaop,
           zero     => zero,
           wulaout  => wulaout,
           mumwmem  => mumwmem
        );
        
    data_path : datapath
        port map(
           clk      =>   clk,
           rst      =>   rst,
           muxpc    =>   muxpc,
           opcode   =>   opcode,
           pcenable =>   pcenable,
           pcinc    =>   pcinc,
           muxmem   =>   muxmem,
           wmem     =>   wmem,
           wri      =>   wri,
           wreg     =>   wreg,
           memreg   =>   memreg,
           rx       =>   rx,
           muxula   =>   muxula,
           ulaop    =>   ulaop,
           zero     =>   zero,
           wulaout  =>   wulaout,
           data_in  =>   mem_out,
           address_out =>   address,
           data_out => mem_in,
           mumwmem  => mumwmem
        );
    
    memory : memoria
        port map(
           rst     => rst,   
           clk     => clk,    
           address => address,    
           mem_in  => mem_in,    
           mem_out => mem_out,    
           wmem    => wmem   
        );


end Behavioral;
