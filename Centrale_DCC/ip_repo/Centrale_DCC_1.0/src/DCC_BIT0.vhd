library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity DCC_BIT0 is
Port (GO_0, reset, clk100, clk : in std_logic;
      FIN_0, DCC_0 : out std_logic );
end DCC_BIT0;

architecture Behavioral of DCC_BIT0 is

signal cpt: integer range 0 to 2400000;						-- Compteur de Temporisation

type etat is (START, CPTW, BIT0, FINISH);		-- Etats de la MAE
signal EP,EF: etat;		

begin

process(clk, EP)
begin

if EP = START then
        cpt <= 0;
elsif (rising_edge(clk)) then
    if EP = CPTW then
        cpt <= cpt+1;
    elsif EP = BIT0 then
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

process (EP)

begin

case EP is 
    when START => DCC_0 <= '0';
                  FIN_0 <= '0';
    
    when CPTW =>  DCC_0 <= '0';
                  FIN_0 <= '0';
                  
    when BIT0 =>  DCC_0 <= '1';
                  FIN_0 <= '0';
                  
    when FINISH => DCC_0 <= '0';
                   FIN_0 <= '1';
    
    when others => DCC_0 <= '0';
                   FIN_0 <= '0';
end case;
end process;

process (EP, cpt, RESET, GO_0)

begin

case EP is 
    when START => EF <= START;
                  if GO_0 = '1' then EF <= CPTW;
                  end if;
    
    when CPTW =>  EF <= CPTW;
                  if cpt = 100 then EF <= BIT0;
                  end if;
                  
    when BIT0 =>  EF <= BIT0;
                  if cpt = 200 then EF <= FINISH;
                  end if;
                  
    when FINISH => 
                   EF <= START;
    
    when others => EF <= START;
end case;
end process; 
end Behavioral;
