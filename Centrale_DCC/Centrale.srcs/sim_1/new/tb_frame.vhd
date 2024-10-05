library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity testbench_dcc_fg is
--  Port ( );
end testbench_dcc_fg;

architecture Behavioral of testbench_dcc_fg is
signal Interrupteur : std_logic_vector(7 downto 0);
signal Trame_DCC : std_logic_vector(50 downto 0);

begin

frame_generator : entity work.DCC_FRAME_GENERATOR
    port map(Interrupteur,Trame_DCC);

process
begin
Interrupteur <= "10000000";

wait for 10 ns;
Interrupteur <= "01000000";

wait for 10 ns;
Interrupteur <= "00100000" ;

wait for 10 ns;
Interrupteur <= "00010000" ;

wait for 10 ns;
Interrupteur <= "00001000" ;

wait for 10 ns;
Interrupteur <= "00000100" ;

wait for 10 ns;
Interrupteur <= "00000010" ;

wait for 10 ns;
Interrupteur <= "00000001" ;

wait for 10 ns;
Interrupteur <= "00000000" ;

wait;
end process;

end Behavioral;