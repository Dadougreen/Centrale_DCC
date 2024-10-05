library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity DCC_BIT1 is
Port (GO_1, reset, clk100, clk : in std_logic;
      FIN_1, DCC_1 : out std_logic );
end DCC_BIT1;

architecture Behavioral of DCC_BIT1 is

signal cpt: integer range 0 to 2400000;						-- Compteur de Temporisation

type etat is (START, CPTW, BIT1, FINISH);		-- Etats de la MAE
signal EP,EF: etat;		

begin

process(clk, EP)
begin

if EP = START then
        cpt <= 0;
elsif (rising_edge(clk)) then
    if EP = CPTW then
        cpt <= cpt+1;
    elsif EP = BIT1 then
        cpt <= cpt+1;

    end if;
end if;

end process;

process (clk100, reset) 
begin

if reset ='1' then
    EP <= START;
elsif rising_edge(clk100) then 
    EP <= EF;

    
end if;

end process;

process (EP, cpt, RESET, GO_1)

begin

case EP is 
    when START => EF <= START;
                  if GO_1 = '1' then EF <= CPTW;
                  end if;
    
    when CPTW =>  EF <= CPTW;
                  if cpt = 58 then EF <= BIT1;
                  end if;
                  
    when BIT1 =>  EF <= BIT1;
                  if cpt = 116 then EF <= FINISH;
                  end if;
                  
    when FINISH => 
                   EF <= START;
    
    when others => EF <= START;
end case;
end process;

process (EP)

begin

case EP is 
    when START => DCC_1 <= '0';
                  FIN_1 <= '0';
    
    when CPTW =>  DCC_1 <= '0';
                  FIN_1 <= '0';
                  
    when BIT1 =>  DCC_1 <= '1';
                  FIN_1 <= '0';
                  
    when FINISH => DCC_1 <= '0';
                   FIN_1 <= '1';
    
    when others => DCC_1 <= '0';
                   FIN_1 <= '0';
end case;
end process;
 
end Behavioral;
