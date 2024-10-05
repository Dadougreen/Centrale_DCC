
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_mae is
end tb_mae;

architecture Behavioral of tb_mae is
signal clk100 : std_logic; 
signal reset : std_logic;

signal fin_0 :std_logic;
signal fin_1 : std_logic;
signal load :std_logic;
signal shift : std_logic;
signal fin_tempo :std_logic;
signal start_tempo : std_logic;
signal go_1 :std_logic;
signal go_0 : std_logic;

signal msb_trame : std_logic;
    
begin
reset <= '1', '0' after 2 ns;
fin_0 <= '1';
fin_1 <= '1'; 
msb_trame <= '0', '1' after 20 ns;
Fin_tempo <= '1';

mae : entity work.MAE
            port map(clk100 => clk100,
                     reset => reset,
                     msb_trame => msb_trame,
                     fin_tempo => fin_tempo,
                     fin_0 => fin_0,
                     fin_1 => fin_1,
                     load => load,
                     shift => shift,
                     start_tempo => start_tempo,
                     go_0 => go_0,
                     go_1 => go_1
                     );
                     
process
begin
    clk100 <= '0';
    wait for 5 ns;
    clk100 <= '1';
    wait for 5 ns;
end process;


end Behavioral;