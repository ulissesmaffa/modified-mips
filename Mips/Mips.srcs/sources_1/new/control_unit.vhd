
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.mipspkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control_unit is
    Port ( clk      : in STD_LOGIC;
           rst      : in STD_LOGIC;
           hlt      : out STD_LOGIC;
           --opcode   : in std_logic_vector(3 downto 0);
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
end control_unit;

architecture Behavioral of control_unit is

    type estado is (INICIAL, BUSCA1, DECODIFICA, LOAD1, LOAD2, STORE1, STORE2, ADD1, ADD2, ADD3, SUB1, 
    SUB2, SUB3, DEC1, DEC2, DEC3, DEC4, DEC5, ADDSW1, ADDSW2, ADDSW3, JMP1, JMP2, BZ1, BZ2, BZ3, HALT); 
    signal jose: estado;
    begin
    
    muda_estado : process(clk)
    begin
        
        if (rst = '1') then
            jose <= INICIAL;
        elsif (clk'event and clk='1') then
            case jose is
                when INICIAL =>
                    jose <= BUSCA1;
                when BUSCA1 =>
                    jose <= DECODIFICA;
                when DECODIFICA =>                   
                    if(opcode = ILOAD) then    --LOAD
                        jose <= LOAD1;
                    elsif(opcode = ISTORE) then --STORE
                        jose <= STORE1;
                    elsif(opcode = IADD) then -- ADD
                        jose <= ADD1;
                    elsif(opcode = ISUB) then -- SUB
                        jose <= SUB1;
                        
                    elsif(opcode = IDEC) then -- DEC
                        jose <= DEC1;
                    elsif(opcode = IADDSW) then -- BZ
                        jose <= ADDSW1;
                        
                    elsif(opcode = IJMP) then -- JMP
                        jose <= JMP1;
                    elsif(opcode = IBZ) then -- BZ
                        jose <= BZ1;
                    elsif(opcode = IHALT) then -- HALT
                        jose <= HALT;
                    end if;
                when LOAD1 =>
                    jose <= LOAD2;
                when LOAD2 =>
                    jose <= INICIAL;
                when STORE1 =>
                    jose <= STORE2;
                when STORE2 =>
                    jose <= INICIAL;
                when ADD1 =>
                    jose <= ADD2;
                when ADD2 =>
                    jose <= ADD3;
                when ADD3 =>
                    jose <= INICIAL;
                when SUB1 =>
                    jose <= SUB2;
                when SUB2 =>
                    jose <= SUB3;    
                when SUB3 =>
                    jose <= INICIAL;    
                
                when DEC1 =>
                    jose <= DEC2;
                when DEC2 =>
                    jose <= DEC3;
                when DEC3 =>
                    jose <= DEC4;
                when DEC4 =>
                    jose <= DEC5;
                when DEC5 =>
                    jose <= INICIAL;
                when ADDSW1 =>
                    jose <= ADDSW2;
                when ADDSW2 =>
                    jose <= ADDSW3;
                when ADDSW3 =>
                    jose <= INICIAL;
                                
                when JMP1 =>
                    jose <= JMP2;
                when JMP2 =>
                    jose <= INICIAL;
                when BZ1 =>
                    jose <= BZ2;
                when BZ2 =>
                    if(zero = '0') then
                        jose <= INICIAL;
                    else
                        jose <= BZ3;
                     end if;
                when BZ3 =>
                    jose <= INICIAL;
                when HALT =>
                    jose <= HALT;
                when others =>
                     jose <= INICIAL;        
             end case;
        end if;
    end process muda_estado;
    
    maquina_estados: process(jose)
    begin
    
        case jose is
            when INICIAL =>
               hlt <= '0';
               muxpc <= '0';
               pcenable <= '0';
               pcinc <= '1';
               muxmem <= '0';
               wri <= '1';
               wreg <= '0';
               wmem <= '0';
               memreg <= '0';
               rx <= '0';
               muxula <= "00";
               ulaop <= "00"; -- ADD na ULA
               wulaout <= '0';
               mumwmem  <= '0';
            when BUSCA1 =>
                pcinc <= '0';
                pcenable <= '1';
                wri <= '0';
            when DECODIFICA =>
                wri <= '0';
                muxmem <= '1';
                pcenable <= '0';
                rx <= '1';
            when LOAD1 =>
                rx <= '0';
                wreg <= '0';     
            when LOAD2 =>
                wreg <= '1';
            when STORE1 =>
                --wmem <= '0';
                rx <= '0';
            when STORE2 =>
                wmem <= '1';
                muxmem <= '1';
            when ADD1 =>
                ulaop <= "00";
                wulaout <= '0';
                rx <= '0';
            when ADD2 =>
                wulaout <= '1';
            when ADD3 =>
                wulaout <= '0';
                memreg <= '1';
                wreg <= '1';
            when SUB1 =>
                ulaop <= "01";
                wulaout <= '0';
                rx <= '0';
            when SUB2 =>
                wulaout <= '1';
            when SUB3 =>
                wulaout <= '0';
                memreg <= '1';
                wreg <= '1';
                
            when DEC1 =>
                rx <= '0';
                wreg <= '1';
            when DEC2 =>
                rx <= '1';
            when DEC3 =>
                rx <= '0';
                ulaop <= "01";
                muxula <= "10";
            when DEC4 =>
                wulaout <= '1';
            when DEC5 =>
                wulaout <= '0';
                mumwmem <= '1';
                wmem <= '1';  
                wreg <= '1';
                memreg <= '1';
            when ADDSW1 =>
                ulaop <= "00";
                wulaout <= '0';
                rx <= '0'; 
            when ADDSW2 =>
                wulaout <= '1';
            when ADDSW3 =>
                mumwmem <= '1';
                wmem <= '1'; 
            when JMP1 =>
                muxpc <= '1';
                pcenable <= '1';
                rx <= '0';
            when JMP2 =>
                muxpc <= '0';
                pcenable <= '0';
            when BZ1 =>
                rx <= '0';
                ulaop <= "00";
                muxula <= "00";
                wulaout <= '0';
            when BZ2 =>
                muxula <= "01";
                wulaout <= '1';
            when BZ3 =>
                pcenable <= '1';
                muxpc <= '1';
                wulaout <= '0';
            when HALT =>
                hlt <= '1';
      
        end case;
    
    end process maquina_estados;


end Behavioral;
