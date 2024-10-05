library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

-- Entité REG_DCC : Un registre de trame DCC avec capacités de chargement et de décalage
entity REG_DCC is
  Port (
    clk100 : in std_logic;                    -- Horloge d'entrée à 100 MHz
    reset : in std_logic;                     -- Signal de réinitialisation
    
    trame : in std_logic_vector(50 downto 0); -- Trame d'entrée
    load : in std_logic;                      -- Signal de chargement
    shift : in std_logic;                     -- Signal de décalage
    
    msb_trame : out std_logic                 -- MSB (bit le plus significatif) de la trame
  );
end REG_DCC;

architecture Behavioral of REG_DCC is
signal sig_trame : std_logic_vector(50 downto 0); -- Signal interne pour stocker la trame
begin
    -- Processus principal pour le chargement et le décalage de la trame
    process(clk100, reset)
    begin
        if(reset = '1') then
            sig_trame <= (others => '0');     -- Réinitialisation du signal interne
        elsif(rising_edge(clk100)) then       -- Détection du front montant de l'horloge
            if(load = '1') then
                sig_trame <= trame;           -- Chargement de la trame dans le registre
            elsif(shift = '1') then
                sig_trame <= sig_trame(49 downto 0) & '0'; -- Décalage de la trame vers la droite
            end if;
        end if;
    end process;
    
    msb_trame <= sig_trame(50);               -- Assignation du MSB de la trame au signal de sortie
end Behavioral;
