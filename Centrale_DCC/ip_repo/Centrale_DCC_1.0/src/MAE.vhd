----------------------------------------------------------------------------------
-- Company: UPMC
-- Engineer: LYAUTEY Wilfrid
-- 
-- Create Date: 18.03.2024 11:15:48
-- Design Name: 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MAE is
  Port (
    clk100 : in std_logic;
    reset : in std_logic;
    
    msb_trame : in std_logic;
    fin_tempo : in std_logic;
    fin_0 : in std_logic;
    fin_1 : in std_logic;
    
    load, shift : out std_logic;
    start_tempo : out std_logic;
    go_0 : out std_logic;
    go_1 : out std_logic
    
  );
end MAE;

architecture Behavioral of MAE is
signal cpt: integer range 0 to 240000;						-- Compteur de Temporisation

type etat is (START, CPTW, BIT1, BIT0, ATT);		-- Etats de la MAE
signal EP,EF: etat;		

begin

process(clk100)
begin

if rising_edge(clk100) then
    if EP = CPTW then
        cpt <= cpt+1;
    elsif EP = START then
         cpt <= 0;
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

process (EP, cpt, FIN_0, FIN_1, MSB_trame, fin_tempo)

begin

case EP is 
    when START =>  EF <= CPTW;
         
    
    when CPTW =>  EF <= CPTW;
                  if cpt = 51 then EF <= ATT;
                  elsif msb_trame ='1' then EF <= BIT1; -- cpt < 50
                  elsif msb_trame ='0' then EF <= BIT0; -- cpt < 50
                  end if;
                  
    when BIT0 =>  EF <= BIT0;
                  if FIN_0 ='1' then EF <= CPTW;
                  end if;
                  
    when BIT1 =>   EF <= BIT1;
                   if FIN_1 ='1' then EF <= CPTW;
                   end if;
                   
    when ATT =>     EF <= ATT;
                    if fin_tempo = '1' then EF <= START;
                    end if;
                    
    when others => EF <= START;
                   
end case;
end process;

process (EP) 

begin 

    case EP is
        when START =>  start_tempo <='0';
                      load <=  '1';
                      shift <= '0';
                      GO_0 <=  '0';
                      GO_1 <=  '0';
             
        
        when CPTW =>  start_tempo <='0';
                      load <=  '0';
                      shift <= '1';
                      GO_0 <=  '0';
                      GO_1 <=  '0';
                      
        when BIT0 =>  start_tempo <='0';
                      load <=  '0';
                      shift <= '0';
                      GO_0 <=  '1';
                      GO_1 <=  '0';
                      
        when BIT1 =>  start_tempo <='0';
                      load <=  '0';
                      shift <= '0';
                      GO_0 <=  '0';
                      GO_1 <=  '1';
                       
        when ATT =>   start_tempo <='1';
                      load <=  '0';
                      shift <= '0';
                      GO_0 <=  '0';
                      GO_1 <=  '0';
                        
        when others => start_tempo <='0';
                      load <=  '0';
                      shift <= '0';
                      GO_0 <=  '0';
                      GO_1 <=  '0';
                       
    end case;
end process; 

end Behavioral;
