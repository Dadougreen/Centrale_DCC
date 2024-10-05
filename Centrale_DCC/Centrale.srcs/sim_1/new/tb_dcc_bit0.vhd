----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.03.2024 09:53:22
-- Design Name: 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_dcc_bit0 is
end entity;

architecture Behavioral of tb_dcc_bit0 is
signal GO_0 : std_logic; 
signal reset : std_logic;
signal clk100 : std_logic;
signal clk :std_logic;
signal FIN_0 : std_logic;
signal DCC_0 : std_logic;
    
begin
reset <= '1', '0' after 2 ns;
GO_0 <= '0', '1' after 15 ns;


DCC_BIT0 : entity work.DCC_BIT0
            port map(GO_0 => GO_0,
                     reset => reset,
                     clk100 => clk100,
                     clk => clk,
                     FIN_0 => FIN_0,
                     DCC_0 => DCC_0
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
