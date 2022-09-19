
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package mipspkg is

    type decoded_instruction is (ILOAD, ISTORE, IADD, ISUB, IDEC, IADDSW, IJMP, IBZ, IHALT);

    component mips
		port (
			clk  : in  std_logic;
			rst  : in  std_logic;
			hlt  : out std_logic
		);
	end component;
	
	component control_unit
        port(
           clk      : in STD_LOGIC;
           rst      : in STD_LOGIC;
           hlt      : out STD_LOGIC;
           opcode   : in decoded_instruction;
           muxpc    : out STD_LOGIC;
           pcenable : out std_logic;
           pcinc    : out std_logic;
           muxmem   : out std_logic;
           wmem     : out std_logic;
           wri      : out std_logic;
           wreg     : out std_logic;
           memreg   : out std_logic;
           rx       : out std_logic;
           muxula   : out std_logic_vector(1 downto 0);
           ulaop    : out std_logic_vector(1 downto 0);
           zero     : in std_logic;
           wulaout  : out std_logic;
           mumwmem  : out std_logic
		);
	end component;
	
	component datapath
        port(
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           muxpc: in STD_LOGIC;
           opcode      : out decoded_instruction;
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
	end component;
	
	component memoria
        port(
           rst          : in STD_LOGIC;
           clk          : in STD_LOGIC;
           address      : in std_logic_vector(7 downto 0);
           mem_in       : in STD_LOGIC_VECTOR (15 downto 0);
           mem_out      : out STD_LOGIC_VECTOR (15 downto 0);
           wmem         : in std_logic
		);
	end component;

end mipspkg;

package body mipspkg is
end mipspkg;
