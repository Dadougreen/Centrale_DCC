library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Top_DCC is
    Port ( sw : in STD_LOGIC_VECTOR (7 downto 0);
           clk100, reset : in std_logic;
           sortie_DCC : out std_logic);
end Top_DCC;


architecture Behavioral of Top_DCC is
    signal start_tempo, fin_tempo, go_1, fin_1, go_0, fin_0, dcc_1, dcc_0, clk, load, shift, msb : std_logic;
    signal trame_dcc : std_logic_vector(50 downto 0);
    
    
begin
    Clk_div : entity work.CLK_DIV port map(
                                           Clk_In => clk100,
                                           Reset  => reset,
                                           Clk_Out => clk);
    Mae : entity work.MAE port map(
                                    clk100 => clk100,
                                    reset => reset,
                                    msb_trame => msb,
                                    fin_tempo => fin_tempo,
                                    fin_0 => fin_0,
                                    fin_1 => fin_1,
                                    load => load,
                                    shift => shift,
                                    start_tempo => start_tempo,
                                    go_0 => go_0,
                                    go_1 => go_1);
                                    
    reg_dcc : entity work.REG_DCC port map(
                                            clk100 => clk100,
                                            reset => reset,
                                            trame => trame_dcc,
                                            load => load,
                                            shift => shift,
                                            msb_trame => msb);
                                            
    dcc_bit1 : entity work.DCC_BIT1 port map(
                                            clk100 => clk100,
                                            reset => reset,
                                            GO_1 => go_1,
                                            clk => clk,
                                            DCC_1 => DCC_1,
                                            FIN_1 => fin_1);

    tempo : entity work.COMPTEUR_TEMPO port map(
                                            Clk => clk100,
                                            Reset => reset,
                                            Clk1M => clk,
                                            Start_Tempo => start_tempo,
                                            Fin_Tempo => fin_tempo);
                                            
    dcc_bit0 : entity work.DCC_BIT0 port map(
                                            clk100 => clk100,
                                            reset => reset,
                                            GO_0 => go_0,
                                            clk => clk,
                                            DCC_0 => DCC_0,
                                            FIN_0 => fin_0);
                                            
    frame_gen : entity work.DCC_FRAME_GENERATOR port map(
                                            Interrupteur => sw,
                                            Trame_DCC => trame_dcc);

    sortie_dcc <= '1' when dcc_1 ='1' or dcc_0 ='1' else '0';                                           
end Behavioral;
