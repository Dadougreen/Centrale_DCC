library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top_DCC_Testbench is
end Top_DCC_Testbench;

architecture sim of Top_DCC_Testbench is
    -- Déclaration des signaux
    signal sw_tb : std_logic_vector(7 downto 0) := (others => '0'); -- Initialisation des valeurs des commutateurs
    signal clk100_tb : std_logic := '0';
    signal reset_tb : std_logic := '0';
    signal sortie_DCC_tb : std_logic;

    -- Constantes
    constant CLK_PERIOD : time := 10 ns; -- Période de l'horloge

    -- Composants à tester
    component Top_DCC is
        Port ( 
            sw : in STD_LOGIC_VECTOR (7 downto 0);
            clk100, reset : in std_logic;
            sortie_DCC : out std_logic
        );
    end component;

begin
    -- Instanciation du composant à tester
    DUT : Top_DCC
    port map (
        sw => sw_tb,
        clk100 => clk100_tb,
        reset => reset_tb,
        sortie_DCC => sortie_DCC_tb
    );

    -- Génération de l'horloge
    clk_process: process
    begin
            clk100_tb <= '0';
            wait for CLK_PERIOD / 2;
            clk100_tb <= '1';
            wait for CLK_PERIOD / 2;

    end process;

    -- Processus de reset
    reset_process: process
    begin
        reset_tb <= '1'; -- Activer le reset
        wait for 50 ns; -- Attendre quelques cycles d'horloge
        reset_tb <= '0'; -- Désactiver le reset
        wait;
    end process;

    -- Processus de test des entrées sw
    stimulus_process: process
    begin
        -- Tester différentes valeurs des commutateurs
        sw_tb <= "10000000"; -- Exemple de configuration des commutateurs
        wait for 100 ns;
        -- Ajouter d'autres tests si nécessaire
        wait for 10 ms;
        sw_tb <= "00010000";
        wait;
    end process;

end sim;
