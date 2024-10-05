library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entit� DCC_BIT0 : G�n�ration du bit '0' pour le protocole DCC
entity DCC_BIT0 is
  Port (
    GO_0, reset, clk100, clk : in std_logic;   -- Entr�es : GO_0, reset, horloge � 100 MHz, horloge principale
    FIN_0, DCC_0 : out std_logic               -- Sorties : FIN_0 signal de fin, DCC_0 bit DCC
  );
end DCC_BIT0;

architecture Behavioral of DCC_BIT0 is
signal cpt: integer range 0 to 2400000;        -- Compteur de temporisation

type etat is (START, CPTW, BIT0, FINISH);      -- D�claration des �tats de la machine � �tats
signal EP, EF: etat;                           -- Signaux pour l'�tat pr�sent (EP) et l'�tat futur (EF)

begin

-- Processus de comptage
process(clk, EP)
begin
  if EP = START then
    cpt <= 0;                                  -- R�initialisation du compteur en �tat START
  elsif (rising_edge(clk)) then
    if EP = CPTW or EP = BIT0 then
      cpt <= cpt + 1;                          -- Incr�mentation du compteur en �tat CPTW ou BIT0
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
process (EP)
begin
  case EP is 
    when START => 
      DCC_0 <= '0';                            -- Initialisation de la sortie DCC_0
      FIN_0 <= '0';                            -- Initialisation de la sortie FIN_0
    
    when CPTW =>  
      DCC_0 <= '0';
      FIN_0 <= '0';
                  
    when BIT0 =>  
      DCC_0 <= '1';                            -- Activation de DCC_0 en �tat BIT0
      FIN_0 <= '0';
                  
    when FINISH => 
      DCC_0 <= '0';                            -- D�sactivation de DCC_0 en �tat FINISH
      FIN_0 <= '1';                            -- Signal de fin FIN_0 activ�
    
    when others => 
      DCC_0 <= '0';
      FIN_0 <= '0';
  end case;
end process;

-- Processus de gestion des �tats
process (EP, cpt, reset, GO_0)
begin
  case EP is 
    when START => 
      EF <= START;
      if GO_0 = '1' then 
        EF <= CPTW;                            -- Transition vers CPTW si GO_0 est '1'
      end if;
    
    when CPTW =>  
      EF <= CPTW;
      if cpt = 100 then 
        EF <= BIT0;                            -- Transition vers BIT0 apr�s 100 cycles
      end if;
                  
    when BIT0 =>  
      EF <= BIT0;
      if cpt = 200 then 
        EF <= FINISH;                          -- Transition vers FINISH apr�s 200 cycles
      end if;
                  
    when FINISH => 
      EF <= START;                             -- Retour � l'�tat START apr�s FINISH
    
    when others => 
      EF <= START;                             -- �tat par d�faut : START
  end case;
end process; 

end Behavioral;
