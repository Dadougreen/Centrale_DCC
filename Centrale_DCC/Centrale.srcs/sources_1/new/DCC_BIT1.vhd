library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entit� DCC_BIT1 : G�n�ration du bit '1' pour le protocole DCC
entity DCC_BIT1 is
  Port (
    GO_1, reset, clk100, clk : in std_logic;   -- Entr�es : GO_1, reset, horloge � 100 MHz, horloge principale
    FIN_1, DCC_1 : out std_logic               -- Sorties : FIN_1 signal de fin, DCC_1 bit DCC
  );
end DCC_BIT1;

architecture Behavioral of DCC_BIT1 is
signal cpt: integer range 0 to 2400000;        -- Compteur de temporisation

type etat is (START, CPTW, BIT1, FINISH);      -- D�claration des �tats de la machine � �tats
signal EP, EF: etat;                           -- Signaux pour l'�tat pr�sent (EP) et l'�tat futur (EF)

begin

-- Processus de comptage
process(clk, EP)
begin
  if EP = START then
    cpt <= 0;                                  -- R�initialisation du compteur en �tat START
  elsif (rising_edge(clk)) then
    if EP = CPTW or EP = BIT1 then
      cpt <= cpt + 1;                          -- Incr�mentation du compteur en �tat CPTW ou BIT1
    end if;
  end if;
end process;

-- Processus de transition d'�tat
process(clk100, reset) 
begin
  if reset ='1' then
    EP <= START;                               -- R�initialisation � l'�tat START
  elsif rising_edge(clk100) then 
    EP <= EF;                                  -- Transition vers l'�tat suivant
  end if;
end process;

-- Processus de logique de transition d'�tat
process (EP, cpt, reset, GO_1)
begin
  case EP is 
    when START => 
      EF <= START;
      if GO_1 = '1' then 
        EF <= CPTW;                            -- Transition vers CPTW si GO_1 est '1'
      end if;
    
    when CPTW =>  
      EF <= CPTW;
      if cpt = 58 then 
        EF <= BIT1;                            -- Transition vers BIT1 apr�s 58 cycles
      end if;
                  
    when BIT1 =>  
      EF <= BIT1;
      if cpt = 116 then 
        EF <= FINISH;                          -- Transition vers FINISH apr�s 116 cycles
      end if;
                  
    when FINISH => 
      EF <= START;                             -- Retour � l'�tat START apr�s FINISH
    
    when others => 
      EF <= START;                             -- �tat par d�faut : START
  end case;
end process;

-- Processus de sortie bas� sur l'�tat actuel
process (EP)
begin
  case EP is 
    when START => 
      DCC_1 <= '0';
      FIN_1 <= '0';
    
    when CPTW =>  
      DCC_1 <= '0';
      FIN_1 <= '0';
                  
    when BIT1 =>  
      DCC_1 <= '1';
      FIN_1 <= '0';
                  
    when FINISH => 
      DCC_1 <= '0';
      FIN_1 <= '1';
    
    when others => 
      DCC_1 <= '0';
      FIN_1 <= '0';
  end case;
end process;

end Behavioral;
