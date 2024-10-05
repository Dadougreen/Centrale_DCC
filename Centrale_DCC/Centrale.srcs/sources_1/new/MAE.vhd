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
    clk100 : in std_logic;           -- Horloge d'entr�e � 100 MHz
    reset : in std_logic;            -- Signal de r�initialisation
    
    msb_trame : in std_logic;        -- MSB de la trame d'entr�e
    fin_tempo : in std_logic;        -- Signal de fin de temporisation
    fin_0 : in std_logic;            -- Signal de fin pour BIT0
    fin_1 : in std_logic;            -- Signal de fin pour BIT1
    
    load, shift : out std_logic;     -- Signaux de contr�le pour le chargement et le d�calage
    start_tempo : out std_logic;     -- Signal pour d�marrer la temporisation
    go_0 : out std_logic;            -- Signal pour BIT0
    go_1 : out std_logic             -- Signal pour BIT1
  );
end MAE;

architecture Behavioral of MAE is
signal cpt: integer range 0 to 240000;             -- Compteur de temporisation

type etat is (START, CPTW, BIT1, BIT0, ATT);       -- D�claration des �tats de la machine � �tats
signal EP, EF: etat;                               -- Signaux pour l'�tat pr�sent (EP) et l'�tat futur (EF)

begin

-- Processus de comptage
process(clk100)
begin
    if rising_edge(clk100) then
        if EP = CPTW then
            cpt <= cpt + 1;                       -- Incr�mentation du compteur en �tat CPTW
        elsif EP = START then
            cpt <= 0;                             -- R�initialisation du compteur en �tat START
        end if;
    end if;
end process;

-- Processus de transition d'�tat
process(clk100, reset) 
begin
    if reset ='1' then
        EP <= START;                              -- R�initialisation � l'�tat START
    elsif rising_edge(clk100) then 
        EP <= EF;                                 -- Transition vers l'�tat suivant
    end if;
end process;

-- Processus de logique de transition d'�tat
process (EP, cpt, fin_0, fin_1, msb_trame, fin_tempo)
begin
    case EP is 
        when START =>  
            EF <= CPTW;                           -- Transition vers l'�tat CPTW
            
        when CPTW =>  
            EF <= CPTW;
            if cpt = 51 then 
                EF <= ATT;                        -- Transition vers l'�tat ATT si cpt atteint 51
            elsif msb_trame = '1' then 
                EF <= BIT1;                       -- Transition vers BIT1 si msb_trame est '1'
            elsif msb_trame = '0' then 
                EF <= BIT0;                       -- Transition vers BIT0 si msb_trame est '0'
            end if;
                  
        when BIT0 =>  
            EF <= BIT0;
            if fin_0 = '1' then 
                EF <= CPTW;                       -- Transition vers CPTW si fin_0 est '1'
            end if;
                  
        when BIT1 =>  
            EF <= BIT1;
            if fin_1 = '1' then 
                EF <= CPTW;                       -- Transition vers CPTW si fin_1 est '1'
            end if;
                   
        when ATT =>  
            EF <= ATT;
            if fin_tempo = '1' then 
                EF <= START;                      -- Transition vers START si fin_tempo est '1'
            end if;
                    
        when others => 
            EF <= START;                          -- �tat par d�faut : START
    end case;
end process;

-- Processus de sortie bas� sur l'�tat actuel
process (EP) 
begin 
    case EP is
        when START =>  
            start_tempo <= '0';
            load <= '1';
            shift <= '0';
            go_0 <= '0';
            go_1 <= '0';
        
        when CPTW =>  
            start_tempo <= '0';
            load <= '0';
            shift <= '1';
            go_0 <= '0';
            go_1 <= '0';
                      
        when BIT0 =>  
            start_tempo <= '0';
            load <= '0';
            shift <= '0';
            go_0 <= '1';
            go_1 <= '0';
                      
        when BIT1 =>  
            start_tempo <= '0';
            load <= '0';
            shift <= '0';
            go_0 <= '0';
            go_1 <= '1';
                       
        when ATT =>   
            start_tempo <= '1';
            load <= '0';
            shift <= '0';
            go_0 <= '0';
            go_1 <= '0';
                        
        when others => 
            start_tempo <= '0';
            load <= '0';
            shift <= '0';
            go_0 <= '0';
            go_1 <= '0';
    end case;
end process; 

end Behavioral;
