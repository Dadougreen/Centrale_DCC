----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.03.2024 09:53:22
-- Design Name: 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_dcc_bit1 is
end entity;

architecture Behavioral of tb_dcc_bit1 is
signal GO_1 : std_logic; 
signal reset : std_logic;
signal clk100 : std_logic;
signal clk :std_logic;
signal FIN_1 : std_logic;
signal DCC_1 : std_logic;
    
begin
reset <= '1', '0' after 2 ns;
GO_1 <= '0', '1' after 15 ns;


DCC_BIT1 : entity work.DCC_BIT1
            port map(GO_1 => GO_1,
                     reset => reset,
                     clk100 => clk100,
                     clk => clk,
                     FIN_1 => FIN_1,
                     DCC_1 => DCC_1
                     );
                     
process
begin
    clk100 <= '0';
    wait for 5 ns;
    clk100 <= '1';
    wait for 5 ns;
end process;

process
begin
    clk <= '0';
    wait for 500 ns;
    clk <= '1';
    wait for 500 ns;
end process;

end Behavioral;
