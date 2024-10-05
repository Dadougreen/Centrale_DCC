----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.03.2024 09:53:22
-- Design Name: 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_reg_dcc is
end tb_reg_dcc;

architecture Behavioral of tb_reg_dcc is
signal clk100 : std_logic; 
signal reset : std_logic;
signal trame : std_logic_vector(50 downto 0) := "101010000000000000000000000000000000000000000000000";
signal load :std_logic;
signal shift : std_logic;
signal msb_trame : std_logic;
    
begin
reset <= '1', '0' after 2 ns;
shift <= '0', '1' after 15 ns;
load <= '0', '1' after 2 ns, '0' after 10 ns, '1' after 64 ns, '0' after 66 ns;

trame <= "110110000000000000000000000000000000000000000000000" after 60 ns;

reg_dcc : entity work.REG_DCC
            port map(clk100 => clk100,
                     reset => reset,
                     trame => trame,
                     load => load,
                     shift => shift,
                     msb_trame => msb_trame
                     );
                     
process
begin
    clk100 <= '0';
    wait for 5 ns;
    clk100 <= '1';
    wait for 5 ns;
end process;

end Behavioral;
